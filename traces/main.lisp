
(eval-when (:compile-toplevel)
  (ql:quickload 'cl-lex)
  (ql:quickload 'yacc)
  (ql:quickload 'parse-number)

  (defun end-of-exit ()
    `(:exit))

  (defun end-of-entry-inc ($1 $2 $3 $4 $5 $6)
    (declare (ignore $1 $3 $5))
    `(:entry-inc ,$2 ,(if (equal $4 "0") :internal :user-defined) ,$6))
  
  (defun end-of-entry ($1 $2 $3 $4 $5 $6 $7)
    (declare (ignore $1 $3 $5 $6))
    `(:entry ,$2 ,(if (equal $4 "0") :internal :user-defined) ,$7))

  (defun start-of-entry ($1 $2 $3 $4 $5 $6 $7 $8 $9 $10)
    (declare (ignore $2 $4 $6 $8))
    (if (null $10)
	`(:line ,(parse-number:parse-number $1) 
		,(parse-number:parse-number $3)
		,(if (equal $5 "0") :entry :exit)
		,(parse-number:parse-number $7)
		,(parse-number:parse-number $9)
		)
	`(:line ,(parse-number:parse-number $1) 
		,(parse-number:parse-number $3)
		,(if (equal $5 "0") :entry :exit)
		,(parse-number:parse-number $7)
		,(parse-number:parse-number $9) 
		,$10
		)))

  (defun end-of-main ($1 $2 $3 $4 $5 $6)
    (declare (ignore $1 $2 $3 $4 $5 $6))
    `(:forget-me))

  (defun file-format ($1 $2 $3)
    (declare (ignore $1 $2))
    `(:format ,$3))

  (defun version ($1 $2 $3)
    (declare (ignore $1 $2))
    `(:version ,$3))
  
  (defun start-of-trace ($1 $2 $3)
    (declare (ignore $1 $3))
    `(:start ,$2))

  (defun end-of-trace ($1 $2 $3)
    (declare (ignore $1 $3))
    `(:end ,$2)))

;(defparameter *filename* "/home/user/logs/traces/traceout.out.020f4f-1373058627-1373058627_341034.xt")

(cl-lex:define-string-lexer headerlexer
  ; delimiters
  ("Version" (return (values :version)))
  ("\\:" (return (values :equals)))
  ("File format" (return (values :fileformat)))
  ("([0-9]+(\\.[0-9]+)*)" (return (values :number $@)))
  ;("\\r\\n?" (return (values :newline)))
  ;("\\n" (return (values :newline)))
  ; crush whitespace
  ("\\w+" (return (values nil)))
  )

(cl-lex:define-string-lexer linelexer
  ("TRACE START\\s+\\[" (return (values :start)))
  ("TRACE END\\s+\\[" (return (values :end)))
  ("(\\d{4})\\-(\\d{2})\\-(\\d{2}) (\\d{2})\\:(\\d{2})\\:(\\d{2})" 
   (return (values :dt `(,$1 ,$2 ,$3 ,$4 ,$5 ,$6))))
  ("\\]" (return (values :close)))
  ("\\b([0-9]+\\.[0-9]+)\\b" (return (values :float $@)))
  ("\\b([0-9]+)\\b" (return (values :int $@)))
  ("\\t" (return (values :tab)))
  ("(\\{?[a-zA-Z_][0-9a-zA-Z_\\:\\-\\>]*\\}?)" (return (values :id $@)))
  ("(.+)" (return (values :text $@)))
  )
; 
; TODO Improve this!!!
;(cl-lex:define-string-lexer filenamelexer
; ("([^\\t]+)" (return (values :filename $@))))


(yacc:define-parser versionparser
  (:start-symbol header)
  (:terminals (:version :equals :number))
  
  (header
   (:version :equals :number #'version)))

(yacc:define-parser formatparser
  (:start-symbol header)
  (:terminals (:equals :fileformat :number))
  
  (header
   (:fileformat :equals :number #'file-format)))

(yacc:define-parser lineparser
  (:start-symbol line)
  (:terminals (:start :dt :end :close :id :int :tab :float :text))

  (trace-start
   (:start :dt :close #'start-of-trace))

  (trace-end
   (:end :dt :close #'end-of-trace))

;  (trace-line-exit
;   (:int :tab 
;    :int :tab 
;    :int :tab 
;    :float :tab
;    :int))

;  (trace-line-call
;   (:int :tab 
;    :int :tab 
;    :int :tab 
;    :float :tab
;    :int :tab
;    :id :tab
;    :int :tab :tab
;    :text))

  (trace-line-rest
   nil
   (:tab
    :id :tab
    :int :tab
    :text #'end-of-entry-inc)
   (:tab
    :id :tab
    :int :tab :tab
    :text #'end-of-entry))

  (trace-line
   (:int :tab 
    :int :tab 
    :int :tab 
    :float :tab
    :int trace-line-rest #'start-of-entry)) ; 

  (trace-end-main
   (:tab :tab :tab :float :tab :int #'end-of-main))

  (line
   trace-start
   trace-end
   trace-line
   trace-end-main
   ;trace-line-exit
   ;trace-line-call
   ))

(defun open-delimiter-p (c)
  (declare (ignore c))
  nil)

(defun close-delimiter-p (c)
  (declare (ignore c))
  nil)


(defun read-line-safe (&optional (stream *standard-input*) (sb-impl::eof-error-p T) 
		       eof-value recursive-p)
  "Because of utf8 reasons ..."
  (handler-bind ((SB-INT:STREAM-DECODING-ERROR 
		  #'(lambda(err) 
		      (declare (ignore err)) 
		      (invoke-restart 'sb-int:attempt-resync))))
    (read-line stream sb-impl::eof-error-p eof-value recursive-p)))

(defun make-stream-lexer (stream lexer)
  (cl-lex:stream-lexer 
   #'read-line-safe
   lexer #'open-delimiter-p #'close-delimiter-p :stream stream))

(defun consume-tab-or-nil (stream)
  (let ((c (read-char stream nil nil)))
    (unless (or (null c) (equal c #\Tab))
      (error (format nil "Not a tab or end of stream! ~a" c)))))

(defun read-trace-value (stream)
  (labels ((outside-stuff ()
	     (let ((c (read-char stream nil nil)))
	       (case c
		 ((#\') 
		  (let ((val (with-output-to-string (out-stream)
			       (inside-string out-stream))))
		    (consume-tab-or-nil stream)
		    `(:string ,val)))
		 (otherwise
		  (let ((val (with-output-to-string (out-stream)
			       (write-char c out-stream)
			       (read-n-no-tabs out-stream))))		  
		    `(:literal ,val))))))
	   
	   (read-char-literal (out-stream)
	     (write-char (read-char stream nil nil) out-stream))

	   (read-n-no-tabs (out-stream)
	     (let ((c (read-char stream nil nil)))
	       (case c
		 ((#\Tab) 
		  nil)
		 ((nil)
		  nil)
		 (otherwise (progn
			      (write-char c out-stream)
			      (read-n-no-tabs out-stream)))
		 )))

	   (inside-string (out-stream)
	     (let ((c (read-char stream nil nil)))
	       (case c
		 ((#\\) (progn 
			  (write-char c out-stream) 
			  (read-char-literal out-stream)
			  (inside-string out-stream)))
		 ((#\') nil) ; just return ...
		 (otherwise (progn
			      (when (null c) 
				(error "What? End of stream inside string?"))
			      (write-char c out-stream)
			      (inside-string out-stream)))))))


    (outside-stuff)))

(defmacro make-item (key ls-var)
  "I know this is ugly as foo"
  `(progn
     (setf (getf r ,key) (car ,ls-var))
     (setf ,ls-var (cdr ,ls-var))))

(defparameter *default-version-callback*
  (lambda (version)
    (format T "version: ~a" version)
    (princ #\Newline)))

(defparameter *default-format-callback* 
  (lambda (format)
    (format T "format: ~a" format)
    (princ #\Newline)))

(defparameter *default-entry-callback*
  (lambda (data)
    (declare (ignore data))
    (princ ".")))

(defparameter *default-entry-inc-callback*
  (lambda (data)
    (declare (ignore data))
    (princ "*")))

(defparameter *default-exit-callback*
  (lambda (data)
    (declare (ignore data))
    (princ "/")))

(defparameter *default-start-callback*
  (lambda (dt)
    (format T "start ~a" dt)
    (princ #\Newline)))

(defparameter *default-end-callback*
  (lambda (dt)
    (princ #\Newline)
    (format T "end ~a" dt)
    (princ #\Newline)))

(defun read-file (filename &key 
		  (version-cb *default-version-callback*)
		  (format-cb *default-format-callback*)
		  (start-cb *default-start-callback*) 
		  (entry-cb *default-entry-callback*)
		  (entry-inc-cb *default-entry-inc-callback*)
		  (exit-cb *default-exit-callback*)
		  (end-cb *default-end-callback*))
  (let* ((s (open filename))
	 (lexer (make-stream-lexer s #'headerlexer))) 
    (lambda ()
      "Continuation which reads the first two lines"
      (progn

	(funcall version-cb ;*default-version-callback* 
		 (yacc:parse-with-lexer lexer versionparser))

	(funcall format-cb ;*default-format-callback*
		 (yacc:parse-with-lexer lexer formatparser))
	
	(let ((lexer2 (make-stream-lexer s #'linelexer)))
	  (labels ((done-cont ()
		     nil)
		   (cont ()
		     (let* ((parsed (yacc:parse-with-lexer lexer2 lineparser))
			    (kind (car parsed)))
		       
		       (case kind
			 ((:start) 
			  (progn
			    (funcall start-cb ;*default-start-callback* 
				     (cadr parsed))
			    #'cont))
			 ((:end) 
			  (progn
			    (funcall end-cb ;*default-end-callback* 
				     (cadr parsed))
			    #'done-cont))
			 ((:forget-me) #'cont)
			 (otherwise
			  (let* ((r '())
				 (last-parsed (car (last parsed))))
			 

;		       (print parsed)
		       ; TODO attention, we have a line with the start of the trace,
		       ; and its falling here.
		     			     
		       ; at this point we won't manipulate parsed anymore.
		       ; lets foo it!
		       
		       ;discard head (:LINE)
			    ;(print `(:parsed ,parsed))

			    (setf parsed (cdr parsed))
			    (make-item :level parsed)
			    (make-item :function-no parsed)
			    (make-item :kind parsed)
			    (make-item :timeoffset parsed)
			    (make-item :memory parsed)
			    
			    (unless (null last-parsed)
			      (when (listp last-parsed)
			       
			       ;(print `(:last-parsed ,last-parsed))
				(let* ((r-last-parsed (car (last last-parsed)))
				       (s (make-string-input-stream r-last-parsed))
				       )
				      
				 ;(print `(:last-parsed-2 ,last-parsed))
				 ;(print `(:type ,type))
				 
				  (let ((head-tail (car last-parsed)))
				   ; discard head of tail (:EXIT, :ENTRY, :ENTRY-INC)
				    (setf last-parsed (cdr last-parsed))
				    (make-item :function-name last-parsed)
				    (make-item :deftype last-parsed)
				   
				   
				    (setf (getf r :filename) (read-chars-until s #\Tab))
				   
				    (when (eq head-tail :entry-inc)
				     ; update kind from entry to entry-inc
				      ;(print `(list ,r))
				      ;(print `(kind ,(getf r :kind)))
				      (setf (getf r :kind) :entry-inc)

				      (setf (getf r :included) (read-chars-until s #\Tab)))
				   
				    (setf (getf r :line-no) 
					  (parse-number:parse-number 
					   (read-chars-until s #\Tab)))
				    
					;(print `(so-far ,r))

				    (let ((raw-param-no (read-chars-until s #\Tab)))
				      ;(print '(on raw param no))
				      (unless (equal raw-param-no "")
					;(print `(raw param no is ,raw-param-no))
					(let ((param-no (parse-number:parse-number 
							 raw-param-no)))
					  
					  ;(print `(param-no is ,param-no))
					  
					  (setf (getf r :parameters) 
						(if (> param-no 0)
						    (loop for i from 1 to param-no
						       collect (read-trace-value s))
						    '()))

					  ;(print '(param accepted))
					  nil)
					nil)
				      nil)
				    nil)
				  nil)
				nil)
			      nil)
			    
;			 (print r)
			    ;(case kind
			    ;  ((:end) #'done-cont)
			    ;  (otherwise #'cont))

			    (funcall 
			     (case (getf r :kind)
			       ((:entry) entry-cb) ;*default-entry-callback*)
			       ((:entry-inc) entry-inc-cb) ; *default-entry-inc-callback*)
			       ((:exit) exit-cb) ;*default-exit-callback*)
			       (otherwise (error 
					   (format nil "Error: ~a ~a has no callback!" 
						   (getf r :kind)
						   r)))) 
			     r)

			    #'cont
			  ))))))
	    #'cont))	
	))))

(defun read-file-all (filename  &key 
		      (version-cb *default-version-callback*)
		      (format-cb *default-format-callback*)
		      (start-cb *default-start-callback*) 
		      (entry-cb *default-entry-callback*)
		      (entry-inc-cb *default-entry-inc-callback*)
		      (exit-cb *default-exit-callback*)
		      (end-cb *default-end-callback*))
  (let ((a (read-file filename 
		      :version-cb version-cb
		      :format-cb format-cb
		      :start-cb start-cb
		      :entry-cb entry-cb
		      :entry-inc-cb entry-inc-cb
		      :exit-cb exit-cb
		      :end-cb end-cb))) 
    (loop for x = (setf a (funcall a))
       while (not (null x)))))

(defun read-chars-while (stream condition)
  (let ((last-read nil))
    (let ((output (with-output-to-string (s)
		  (loop for x = (read-char stream nil nil)
		     while (and (not (null x)) (funcall condition x))
		     do (progn
			  ;(print x)
			  (setf last-read x)
			  (write-char x s))))))
    (unless (null last-read)
      (unread-char last-read stream))
    output)))

(defun read-chars-until (stream end-char &optional (consume T))
  (with-output-to-string (s)    
    (loop for x = (read-char stream nil nil)
		 while (and (not (null x)) (not (eq x end-char)))
		 do (write-char x s))
    (unless consume
      (unread-char end-char stream))
    ))