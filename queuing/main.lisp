

(defvar *buffer-queue* (sb-thread:make-waitqueue))
(defvar *buffer-lock* (sb-thread:make-mutex :name "buffer lock"))
(defvar *buffer* (list nil))

(defun reader ()
  (sb-thread:with-mutex (*buffer-lock*)
    (loop
       (sb-thread:condition-wait *buffer-queue* *buffer-lock*)
       (loop
	  (unless *buffer* (return))
	  (let ((head (car *buffer*)))
	    (setf *buffer* (cdr *buffer*))
	    (format t "reader ~A woke, read ~A~%"
		    sb-thread:*current-thread* head))))))

(defun writer ()
  (loop
     (sleep (random 5))
     (sb-thread:with-mutex (*buffer-lock*)
       (let ((el (intern
		  (string (code-char
			   (+ (char-code #\A) (random 26)))))))
	 (setf *buffer* (cons el *buffer*)))
       (sb-thread:condition-notify *buffer-queue*))))

(sb-thread:make-thread #'writer)
(sb-thread:make-thread #'reader)
(sb-thread:make-thread #'reader)