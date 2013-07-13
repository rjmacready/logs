(eval-when (:compile-toplevel)
  (ql:quickload 'clsql-sqlite3))


(trace-file-to-db 
 "/home/user/logs/traces/traceout.out.020f4f-1373058627-1373058627_341034.xt"
 "/home/user/logs/logs.db")

(trace-file-to-db 
 "/home/user/logs/traces/traceout.out.00c9c0-1373217553-1373217553_717056.xt"
 "/home/user/logs/logs.db")

(trace-file-to-db 
 "/home/user/logs/traces/traceout.out.0d1e5e-1373217525-1373217525_187987.xt"
 "/home/user/logs/logs.db")

(trace-file-to-db 
 "/home/user/logs/traces/traceout.out.0e47d1-1373215785-1373215785_553672.xt"
 "/home/user/logs/logs.db")

; :level :function-no :kind (:entry :entry-inc :exit) 
; :timeoffset :memory :function-name :deftype (:internal :user-defined)
; :filename :included :line-no :parameters


(defun trace-file-to-db (filename database)
  (clsql:with-database (clsql:*default-database* (list database) :database-type :sqlite3) 
    (clsql:with-transaction ()
      (let ((*last-level* 0)
	    (*call-stack* nil)
	    (*trace-id* nil))
	
	(labels ((do-nothing ($1)
		   (declare (ignore $1))
		   nil)
		 
		 (start-cb (dt)
		   (clsql:execute-command
		    (format nil "insert into tracestore(filename) values('~a')" filename))
		   (setf *trace-id* 
			 (caar (clsql:query
				"select last_insert_rowid();")))
		   (setf *last-level* 0)
		   (setf *call-stack* nil))
		 
	       (entry-cb (data)
		 (clsql:execute-command
		  (format nil "insert into tracelinestore(traceid, level, function_no, kind, timeoffset, memory, function_name, deftype, filename, included, lineno, parent) values(~a, ~a, ~a, ~a, ~a, ~a, '~a', ~a, '~a', '~a', ~a, ~a)"
			  *trace-id*
			  (getf data :level)
			  (getf data :function-no)
			  (case (getf data :kind)
				((:entry) 1)
				((:entry-inc) 2)
				((:exit) 3)
				(otherwise (error "Invalid kind!")))
			  (getf data :timeoffset)
			  (getf data :memory)
			  (getf data :function-name)
			  (case (getf data :deftype)
				((:internal) 1)
				((:user-defined) 2)
				(otherwise (error "invalid deftype!")))
			  (getf data :filename)
			  (let ((v (getf data :included)))
			    (if (null v)
				""
				v))
			  (getf data :line-no)
			  (if (= *last-level* 0)
			      "NULL"
			      (car *call-stack*))))
		 (setf *last-level* (1+ *last-level*))
		 (unless (equal (getf data :level) *last-level*)
		   (error (format nil "Levels do not match! Expected ~a but has ~a. Data: ~a" 
				  (getf data :level) 
				  *last-level*
				  data)))
		 (push (getf data :function-no) *call-stack*))
		 
		 (entry-inc-cb (data)
		   (entry-cb data))
		 
		 (exit-cb (data)
		   (setf *last-level* (1- *last-level*))
		 (pop *call-stack*))
		 
		 (end-cb (dt)
		   (declare (ignore dt))
		   nil))
	  
	  (read-file-all filename 
			 :version-cb #'do-nothing ;version-cb
			 :format-cb #'do-nothing ;format-cb
			 :start-cb #'start-cb
			 :entry-cb #'entry-cb
			 :entry-inc-cb #'entry-inc-cb
			 :exit-cb #'exit-cb
			 :end-cb #'end-cb))))))

