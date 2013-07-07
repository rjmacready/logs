
(ql:quickload 'usocket)

(defparameter *listen* nil)
(defparameter *connection* nil)

(defun listen-to-xdebug ()
  (setf *listen* (usocket:socket-listen usocket:*wildcard-host* 9000))
  (setf *connection* (usocket:socket-accept *listen*))
  (usocket:wait-for-input *connection* :timeout 0 :ready-only t)
  (print (read-line (usocket:socket-stream *connection*)))))

(defun stop-listening()
  (usocket:socket-close *connection*))