
(eval-when (:compile-toplevel)
  (ql:quickload 'cl-ppcre))

(defvar *entry-point* "{main}")

(defparameter *default-newprofile-cb*
  (lambda (filename)
    (print (format nil "cmd: ~a" filename))))

(defparameter *default-invocation-cb* 
  (lambda (function-name filename lnr cost)
    (print (format nil "invocation ~a ~a ~a ~a"
		   filename function-name lnr cost))))

(defparameter *default-call-cb*
  (lambda (function-name lnr cost)
    (print (format nil "call ~a ~a ~a"
		   function-name
		   lnr cost))))

(defun read-file (filename &optional &key
		  (newprofile-cb *default-newprofile-cb*)
		  (invocation-cb *default-invocation-cb*)
		  (call-cb *default-call-cb*))
  (with-open-file (fp (open filename))
    (loop for line = (read-line fp nil nil)
       until (null line)
       do (progn
	    (cond
	      ((cl-ppcre:scan "^=+ NEW PROFILING FILE =+" line)
	       (progn
		 (dotimes (i 2) (read-line fp nil nil))
		 (cl-ppcre:register-groups-bind (filename)
		     ("^cmd: (.*)$" (read-line fp nil nil))
		   (funcall newprofile-cb filename)
		   (dotimes (i 5) (read-line fp nil nil)))))
		; invocation of function
	      ((cl-ppcre:scan "^fl=" line)
	       (progn
		   ; get function name
		   ; (from next lin)
		 (cl-ppcre:register-groups-bind (function-name)
		     ("^fn=(.*)$" (read-line fp nil nil))
		   
		     ; skip 3 lines (2nd has headers ...)
		   (when (equal *entry-point* function-name)
		     (dotimes (i 3) (read-line fp nil nil)))
		   
		   ; get filename
		   ; (rest of current line)
		   (cl-ppcre:register-groups-bind (filename)
		       ("^fl=(.*)$" line)
		     
		     (cl-ppcre:register-groups-bind (lnr cost)
			 ("(\\d+) (\\d+)" (read-line fp nil nil))
			 
			 ;(print `(function 
			;	  ,function-name in 
			;	  ,filename ,lnr ,cost))
			 
		       (funcall invocation-cb 
				function-name 
				filename 
				lnr cost)
		       )))))

	      ((cl-ppcre:scan "^cfn\\=" line)
	       (progn
		    ; call to function
		 (cl-ppcre:register-groups-bind
		     (function-name)
		     ("^cfn=(.*)$" line)
		     
		     ; skip call line
		   (read-line fp nil nil)
		    
		   (cl-ppcre:register-groups-bind 
		       (lnr cost)
		       ("(\\d+) (\\d+)" (read-line fp nil nil))
		      
		      ;(print 
		      ; `(call to function ,function-name ,lnr ,cost))))
		     (funcall
		      call-cb
		      function-name
		      lnr cost)
		     ))))
		 ((cl-ppcre:scan ": " line)
		  (progn
		    ; is header
		    ;(print line)
		    nil)))))))
