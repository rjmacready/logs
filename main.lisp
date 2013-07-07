
(eval-when (:compile-toplevel)
  (ql:quickload 'hunchentoot)
  (ql:quickload 'cl-who)
  (ql:quickload 'clsql-sqlite3)
  (ql:quickload 'cl-json)
  (ql:quickload 'parenscript))


;(clsql:connect (list "logs.db") :database-type :sqlite3)

(defun logs-list (offset count)
  (multiple-value-bind (rows cols) 
      (clsql:query (format nil "SELECT * FROM logs2 LIMIT ~d, ~d" offset count))
    (declare (ignore cols))
    rows))

(defun code-cov-list (offset count)
  (multiple-value-bind (rows cols)
      (clsql:query (format nil "SELECT* FROM codecovstore ORDER BY ts DESC LIMIT ~d, ~d" offset count))    
    (values cols rows)))

(defun code-cov (id)
  (multiple-value-bind (rows cols)
      (clsql:query (format nil "SELECT* FROM codecovstore WHERE id = ~a" id))
    (let ((l '())
	  (row (first rows)))
      (loop for _colname in cols 
	   do 
	   (let ((colname (string-upcase _colname)))
	     (setf l (acons (intern colname "KEYWORD") 
			    (nth (position _colname cols :test #'equal) row)
			    l))))
      ; more juice, put :content  as sexpr in :content-sexp
;      (setf cl-json:*identifier-name-to-key* #'identity)
      (setf cl-json:*json-identifier-name-to-lisp* #'identity)

      (setf l (acons :content-sexp 
		     (cl-json:decode-json-from-string (cdr (assoc :content l)))
		     l))
      
      (setf cl-json:*json-identifier-name-to-lisp* #'cl-json:camel-case-to-lisp)
;      (setf cl-json:*identifier-name-to-key* #'cl-json:json-intern)

      l)))

(defparameter *max-id* 0)

(defparameter *thread* nil)



(defun make-index (offset count)
  (cl-who:with-html-output-to-string (s)
    (:html
     (:head (:title "Logs"))
     (:body 
      (:table :border "1"
       (:tr (:th "Timestamp") (:th "Date") (:th "Log"))
       (mapcar (lambda(e) 
		       (cl-who:htm 
			(:tr 
			 (:td (cl-who:fmt "~a" (first e)))
			 (:td (cl-who:fmt "~a" (second e)))
			 (:td (cl-who:fmt "~a" (third e)))
			)))
		     (logs-list offset count)))
       )
      )))

(defparameter *show-code-cov-load* 
  `(progn 
     (defvar my-code-mirror)
     (defvar widgets)
     ($ (lambda () 
	  (setf widgets '())	  
	  (setf my-code-mirror 
		(-code-mirror.from-text-area 
		 (document.get-element-by-id "code")
		 (parenscript:create
		  line-numbers true
		  match-brackets true
		  mode "application/x-httpd-php"
		  indent-unit 4
		  indent-with-tabs true
		  style-active-line true
		  enter-mode "keep"
		  tab-mode "shift")))

;	  (defvar make-widgets-fn (make-widgets my-code-mirror fulldata))
	  (defvar make-hl (update-highlights))

	  (my-code-mirror.set-size 650 520)
	  ((parenscript:chain ($ "a") click) 
	   (lambda () 
	     ;(alert ((parenscript:chain ($ this) attr ) "data-filename"))
					; TODO get file content via AJAX
	     ($.ajax (parenscript:create 
		      type "POST"
		      url "/rest/file/server"
		      data (parenscript:create
			    filename ((parenscript:chain ($ this) attr ) 
				      "data-filename"))
		      success (lambda (data) 
				(defvar jdata (-j-s-o-n.parse data))
;				(console.log jdata)
				
				(my-code-mirror.set-value jdata.content)

;				(my-code-mirror.operation 
;				 (make-widgets-fn widgets jdata.filename))

				((parenscript:chain ($ "#div-filename") text) jdata.filename)

				; TODO refresh widgets!
				(make-hl my-code-mirror (get-array-from-line-obj (elt fulldata jdata.filename)))
				)))
	     nil
	     ))
	  nil))))

(defun show-code-cov (id)
  (cl-who:with-html-output-to-string (s)
    (:html
     (:head 
      (:title "Code coverage")
      (:script :src "js/codemirror-3.14/lib/codemirror.js")
      (:link :rel "stylesheet" :href "js/codemirror-3.14/lib/codemirror.css")
      (:script :src "js/codemirror-3.14/addon/edit/matchbrackets.js")
;      (:script :src "js/codemirror-3.14/addon/selection/active-line.js")
      (:script :src "js/codemirror-3.14/mode/htmlmixed/htmlmixed.js")
      (:script :src "js/codemirror-3.14/mode/xml/xml.js")
      (:script :src "js/codemirror-3.14/mode/javascript/javascript.js")
      (:script :src "js/codemirror-3.14/mode/css/css.js")
      (:script :src "js/codemirror-3.14/mode/clike/clike.js")
      (:script :src "js/codemirror-3.14/mode/php/php.js")
;      (:script :src "js/highlightLines.js")
      (:script :src "js/jquery-2.0.2.min.js")
      (:script :src "js/aux.js")
      (:style :type "text/css"
	      ".CodeMirror-activeline-background {background: #e8f2ff !important;}"))

     (let ((model (code-cov id)))
       (cl-who:htm 
	     
	(:body 
	 
	 (:script (cl-who:str (parenscript:ps* 
			       `(progn
				  (defvar fulldata)
				  (setf fulldata (-j-s-o-n.parse ,(cdr (assoc :CONTENT model))))
				  ;(setf fulldata ,model)
				  ))))
	 
	 (:script (cl-who:str 
		   (parenscript:ps* *show-code-cov-load*)
		   ))
	 
; (cl-fad:canonical-pathname (cl-fad:merge-pathnames-as-file #p"/home/user/remote_server" #p"./modules/Something/Something.php" ))

;	 (:div
;	  (cl-who:str (assoc :CONTENT model)))

	 (:div :style "float: left;" (:h2 "Files")
	       (:table
		(:tr (:th "File"))
		(mapcar 
		 (lambda (e)
		   (let* ((ln (cdr e))
			  (dist-ln (length ln))
			  (hits-ln (reduce 
				    (lambda (tot c) 
				      (print c)
				      (print tot)
				      (+ tot (cdr c)))
				    ln
				    :initial-value 0)))
		     (cl-who:htm 
		      (:tr (:td (:a :data-filename (car e) :href (format nil "#") (cl-who:fmt "~a (~d / ~d)" 
					    (pathname-relative-to (format nil "~a" (car e)) "/var/www/vtigercrm/")
					    dist-ln
					    hits-ln))
				))
		      )))
		 (cdr (assoc :content-sexp model)))))
	       
	 (:div :style "float: right;"
	       (:h2 "Code goes here")
	       (cl-who:htm 
		(:div
		 (:div (:b "File"))
		 (:div :id "div-filename" "")
		 (:textarea :id "code" ""))))
	 ))))))


(defun make-code-cov (offset count)
  (cl-who:with-html-output-to-string (s)
    (:html
     (:head (:title "Code coverage"))
     (:body 
      (:table
       
       (multiple-value-bind (cols rows) 
	   (code-cov-list offset count)
	 (cl-who:htm 
;	  (:tr (mapcar (lambda(e) (cl-who:htm 
;				   (:th (cl-who:str e)))) cols))
;	  (mapcar 
;	   (lambda (row) 
;	     (cl-who:htm
;	      (:tr (mapcar 
;		    (lambda (cell)		
;		      (cl-who:htm
;		       (:td (cl-who:str cell))))
;		    row))))
;	   rows)

	  (:tr (:th "ts") (:th "link"))

;	  (:tr (:td (cl-who:fmt "~a" (position "ts" cols :test #'equal)))
;	       (:td (cl-who:fmt "~a" (position "id" cols :test #'equal))))

;	  (let ((ts (position "ts" cols :test #'equal))
;		(id (position "id" cols :test #'equal)))
;	    (mapcar
;	     (lambda (row)
;	       (cl-who:htm
;		(:tr (:td (cl-who:fmt "~a" row)) (:td (nth 0 row)))))
;	     rows))

;	  (let ((row (first rows)))
;	    (cl-who:htm (:tr (:td (cl-who:fmt "~a" (first row))) 
;			     (:td (cl-who:fmt "~a" (second row))))))

	  (let ((ts (position "ts" cols :test #'equal))
		(id (position "id" cols :test #'equal)))
	    
	    (mapcar 
	     (lambda (row)
	       (cl-who:htm
		(:tr (:td (cl-who:fmt "~a" (nth ts row))) 
		     (:td (:a :href (format nil "/codecov?id=~a" (nth id row)) 
			      "Open this coverage")))))
	     rows)
	    
	    ))
	 
	 ))))))


(defun make-next (cont-id)
  (cl-who:with-html-output-to-string (s)
    (:html
     (:head (:title "Logs"))
     (:body
      (cl-who:htm
       (:div (cl-who:str (if (null cont-id)
			     (progn
			       (hunchentoot:start-session)
			       (setf (hunchentoot:session-value hunchentoot:*session*) 0)
			       "0")
			     (progn
			       (setf (hunchentoot:session-value hunchentoot:*session*) 
				     (1+ (hunchentoot:session-value hunchentoot:*session*)
					 )
				     )
			       (format nil "~a" (hunchentoot:session-value hunchentoot:*session*))))))
       (:div (cl-who:fmt "asdqwe ~a" cont-id))
       (:div (cl-who:fmt "qweqwj ~a"
			 (hunchentoot:session-value hunchentoot:*session*)))
       (:div "test 123"))))))




(defun stop ()
  (hunchentoot:stop *thread*))





(defun save-err (data)
  (let* ((rawdata (cl-json:decode-json-from-string data))

	 (type (cdr (assoc :type rawdata)))
	 (msg (cdr (assoc :msg rawdata)))
	 (file (cdr (assoc :file rawdata)))
	 (line (cdr (assoc :line rawdata)))
	 (context (cl-json:encode-json-to-string
		   (cdr (assoc :context rawdata))))

	 (res (clsql:execute-command 
	       (format nil "insert into errstore (ts, type, msg, file, line, context) values(~a, '~a', '~a', '~a', '~a', '~a')" 
		       (get-universal-time) type msg file line context)))) 
    (format nil "~a ~a ~a" data "ok" res)))



(defun save-code-cov (id requesturi data)
  (let* ((res (clsql:execute-command 
	      (format nil "insert into codecovstore (ts, content) values(~a, '~a')" (get-universal-time) data)))) 
    (format nil "~a ~a" "ok" res)))


(defun save-log (data)
;  (declare (ignore data))
;  (print data *standard-output*)
  ; (json:decode-json-from-string data)
;  (print data)
;  (print "ok")
  (let ((res (clsql:execute-command 
	      (format nil "insert into valuestore (ts, content) values(~a, '~a')" (get-universal-time) data)))) 
    (format nil "~a ~a ~a" data "ok" res))
  )


; copied from cl-cookbook
(defun component-present-p (value)
 (and value (not (eql value :unspecific))))
; copied from cl-cookbook
(defun directory-pathname-p (p)
 (and
 (not (component-present-p (pathname-name p)))
 (not (component-present-p (pathname-type p)))
 p))



  
(defun get-content (pathname)
  (let ((real-pathname (probe-file pathname)))
    (if (null real-pathname)
      "doesnt exist!"
      (if (directory-pathname-p real-pathname)
	  (format nil "~a is a dir" pathname)
	  (format nil "~a is a file" pathname)))))



(defun list-dir (dirpathname)
  (directory (make-pathname :name :wild :type :wild :defaults 
			    (namestring dirpathname))))


(defun open-file-or-dir (file line)
  (let ((file (probe-file file)))
    
    (cl-who:with-html-output-to-string (s)
      (:html
       (:head (:title "File")
	      (:script :src "js/codemirror-3.14/lib/codemirror.js")
	      (:link :rel "stylesheet" :href "js/codemirror-3.14/lib/codemirror.css")
	      (:script :src "js/codemirror-3.14/addon/edit/matchbrackets.js")
	      (:script :src "js/codemirror-3.14/mode/htmlmixed/htmlmixed.js")
	      (:script :src "js/codemirror-3.14/mode/xml/xml.js")
	      (:script :src "js/codemirror-3.14/mode/javascript/javascript.js")
	      (:script :src "js/codemirror-3.14/mode/css/css.js")
	      (:script :src "js/codemirror-3.14/mode/clike/clike.js")
	      (:script :src "js/codemirror-3.14/mode/php/php.js")
	      (:script :src "js/jquery-2.0.2.min.js"))
       
       (:body       
	(:script (cl-who:str 
		  (parenscript:ps* `(progn 
				      (defvar my-code-mirror)
				      ($ (lambda () 
					   (setf my-code-mirror 
						 (-code-mirror.from-text-area 
						  (document.get-element-by-id "code")
						  (parenscript:create
						   line-numbers true
						   match-brackets true
						   mode "application/x-httpd-php"
						   indent-unit 4
						   indent-with-tabs true
						   enter-mode "keep"
						   tab-mode "shift")))
					   nil))))
		  ))
;      (:div
;       (let ((dirs (cdr (pathname-directory (probe-file file))))) 
;	 (mapcar
;	  (lambda (d) (cl-who:htm (:div (:a :href 
;					    (format nil "/file?file=~a" d)
;					    (cl-who:str d))))) ;  :style "float: left;"
;	  dirs))
;       ) ;(:div)  :style "display: block;"

	(:div
	 (cl-who:htm
	  (:div (:b "Path"))
	  (let ((dirs (cdr (pathname-directory file))))
	    (mapcar 
	     (lambda (e)
	       (cl-who:htm (:div (:a :href (format nil "/file?file=~a" e) (cl-who:str e)))))
	     (cons 
	      (pathname "/")
	      (reverse 
	       (maplist 
		(lambda (n) 
		  (make-pathname :directory (cons :absolute (reverse n)))) 
		(reverse dirs))))))))

	(:div 
	 (let ((dir (make-pathname :directory (pathname-directory file))))
	   (cl-who:htm
	    (:div (:b "Listing"))
	    (mapcar 
	     (lambda (n) 
	       (cl-who:htm (:div (:a :href (format nil "/file?file=~a" n) (cl-who:str n)))))
	     (list-dir file)))
	   ))
	
		 
	(when (not (directory-pathname-p file))
	  (cl-who:htm 
	   (:div
	    (:div (:b "File"))
	    (:div (cl-who:str file))
	    (:textarea :id "code" (cl-who:str (read-file-to-string file)))))
	  
;       (cl-who:htm
;	(:div (cl-who:str (get-content (pathname file))))
;	(:div 
;	 (cl-who:htm
;	  (mapcar
;	   (lambda (n)
;	     (cl-who:htm (:div 
;			   (:a :name (first n)
;			       (cl-who:fmt "~a: ~a" (first n) (second n))
;			   )
;			  ))
;	     )
;	   (read-file-to-list (pathname file))
;	   )
	 ))
       )
      )))




(defun read-file-to-string (pathname)
  (with-output-to-string (out)
    (with-open-file (in pathname)
      (loop with buffer = (make-array 8192 :element-type 'character)
	 for n-characters = (read-sequence buffer in)
	 while (< 0 n-characters)
	 do (write-sequence buffer out :start 0 :end n-characters)))))


(defun read-file-to-list (pathname)
  (with-open-file (in pathname)
    (let ((len (file-length in)))
      (loop for line = (read-line in)
	   for i from 1
	 collect `(,i ,line)
	 until (eq (file-position in) len)))))

(defun rest-of-list (ls nth)
  (if (= nth 0)
      ls
      (rest-of-list (cdr ls) (- nth 1))))

(defun pathname-relative-to (filename base-dir)
  (let* ((base-dir (pathname-directory base-dir))
	 (filename-dir (pathname-directory filename)) 
	 (without-base (rest-of-list filename-dir (length base-dir)))
	 (filename-no-dir (file-namestring filename)))
    (cl-fad:merge-pathnames-as-file (make-pathname :directory `(:relative ,@without-base)) filename-no-dir)))

(defun rest-read-file (filename)
  ; remove the /var/www/vtigercrm part
  ; put /home/user/remoteserv
  (let* ((base-dir (pathname-directory "/var/www/vtigercrm/"))
	 (target-dir (pathname-directory "/home/user/remoteserv2/"))
	 (filename-dir (pathname-directory filename))
	 (without-base (rest-of-list filename-dir (length base-dir)))
	 (filename-no-dir (file-namestring filename))
	 (full-filename (cl-fad:merge-pathnames-as-file (make-pathname :directory (append target-dir without-base)) filename-no-dir))
	 (full-filename (namestring full-filename)))
      
    (cl-json:encode-json-to-string `((:content . ,(read-file-to-string full-filename)) 
				     (:filename . ,filename)
;				     (:relative-filename . ,(pathname-relative-to filename "/var/www/vtigercrm"))
				     (:without-base . ,without-base)
;				     (:filename-no-dir . ,filename-no-dir)
				     (:new-filename . ,full-filename)))))



(defun serve ()
  
  (setf *thread* (make-instance 'hunchentoot:easy-acceptor :port 8000 :document-root "~/logs/www/"))
  
;  (hunchentoot:define-easy-handler (home :uri "/") (offset count)
;    (setf offset (if (null offset) 0 offset))
;    (setf count (if (null count) 0 count))
;    (make-index offset count))
  
;  (hunchentoot:define-easy-handler (next :uri "/next") ()
;    (make-next))

  (hunchentoot:define-easy-handler (savelog :uri "/savelog") (data)
    (save-log data))

  (hunchentoot:define-easy-handler (saveerr :uri "/saveerr") (data)
    (save-err data))

  (hunchentoot:define-easy-handler (savecodecov :uri "/savecodecov") (id requesturi data) 
    (save-code-cov id requesturi data)
    )

  (hunchentoot:define-easy-handler (next :uri "/next") (cont-id)
    (make-next cont-id))
  
  (hunchentoot:define-easy-handler (file :uri "/file") (file line)
    (setf file (if (null file) "/" file))
    (setf line (if (null line) 0 line))
    (open-file-or-dir file line))

  (hunchentoot:define-easy-handler (codecovls :uri "/codecovls") (offset count)
    (when (null offset)
      (setf offset 0))
    (when (null count)
      (setf count 20))
    (make-code-cov offset count))

  (hunchentoot:define-easy-handler (codecov :uri "/codecov") (id)
    (show-code-cov id))

  (hunchentoot:define-easy-handler (rest-get-file-content :uri "/rest/file/server") (filename)
    (rest-read-file filename))

  (hunchentoot:start *thread*))

