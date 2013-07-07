;(eval-when (:compile-toplevel)
;  (ql:quickload 'cl-libxml2))

(defpackage :test2
  (:use :cl :sb-bsd-sockets)
  (:export :server :send-command))

(in-package :test2)

;(defun do-stuff-with-xml (xmlstr doer)
;  (libxml2.tree:with-object (doc (libxml2.tree:parse xmlstr))
;    (doer doc)))

(defun read-buf-nonblock (buffer stream)
  "Like READ-SEQUENCE, but returns early if the full quantity of data isn't there to be read.  Blocks if no input at all"
  (let ((eof (gensym)))
    (do ((i 0 (1+ i))
         (c (read-char stream nil eof)
            (read-char-no-hang stream nil eof)))
        ((or (>= i (length buffer)) (not c) (eq c eof)) i)
      (setf (elt buffer i) c))))

(defun read-until-null (stream)
  (with-output-to-string (out)
;    (do ((c (read-char stream nil nil) 
;	    (read-char-no-hang stream nil nil)))
;	((not (eq c nil)))
;	(write-char c out)
    (loop for x = (read-char stream nil nil)
       while (> (char-code x) 0)
       do (progn
	    ;(write-char x)
	    ;(write-char #\Newline)
	    ;(print (char-code x))
	    (write-char x out))
      )))


(defun send-command (cmd)
  (let ((s (make-instance 'inet-socket
			  :type :stream
			  :protocol :tcp))) 
    (socket-connect s #(192 168 23 190) 9001)
    (let ((stream (socket-make-stream s :input t
				      :output t
				      :buffering :none)))
      (unwind-protect 
	   (progn
	     (write-string cmd stream))
	(close stream)
	(socket-close s)))))

(defun server ()
  (let ((s (make-instance 'inet-socket
			  :type :stream
			  :protocol :tcp)))
    (setf (sockopt-reuse-address s) t)
    (socket-bind s (make-inet-address "192.168.23.193") 9000)
    (socket-listen s 5)
;    (setf (non-blocking-mode s) t)
    (multiple-value-bind (* port) (socket-name s)
      (let* ((r (socket-accept s))
	     (stream (socket-make-stream r
					 :input t
					 :output t
					 :buffering :none)))
	(labels ((wait-for-answer ()
		   (let* ((size (parse-integer (read-until-null stream)))
			  (buffer (make-array size :element-type 'character)))
		     (read-buf-nonblock buffer stream)
		     buffer)))
	  
	
	  (unwind-protect 
	       (progn
		 (print (wait-for-answer))
		 
		 (write-string "status -i 1" stream)
		 (write-char (code-char 0) stream)
		 (print (wait-for-answer))

		 (write-string "feature_get -i 2 -n breakpoint_types" stream)
		 (write-char (code-char 0) stream)
		 (print (wait-for-answer))

		 (write-string "feature_get -i 8 -n supports_async" stream)
		 (write-char (code-char 0) stream)
		 (print (wait-for-answer))	 

		 (write-string "feature_get -i 11 -n eval" stream)
		 (write-char (code-char 0) stream)
		 (print (wait-for-answer))	 

		 (write-string "feature_get -i 12 -n expr" stream)
		 (write-char (code-char 0) stream)
		 (print (wait-for-answer))	 

		 (write-string "feature_get -i 13 -n exec" stream)
		 (write-char (code-char 0) stream)
		 (print (wait-for-answer))	 

		 (write-string "status -i 5" stream)
		 (write-char (code-char 0) stream)
		 (print (wait-for-answer))

		 (write-string "eval -i 18 -- eGRlYnVnX3N0YXJ0X2NvZGVfY292ZXJhZ2UoKQ==" stream)
		 (write-char (code-char 0) stream)
		 (print (wait-for-answer))

		 (write-string "breakpoint_set -i 3 -t line -f \"/var/www/vtigercrm/teste2/PHPWebProject1/index.php\" -n 9" stream)
		 (write-char (code-char 0) stream)
		 (print (wait-for-answer))

		 (write-string "breakpoint_list -i 9" stream)
		 (write-char (code-char 0) stream)
		 (print (wait-for-answer))

		 (write-string "status -i 7" stream)
		 (write-char (code-char 0) stream)
		 (print (wait-for-answer))

		 (write-string "run -i 4" stream)
		 (write-char (code-char 0) stream)
		 (print (wait-for-answer))

		 (write-string "status -i 6" stream)
		 (write-char (code-char 0) stream)
		 (print (wait-for-answer))

		 ; expressions must be **base-64** encoded. 
		 ; some responses may be wrapped as base-64 (strings for instance; ints dont)
		 (write-string "eval -i 14 -- JHM=" stream)
		 (write-char (code-char 0) stream)
		 (print (wait-for-answer))

		 (write-string "eval -i 15 -- MSsx" stream)
		 (write-char (code-char 0) stream)
		 (print (wait-for-answer))

		 (write-string "eval -i 16 -- OSsx" stream)
		 (write-char (code-char 0) stream)
		 (print (wait-for-answer))

		 (write-string "eval -i 17 -- YXJyYXkoMSwyLDMsNCk=" stream)
		 (write-char (code-char 0) stream)
		 (print (wait-for-answer))

;		 (write-string "eval -i 14 -- $s;" stream)
;		 (write-char (code-char 0) stream)
;		 (print (wait-for-answer))

;		 (write-string "eval -i 14 -- $s" stream)
;		 (write-char (code-char 0) stream)
;		 (print (wait-for-answer))


		 (write-string "eval -i 19 -- eGRlYnVnX2dldF9jb2RlX2NvdmVyYWdlKCk=" stream)
		 (write-char (code-char 0) stream)
		 (print (wait-for-answer))

		 (write-string "run -i 10" stream)
		 (write-char (code-char 0) stream)
		 (print (wait-for-answer))

		 (write-string "eval -i 20 -- OSsx" stream)
		 (write-char (code-char 0) stream)
		 (print (wait-for-answer))


		 )

	;    (progn
	;      (with-output-to-string (out)
	;	 (loop with buffer = (make-array 50 :element-type 'character)
	;	    for n-characters = (read-buf-nonblock buffer stream)
	;	    while (< 0 n-characters)
	;	    do (progn			 
	;		 (write-sequence buffer out :start 0 :end n-characters)	
	;		 (write-sequence buffer *standard-output* :start 0 :end n-characters)
	;		 ))
	;	 (print out))
	       
	;     (progn	       
	;       (print (read-line stream))
	     
;	     (progn
;	       (let* ((size (parse-integer (read-until-null stream)))
;		      (buffer (make-array size :element-type 'character)))
;		 (read-buf-nonblock buffer stream)
;		 (print buffer)
;		 
;
;		 ))
	       )
	  
	  (socket-close s)
	  ;(sleep 5)
	  (close stream)
	  (socket-close r))))))

