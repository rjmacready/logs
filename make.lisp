(eval-when (:compile-toplevel)
  (ql:quickload 'cffi))

;(with-compilation-unit (:policy '(optimize speed))
  (load (compile-file "main.lisp"));)

(defun main()

  (cffi:define-foreign-library sqlite3
    (:unix "libsqlite3.so"))

  (write-string "hello world")
  (write-char #\Newline)
  (serve)
  (read-char)
  (stop)
  (exit))

(let ((filename "main"))
  (save-lisp-and-die filename :toplevel #'main :executable t))
