(ql:quickload 'clsql-sqlite3)
(clsql:connect (list "/home/user/logs/logs.db") :database-type :sqlite3)

(defun make-dat-files ()
  (let ((traces (clsql:query "SELECT id FROM tracestore")))
    (mapc 
     (lambda (trace)
       (print `(trace ,trace))
       (let ((traceid (car trace)))
	 (with-open-stream (*standard-output* (open (format nil "out_~a.dat" traceid) :direction :output :if-exists :supersede))
	   (let ((*c* 0))
	     (loop 
		for x from 0 by 10000 
		do (progn
		     (setf *c* 0)
		     (let ((rows (clsql:query
				  (format nil "SELECT traceid, id, timeoffset, memory FROM tracelinestore WHERE traceid = ~a limit ~a, 10000;" traceid x))))
		       (mapc 
			(lambda (row)
			  (setf *c* (1+ *c*))
			  (write-string 
			   (format nil "~a ~a ~f ~a ~a" 
				   (nth 0 row)
				   (nth 1 row)
				   (nth 2 row)
				   (nth 3 row)
				   #\Newline)))
			rows)))
		while (eq *c* 10000))))
	 )) 
     traces)))

(make-dat-files)
