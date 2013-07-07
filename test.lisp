(eval-when (:compile-toplevel)
  (ql:quickload 'usocket))

(defun receive-each (connections)
  (let ((ready (usocket:wait-for-input connections :timeout 0 :ready-only t)))
    (loop for connection in ready
       collect (read-line (usocket:socket-stream connection)))))

(defun receive-all (connections)
  (loop for messages = (receive-each connections)
     then (receive-each connections)
     while messages append messages))


(defun server ()
  (usocket:with-server-socket (listen (usocket:socket-listen usocket:*wildcard-host* 9000))
    (let* ((connection (usocket:socket-accept listen)))
      (loop for messages = (receive-all connection) then (receive-all connection)
	 do (when T
	      (format t "Got messages:~%~s~%" messages))
	 do (sleep 1/50)))))
  