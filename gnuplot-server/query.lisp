					; number of calls to user defined functions

(eval-when (:compile-toplevel)
  (ql:quickload 'clsql-sqlite3))


(defun make-dat-files-profiling ()
  (clsql:with-database (clsql:*default-database* (list "/home/user/logs/logs.db") :database-type :sqlite3)
    (let ((rows (clsql:query "
select
   aux.function_name,
   sumSelfCost,
   nrInvocations,
   avgCost,
   ratioCost,
   sumSelfCost + coalesce(sumCost, 0) as sumInclCost,
   sumSelfCost / (1.0 * sumSelfCost + coalesce(sumCost, 0)) as ratioInclCost
from (
   select
      function_name,
      sum(cost) sumSelfCost,
      count(*) nrInvocations,
      avg(cost) avgCost,
      avg(cost) / sum(cost) ratioCost
   from profilecallstore
   where cmdid = 50
   group by function_name) aux left join (
      select function_name, sum(cost) sumCost
      from profileinvstore
      where cmdid = 50
      group by function_name
   ) aux2 on aux.function_name = aux2.function_name
order by sumSelfCost desc ;"))) ;  limit 25
      (with-open-stream (*standard-output* (open "out_p.dat" :direction :output :if-exists :supersede))
	(mapc
	 (lambda (row)
	   (let ((function_name (first row))
		 (sumSelfCost (second row))
		 (nrInvocations (third row))
		 (avgCost (fourth row))
		 (ratioCost (fifth row))
		 (sumInclCost (sixth row))
		 (ratioInclCost (seventh row)))
	     (write-string (format nil "~s ~d ~d ~f ~f ~d ~f" 
				   function_name
				   sumSelfCost
				   nrInvocations
				   avgCost
				   ratioCost
				   sumInclCost
				   ratioInclCost))
	     (write-char #\Newline)))
	 rows)
	nil))))

;(make-dat-files-profiling)

(defun make-dat-files-calls ()
  (clsql:with-database (clsql:*default-database* (list "/home/user/logs/logs.db") :database-type :sqlite3)
    (let ((rows (clsql:query "select function_name, ct from (select function_name, count(*) as ct from tracelinestore where kind = 1 and traceid = 9 and deftype = 2 group by function_name) aux order by ct desc;")))
      (with-open-stream (*standard-output* (open "out_c.dat" :direction :output :if-exists :supersede))

	(mapc
	 (lambda (row)
	   (let ((function-name (first row))
		 (calls (second row)))
	     (write-string (format nil "\"~a\" ~a" function-name calls))
	     (write-char #\Newline)))
	rows))
      nil)))

;(make-dat-files-calls)

(defun traceline-model (id)
  (let* ((rows (clsql:query
	       (format nil "SELECT id, traceid, level, function_no, kind, timeoffset, memory, function_name, deftype, filename, included, lineno, parent FROM tracelinestore WHERE id = ~a" id)))
	 (row (car rows))) 
    (let ((id (first row))
	  (traceid (second row))
	  (level (third row))
	  (function_no (fourth row))
	  (kind (fifth row))
	  (timeoffset (sixth row))
	  (memory (seventh row))
	  (function_name (eighth row))
	  (ddeftype (ninth row))
	  (filename (tenth row))
	  (included (nth 10 row))
	  (lineno (nth 11 row))
	  (parent (nth 12 row)))
      `((:id . ,id)
	(:traceid . ,traceid)
	(:level . ,level)
	(:function_no . ,function_no)
	(:kind . ,kind)
	(:timeoffset . ,timeoffset)
	(:memory . ,memory)
	(:function_name . ,function_name)
	(:deftype . ,ddeftype)
	(:filename . ,filename)
	(:included . ,included)
	(:lineno . ,lineno)
	(:parent . ,parent)))))

(defun get-info-files-memory ()
  (clsql:with-database (clsql:*default-database* (list "/home/user/logs/logs.db") :database-type :sqlite3)
    (let* ((rows (clsql:query
		  (format nil "SELECT id, timeoffset, memory FROM tracelinestore WHERE traceid = 9 ;")))
	   (lastmem (third (car rows))))
      (mapcar
       (lambda (row)
	 (let ((id (first row))				
	       (timeoffset (second row))
	       (memory (third row)))
	   (prog1
	       `((:id . ,id)
		 (:timeoffset . ,timeoffset)
		 (:memory . ,memory)
		 (:memorydelta . ,(- memory lastmem)))
	     (setf lastmem memory))))
       rows))))


(defun make-dat-files-memory ()
  (clsql:with-database (clsql:*default-database* (list "/home/user/logs/logs.db") :database-type :sqlite3)
    (let ((traces (clsql:query "SELECT id FROM tracestore WHERE id = 9")))
      (mapc 
       (lambda (trace)
	 ;(print `(trace ,trace))
	 (let ((traceid (car trace)))
	   (with-open-stream (*standard-output* (open (format nil "out_mem_~a.dat" traceid) :direction :output :if-exists :supersede))
	     (let ((c 0)
		   (i 1))
	       (loop 
		  for x from 0 by 10000 
		  do (progn
		       (setf c 0)
		       (let ((rows (clsql:query
				    (format nil "SELECT traceid, id, timeoffset, memory, level FROM tracelinestore WHERE traceid = ~a limit ~a, 10000;" traceid x))))
			 (mapc 
			  (lambda (row)
			    (setf c (1+ c))
			    (setf i (1+ i))
			    (write-string 
			     (format nil "~a ~a ~f ~a ~a ~a ~a" 
				     (nth 0 row)
				     (nth 1 row)
				     (nth 2 row)
				     (nth 3 row)
				     i
				     (nth 4 row)
				     #\Newline)))
			  rows)
			 nil))
		  while (eq c 10000)))))) 
       traces)
      nil)))

;(make-dat-files-memory)
