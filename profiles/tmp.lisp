
(load "main.lisp")

(eval-when (:compile-toplevel)
  (ql:quickload 'clsql-sqlite3))


;(with-open-stream (*standard-output* 
;		   (open "out.txt" :direction :output :if-exists :supersede)) 
;  (read-file "/home/user/logs/profiles/cachegrind.out"))

;(read-file "/home/user/logs/profiles/cachegrind.out"
;	   :newprofile-cb nil
;	   :call-cb nil
;	   :invocation-cb nil)


(defun read-to-db (filename database)
  (clsql:with-database (clsql:*default-database* (list database) :database-type :sqlite3)
    (clsql:with-transaction ()
      (let ((*profile-id* nil)
	    (*cmd-id* nil))
	(clsql:execute-command (format nil "insert into profilestore(filename) values('~a')" filename))
	(setf *profile-id* (caar (clsql:query "select last_insert_rowid()")))
	(labels ((newprofile-cb (cmd)
		   (clsql:execute-command (format nil "insert into profilecmdstore(profileid, cmd) values(~a, '~a')" *profile-id* cmd))
		   (setf *cmd-id* (caar (clsql:query "select last_insert_rowid()")))
		   nil)

		 (invocation-cb (function-name filename lnr cost)
		   (clsql:execute-command (format nil "insert into profileinvstore(cmdid, function_name, filename, lnr, cost) values (~a, '~a', '~a', ~a, ~a)"  *cmd-id* function-name filename lnr cost))	   
		   nil)

		 (call-cb (function-name lnr cost)
		   (clsql:execute-command (format nil "insert into profilecallstore(cmdid, function_name, lnr, cost) values (~a, '~a', ~a, ~a)"  *cmd-id* function-name lnr cost))
		   nil))

	  (read-file filename 
		     :newprofile-cb #'newprofile-cb
		     :call-cb #'call-cb
		     :invocation-cb #'invocation-cb))))))

(defun main() 
  (with-open-stream (*standard-output* 
		     (open "out.txt" :direction :output :if-exists :supersede)) 
    ;(read-to-db "/home/user/logs/profiles/cachegrind.out" "/home/user/logs/logs.db")
    (read-to-db "/home/user/logs/profiles/cachegrind__vtigercrm_print_external_php_quoteid=51027.out" "/home/user/logs/logs.db")))
