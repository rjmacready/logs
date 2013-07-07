;(defparameter *a* (read-file "traceout.out.00c9c0-1373217553-1373217553_717056.xt"))
;(setf *a* (funcall *a*))
;(dotimes (i 200000) (setf *a* (funcall *a*)))

;(defparameter *a* (read-file))



;(time (loop for x = (setf *a* (funcall *a*))
;	 until (null x)))

;(time (dotimes (i 200000) (setf *a* (funcall *a*))))

;(defun x (&key (a "1") (b "2") (c "3"))
;  (print b))

;(x :b "asd")

;(with-output-to-string (*standard-output*)
;  (read-file-all "traceout.out.00c9c0-1373217553-1373217553_717056.xt"))

;(with-output-to-string (*standard-output*)
;  (read-file-all "traceout.out.020f4f-1373058627-1373058627_341034.xt"))

;(time (with-output-to-string (*standard-output*)
;	(read-file-all "traceout.out.00c9c0-1373217553-1373217553_717056.xt")))

;(time (read-file-all "traceout.out.0d1e5e-1373217525-1373217525_187987.xt"))

;(cl-fad:walk-directory "/home/user/logs/traces/tests" #'read-file-all)

;(read-trace-value (make-string-input-stream "'a string'"))
;(read-trace-value (make-string-input-stream "TRUE"))
;(read-trace-value (make-string-input-stream "'\\n'"))

(defparameter *last-level* 0)
(defparameter *call-stack* nil)

(defun do-nothing ($1)
  (declare (ignore $1))
  nil)

(defun start-cb (dt)
  (setf *last-level* 0)
  (setf *call-stack* nil))

(defun entry-cb (data)
  ; for every entry we need to increase level and the call-stack
  ; check for sanitation purposes
  (format T "call(~d, ~s, ~d, ~s, ~a)." 
	  (getf data :function-no)
	  (getf data :filename)
	  (getf data :line-no)
	  (getf data :function-name)
	  (if (= *last-level* 0)
	      "nil"
	      (car *call-stack*)))
  (princ #\Newline)

  (setf *last-level* (1+ *last-level*))
  (unless (equal (getf data :level) *last-level*)
    (error (format nil "Levels do not match! Expected ~a but has ~a. Data: ~a" 
		   (getf data :level) 
		   *last-level*
		   data)))
  (push (getf data :function-no) *call-stack*))

(defun entry-inc-cb (data)
  (entry-cb data))

(defun exit-cb (data)
  (setf *last-level* (1- *last-level*))
  (pop *call-stack*))

(defun end-cb (dt)
  (declare (ignore dt))
  nil)

;"traceout.out.00c9c0-1373217553-1373217553_717056.xt" 	       

(with-open-file (*standard-output* "out.pl" :direction :output :if-exists :supersede)
  (read-file-all "traceout.out.020f4f-1373058627-1373058627_341034.xt" 
		 :version-cb #'do-nothing ;version-cb
		 :format-cb #'do-nothing ;format-cb
		 :start-cb #'start-cb
		 :entry-cb #'entry-cb
		 :entry-inc-cb #'entry-inc-cb
		 :exit-cb #'exit-cb
		 :end-cb #'end-cb))


