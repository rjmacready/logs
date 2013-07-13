(eval-when (:compile-toplevel)
  (ql:quickload 'clsql-sqlite3))

(defun make-dot-file-includes ()
  (clsql:with-database (clsql:*default-database* (list "/home/user/logs/logs.db") :database-type :sqlite3)
    (let ((rows (clsql:query (format nil "select distinct filename, included from tracelinestore where traceid = ~a and kind = 2" 9))))
      (let ((files (make-hash-table :test #'equal))
	    (*decl* (make-string-output-stream))
	    (*nodes* (make-string-output-stream))) 
	(mapc
	 (lambda (row)
	   (let ((filename (first row))
		 (included (second row)))
	     
	     (unless (gethash filename files)
	       (setf (gethash filename files) T)
	       (write-string (format nil "\"~a\";" filename) *decl*)
	       (write-char #\Newline *decl*))
	     
	     (unless (gethash included files)
	       (setf (gethash included files) T)
	       (write-string (format nil "\"~a\";" filename) *decl*)
	       (write-char #\Newline *decl*))
	     
	     (write-string (format nil "\"~a\"->\"~a\";" filename included) *nodes*)
	     (write-char #\Newline *nodes*)))
	 rows)
	
	(with-open-stream (*standard-output* (open "test.dot" :direction :output :if-exists :supersede))
	  (write-string "digraph{")
	  (write-char #\Newline)
	  (write-string (get-output-stream-string *decl*))
	  (write-string (get-output-stream-string *nodes*))
	  (write-string "}")
	  nil)))))

(make-dot-file-includes)

(defun make-dot-file ()
  (clsql:with-database (clsql:*default-database* (list "/home/user/logs/logs.db") :database-type :sqlite3)
    (let ((rows (clsql:query 
		 (format nil "
SELECT 
    src.function_name as src_function_name 
  , dest.function_name as dest_function_name 
FROM tracelinestore dest inner join tracelinestore src 
ON dest.parent = src.function_no AND dest.traceid = src.traceid
WHERE dest.traceid = ~a;" 9))))
      
      nil)))