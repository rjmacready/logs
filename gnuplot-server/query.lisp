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

; id|cmdid|function_name|lnr|cost
; id|cmdid|function_name|lnr|cost|filename

(defun profile-line-function-model (id function-name)
  (let ((rows (clsql:query 
	       (format nil "
   select 1 as iscall, id, cmdid, function_name, lnr, cost, '' as filename
   from profilecallstore
   where cmdid = ~a and function_name = '~a'
      union all
   select 0 as iscall, id, cmdid, function_name, lnr, cost, filename
   from profileinvstore
   where cmdid = ~a and function_name = '~a'

;
" id function-name id function-name))))
    
    (mapcar
     (lambda (row)
       `((:iscall . ,(first row))
	 (:id . ,(second row))
	 (:cmdid . ,(third row))
	 (:function-name . ,(fourth row))
	 (:lnr . ,(fifth row))
	 (:cost . ,(sixth row))
	 (:filename . ,(seventh row))))
     rows)))

(defun condition-to-sql (condition)
  (when (null condition)
    (error "No condition!"))
  nil)

(defun conditions-to-sql (conditions)
  (if (null conditions)
      nil
      (mapcar
       #'condition-to-sql
       conditions)))

(defun files-spent-model (id &optional (conditions nil))  
  (declare (ignore conditions))
  (let ((rows (clsql:query (format nil "
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
   where cmdid = ~a
   group by function_name) aux left join (
      select function_name, sum(cost) sumCost
      from profileinvstore
      where cmdid = ~a
      group by function_name
   ) aux2 on aux.function_name = aux2.function_name
order by sumSelfCost desc ;" id id)))) ;  limit 25
    (mapcar
     (lambda (row)
       (let ((function-name (first row))
	     (sum-self-cost (second row))
	     (nr-invocations (third row))
	     (avg-cost (fourth row))
	     (ratio-cost (fifth row))
	     (sum-incl-cost (sixth row))
	     (ratio-incl-cost (seventh row)))
	 
	 `((:function-name . ,function-name)
	   (:sum-self-cost . ,sum-self-cost)
	   (:nr-invocations . ,nr-invocations)
	   (:avg-cost . ,avg-cost)
	   (:ratio-cost . ,ratio-cost)
	   (:sum-incl-cost . ,sum-incl-cost)
	   (:ratio-incl-cost . ,ratio-incl-cost))))
     rows)))



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

(defun get-info-files-memory (id)
  (clsql:with-database (clsql:*default-database* (list "/home/user/logs/logs.db") :database-type :sqlite3)
    (let* ((rows (clsql:query
		  (format nil "SELECT id, timeoffset, memory FROM tracelinestore WHERE traceid = ~a ;" id)))
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

(defun to-dat-file (output filename)
  (with-open-stream (*standard-output* (open filename :direction :output :if-exists :supersede))
    (mapc
     (lambda (row)
       (loop for c in row
	    do (let ((c1 (cdr c)))
		 ;(format T "~S" (type-of c1))
		 (typecase c1
		   (double-float (format T "~,8f" c1))
		   (otherwise (format T "~S" c1))))
	    when (cdr c) do (write-char #\Space))
       (write-char #\Newline)
       nil)
     output)
    nil))

(defun make-dat-files-memory ()
  ;(clsql:with-database (clsql:*default-database* (list "/home/user/logs/logs.db") :database-type :sqlite3)
    (let ((traces (clsql:query "SELECT id FROM tracestore; "))) ;  WHERE id = 9
      (mapc 
       (lambda (trace)
	 ;(print `(trace ,trace))
	 (let ((traceid (car trace)))
	   (to-dat-file (get-info-files-memory traceid) (format nil "trace.~a.out" traceid)))) 
       traces)
      nil));)

(when nil
  (make-dat-files-memory))
