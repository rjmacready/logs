
(eval-when (:compile-toplevel)
  (ql:quickload 'hunchentoot)
  (ql:quickload 'cl-who)
  (ql:quickload 'clsql-sqlite3)
  (ql:quickload 'cl-json)
  (ql:quickload 'parenscript)
  (ql:quickload 'cl-fad)

  (load "gnuplot-server/query.lisp"))

(defparameter *conts* (make-hash-table))

(when nil
  (clsql:connect (list "logs.db") :database-type :sqlite3))

(defun index-of-column (col-name cols-list)
  (position col-name cols-list :test #'equal))

(defun config-model ()
  (multiple-value-bind (rows cols) 
      (clsql:query (format nil "SELECT * FROM configmapstore WHERE configid = (SELECT id FROM configstore LIMIT 1);"))
    (let ((serverpath (index-of-column "serverpath" cols))
	  (localpath (index-of-column "localpath" cols)))
    `((:maps . ,(mapcar
		 (lambda (n)
		   `((:serverpath . ,(nth serverpath n))
		     (:localpath . ,(nth localpath n))))
		 rows))))))

(defmacro make-query-list (funname table)
  `(defun ,funname (offset count)
     (multiple-value-bind (rows cols) 
	 (clsql:query (format nil ,(format nil "SELECT * FROM ~a LIMIT ~~d, ~~d" table) offset count))
       (declare (ignore cols))
       rows)))

;; requests
(defun request-list (offset count)
  (multiple-value-bind (rows cols)
      (clsql:query (format nil "SELECT* FROM requeststore ORDER BY ts DESC LIMIT ~d, ~d" offset count))
    (multiple-value-bind (crows) 
	(clsql:query (format nil "SELECT Count(*) FROM requeststore"))
      (values cols rows (caar crows)))))

(defun request-model (id)
  (multiple-value-bind (rows cols)
      (clsql:query (format nil "SELECT* FROM requeststore WHERE id = ~a" id))
    (let ((l '())
	  (row (first rows)))
      (loop for _colname in cols 
	   do 
	   (let ((colname (string-upcase _colname)))
	     (setf l (acons (intern colname "KEYWORD") 
			    (nth (position _colname cols :test #'equal) row)
			    l))))
      l)))

;; traces
(defun trace-list (offset count)
  (multiple-value-bind (rows cols)
      (clsql:query (format nil "SELECT* FROM tracestore ORDER BY id DESC LIMIT ~d, ~d" 
			   offset count))
    (multiple-value-bind (crows) 
	(clsql:query (format nil "SELECT Count(*) FROM tracestore"))
      (values cols rows (caar crows)))))

(defun trace-model (id)
  (multiple-value-bind (rows cols)
      (clsql:query (format nil "SELECT* FROM tracestore WHERE id = ~a" id))
    (let ((l '())
	  (row (first rows)))
      (loop for _colname in cols 
	   do 
	   (let ((colname (string-upcase _colname)))
	     (setf l (acons (intern colname "KEYWORD") 
			    (nth (position _colname cols :test #'equal) row)
			    l))))
      l)))

(defun trace-line-model (id)
  (multiple-value-bind (rows cols)
      (clsql:query (format nil "SELECT* FROM tracelinestore WHERE traceid = ~d limit 10" 
			   id))
      (values cols rows (length rows))))


;; code coverage
(defun code-cov-list (offset count)
  (multiple-value-bind (rows cols)
      (clsql:query (format nil "SELECT* FROM codecovstore ORDER BY ts DESC LIMIT ~d, ~d" offset count))  
    (values cols rows)))

(defun code-cov-req-list (id offset count)
  (multiple-value-bind (rows cols)
      (clsql:query (format nil "SELECT* FROM codecovstore WHERE reqid = '~a' ORDER BY ts DESC LIMIT ~d, ~d" id offset count))  
    (values cols rows)))

(defun code-cov-model (id)
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
      l)))

(defparameter *max-id* 0)
(defparameter *thread* nil)
(defparameter *current-config* nil)

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

	  (my-code-mirror.set-size "100%" 520)
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

(defun show-request (id)
  (declare (ignore id))
  (cl-who:with-html-output-to-string (s)
    (:html
     (:head (:title "Request"))
     (:body))))

(defun make-request (offset count)
  (multiple-value-bind (cols rows tot-count)
      (request-list offset count)
    (cl-who:with-html-output-to-string (s)
      (:html
       (:head (:title "Request"))
       (:body
	(:table :border "1"
		(cl-who:htm 
		 (:tr ;(:th "id") 
		  (:th "ts") 
		  (:th "request uri")
		  (:th "request time")
		  (:th "remote address")
		  (:th "remote port")
		  (:th :colspan "2" ""))
		 
		 (let ((id (position "id" cols :test #'equal))
		       (ts (position "ts" cols :test #'equal))
		       (reqid (position "reqid" cols :test #'equal))
		       (request_uri (position "request_uri" cols :test #'equal))
		       (request_time (position "request_time" cols :test #'equal))
		       (remote_addr (position "remote_addr" cols :test #'equal))
		       (remote_port (position "remote_port" cols :test #'equal)))
		   (mapcar
		    (lambda (item)
		      (cl-who:htm
		       (:tr ;(:td (cl-who:str (nth id item)))
			(:td (cl-who:str (nth ts item)))
			(:td (cl-who:str (nth request_uri item)))
			(:td (cl-who:str (nth request_time item)))
			(:td (cl-who:str (nth remote_addr item)))
			(:td (cl-who:str (nth remote_port item)))
			(:td (:a :href (format nil "/request?id=~d" (nth id item)) 
				 "Request"))
			(:td (:a :href (format nil "/codecovbyreq?id=~d" (nth reqid item)) 
				 "Code Cov(s)"))
			)))
		    rows))
		 )))
       (:div 
	(progn
	  (when (>= (- offset count) 0)
	    (cl-who:htm 
	     (:div (:a :href 
		       (format nil "/requestls?offset=~d&count=~d" 
			       (max (- offset count) 0) count) 
		       "Previous"))))
	  
	  (when (<= (+ offset count) tot-count)
	    (cl-who:htm
	     (:div (:a :href 
		       (format nil "/requestls?offset=~d&count=~d" 
			       (+ offset count)
			       count)
		       "Next"))))
	  )
	)))))



(defun show-code-cov (id)
  (cl-who:with-html-output-to-string (s)
    (:html
     (:head 
      (:title "Code coverage")
      (:script :src "js/codemirror-3.14/lib/codemirror.js")
;      (:link :rel "stylesheet" :href "js/codemirror-3.14/lib/codemirror.css")
      (:link :rel "stylesheet" :href "codemirror.css")
      (:link :rel "stylesheet" :href "codecov.css")
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

     (let ((model (code-cov-model id)))
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

	 (:div :class "wrapper"
	       (:div :class "files-column" (:h2 "Files")
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
			    (:tr (:td (:a :data-filename (car e) :href (format nil "#") 
					  (cl-who:fmt "~a (~d / ~d)" 
						      ;(pathname-relative-to 
						      ; (format nil "~a" (car e)) "bla bla")
						      (get-mapped-filename 
						       (format nil "~a" (car e)))
						      dist-ln 
						      hits-ln))
				      ))
			    )))
		       (cdr (assoc :content-sexp model)))))
	       
	       (:div :class "code-column"
		     (:h2 "Code goes here")
		     (cl-who:htm 
		      (:div
		       (:div (:b "File"))
		       (:div :id "div-filename" "")
		       (:textarea :id "code" "")))))
	 ))))))


(defun make-code-cov (offset count query)
  (cl-who:with-html-output-to-string (s)
    (:html
     (:head (:title "Code coverage"))
     (:body 
      (:table :border "1"
       (multiple-value-bind (cols rows) 
	   (funcall query offset count)
	 (cl-who:htm 
	  (:tr (:th "ts") (:th "link"))
	  (let ((ts (position "ts" cols :test #'equal))
		(id (position "id" cols :test #'equal)))
	    (mapcar 
	     (lambda (row)
	       (cl-who:htm
		(:tr (:td (cl-who:fmt "~a" (nth ts row))) 
		     (:td (:a :href (format nil "/codecov?id=~a" (nth id row)) 
			      "Open this coverage")))))
	     rows)))))))))

(defun rest-get-root (id)
  (cl-json:encode-json-to-string (get-root id)))

(defun rest-get-childs-of (id parent)
  (cl-json:encode-json-to-string (get-childs-of id parent)))

(defun trace-seq-diag-model (id)
  (multiple-value-bind (rows cols)
      (clsql:query (format nil "select src.function_name as src_function_name, dest.function_name as dest_function_name from tracelinestore src inner join tracelinestore dest on dest.parent = src.function_no AND dest.traceid = src.traceid and src.traceid = ~d order by src.function_no, dest.function_no limit 10 " ; limit 10" 
			   id))
      (values rows cols)))


(defun rest-trace-seq-diag-model (id offset count)
  (cl-json:encode-json-to-string 
   (multiple-value-bind (rows cols)
       (clsql:query (format nil "select src.function_name as src_function_name, dest.function_name as dest_function_name from tracelinestore src inner join tracelinestore dest on dest.parent = src.function_no AND dest.traceid = src.traceid and src.traceid = ~d order by src.function_no, dest.function_no limit ~d, ~d "
			    id
			    offset
			    count))
     (declare (ignore cols))
     rows)))

(defun rest-profile-line-model (id function-name)
  (cl-json:encode-json-to-string (profile-line-function-model id function-name)))

(defun rest-profile-timefunc-model (id)
  (cl-json:encode-json-to-string (files-spent-model id)))

(defun rest-mem-progr-model (id)
  (cl-json:encode-json-to-string (get-info-files-memory id)))

(defun rest-trace-line-model (id)
  (cl-json:encode-json-to-string (traceline-model id)))

(defun show-calls-viz (id)
  (cl-who:with-html-output-to-string (s)
    (:html
     (:head
      (:title "Calls Viz"))
     (:body
      (:script :src "js/jquery-2.0.2.min.js")
      (:script :src "js/kinetic-v4.5.4.min.js")
      (:script :src "callsviz.js")
      (:script (cl-who:str 
		(parenscript:ps* `(defvar traceid ,id))))
      
      (:div :id "container")))))

(defun show-trace (id)
  (cl-who:with-html-output-to-string (s)
    (:html
     (:head      
      (:title "Trace"))
     (:body      
      (:link :rel "stylesheet" :href "trace.css")
      (:script :src "js/jquery-2.0.2.min.js")
      (:script :src "js/flot/jquery.flot.js")
      (:script :src "js/flot/jquery.flot.stack.js")

      (:script (cl-who:str 
		(parenscript:ps* `(defvar traceid ,id))))

      (:script :src "trace.js")

      (:div (cl-who:fmt "Trace ~a" id))
      
      (:div (:a :id "memdeltatime" :href "#" "Memory delta/Time") (:br)
	    (:a :href (format nil "callsviz?id=~a" id) "Calls Viz"))
      
      (:div :id "placeholder")
      (:div :id "info_selected")
      (:div :id "more_info")
      ))))


(defun make-trace (offset count)
  (cl-who:with-html-output-to-string (s)
    (:html
     (:head (:title "Traces"))
     (:body 
      (:table :border "1"
       (multiple-value-bind (cols rows) 
	   (trace-list offset count)
	 (cl-who:htm 
	  (:tr (:th "filename") (:th "link"))
	  (let ((filename (position "filename" cols :test #'equal))
		(id (position "id" cols :test #'equal)))
	    (mapcar 
	     (lambda (row)
	       (cl-who:htm
		(:tr (:td (cl-who:fmt "~a" (nth filename row))) 
		     (:td (:a :href (format nil "/trace?id=~a" (nth id row)) 
			      "Open this trace")))))
	     rows)))))))))

(defun profile-cmd-list (profileid offset count)
  (multiple-value-bind (rows cols) (clsql:query (format nil "SELECT id, cmd FROM profilecmdstore WHERE profileid = ~a LIMIT ~a, ~a; " profileid offset count))
    (values rows cols)))

(defun show-cmd-profile (id)
  (cl-who:with-html-output-to-string (s)
    (:html
     (:head (:title "Profile Cmd"))
     (:body
      (cl-who:htm
       (:link :rel "stylesheet" :href "trace.css")
       (:script :src "js/jquery-2.0.2.min.js")
       (:script :src "js/flot/jquery.flot.js")
       (:script :src "js/flot/jquery.flot.stack.js")
       
       (:script (cl-who:str (parenscript:ps* `(defvar cmdid ,id))))
       (:script :src "profilecmd.js")
       (:div (:a :id "timespentfunction" :href "#" "Time spent / function"))
      
      (:div :id "placeholder")
      (:div :id "info_selected")
      (:div :id "more_info"))))))

(defun profile-list (offset count)
  (multiple-value-bind (rows cols) (clsql:query (format nil "SELECT id, filename FROM profilestore LIMIT ~a, ~a; " offset count))
    (values rows cols)))

(defun show-profile (id)
  (cl-who:with-html-output-to-string (s)
    (:html
     (:head (:title "Profile"))
     (:body
      (:table :border "1"
      (multiple-value-bind (rows cols) 
	   (profile-cmd-list id 0 999)
	 (cl-who:htm 
	  (:tr (:th "cmd") (:th "link"))
	  (let ((cmd (position "cmd" cols :test #'equal))
		(id (position "id" cols :test #'equal)))
	    (mapcar 
	     (lambda (row)
	       (cl-who:htm
		(:tr (:td (cl-who:fmt "~a" (nth cmd row))) 
		     (:td (:a :href (format nil "/profilecmd?id=~a" (nth id row)) 
			      "Open this profile")))))
	     rows)))))))))

(defun make-profile (offset count)
  (cl-who:with-html-output-to-string (s)
    (:html 
     (:head (:title "Profiles"))
     (:body
      (:table :border "1"
      (multiple-value-bind (rows cols) 
	   (profile-list offset count)
	 (cl-who:htm 
	  (:tr (:th "filename") (:th "link"))
	  (let ((filename (position "filename" cols :test #'equal))
		(id (position "id" cols :test #'equal)))
	    (mapcar 
	     (lambda (row)
	       (cl-who:htm
		(:tr (:td (cl-who:fmt "~a" (nth filename row))) 
		     (:td (:a :href (format nil "/profile?id=~a" (nth id row)) 
			      "Open this profile")))))
	     rows)))))))))


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


; create table codecovstore(id integer primary key, reqid nvarchar(10), ts timestamp, content text)
; create table requeststore(id integer primary key, reqid nvarchar(10), ts timestamp, request_uri text, request_time timestamp, remote_addr nvarchar(20), remote_port integer)
; create table tracelinestore(id integer primary key, function_no integer, filename text, lineno integer, function_name text, parent integer, traceid integer)
; create table tracestore(id integer primary key, filename text)
(defun save-code-cov (id request xdebug data)
  (declare (ignore xdebug))
  (let ((ts (get-universal-time)))
    (clsql:with-transaction ()
      (clsql:execute-command 
       (format nil "insert into codecovstore (reqid, ts, content) values('~a', ~a, '~a')" 
	       id
	       ts
	       data))
      (let ((request (cl-json:decode-json-from-string request)))
	(clsql:execute-command
	 (format nil "insert into requeststore (reqid, ts, request_uri, request_time, remote_addr, remote_port) values('~a', ~a, '~a', ~a, '~a', ~a)" 
		 id
		 ts
		 (cdr (assoc :requesturi request))
		 (cdr (assoc :requesttime request))
		 (cdr (assoc :remoteaddr request))
		 (cdr (assoc :remoteport request))))))
    (format nil "~a ~a" "ok" 0)))


(defun save-log (data)
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
  (declare (ignore line))
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
	   (cl-who:htm
	    (:div (:b "Listing"))
	    (mapcar 
	     (lambda (n) 
	       (cl-who:htm (:div (:a :href (format nil "/file?file=~a" n) (cl-who:str n)))))
	     (list-dir file)))
	   )
	
		 
	(when (not (directory-pathname-p file))
	  (cl-who:htm 
	   (:div
	    (:div (:b "File"))
	    (:div (cl-who:str file))
	    (:textarea :id "code" (cl-who:str (read-file-to-string file)))))
	 ))))))




(defun read-file-to-string (pathname)
  (with-output-to-string (out)
    (with-open-file (in pathname)
      (handler-bind ((SB-INT:STREAM-DECODING-ERROR 
		      #'(lambda(err) 
			  (declare (ignore err)) 
			  (invoke-restart 'sb-int:attempt-resync))))
	(loop with buffer = (make-array 8192 :element-type 'character)
	   for n-characters = (read-sequence buffer in)
	   while (< 0 n-characters)
	   do (write-sequence buffer out :start 0 :end n-characters))))))


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

;(defun pathname-relative-to (filename base-dir)
;  (let* ((base-dir (pathname-directory base-dir))
;	 (filename-dir (pathname-directory filename)) 
;	 (without-base (rest-of-list filename-dir (length base-dir)))
;	 (filename-no-dir (file-namestring filename)))
;    (cl-fad:merge-pathnames-as-file (make-pathname :directory `(:relative ,@without-base)) filename-no-dir)))

(defun directory-starts-with-p (pdirname psubdir)
    (let ((lt (length pdirname))
	  (lg (length psubdir)))
      (if (> lg lt)
	  nil
	  (equal psubdir (subseq pdirname 0 lg)))))

(defun get-mapped-filename (filename)
  (let* ((filename-dir (pathname-directory filename))
	 (f (find-if
	    (lambda (mapping)
	      (let ((pmapping (pathname-directory (cdr (assoc :serverpath mapping)))))
		(directory-starts-with-p filename-dir pmapping)))
	    (cdr (assoc :maps *current-config*)))))
    (if (null f)
	(values filename)
	(let* ((base-dir (pathname-directory (cdr (assoc :serverpath f))))
	       (target-dir (pathname-directory (cdr (assoc :localpath f))))
	       (without-base (rest-of-list filename-dir (length base-dir)))
	       (filename-no-dir (file-namestring filename))
	       (full-filename (cl-fad:merge-pathnames-as-file
			       (make-pathname :directory (append target-dir without-base)) 
			       filename-no-dir)))
	  (values (namestring full-filename))))))


(defun rest-read-file (filename)

  ; using the current config, find a valid mapping; 
  ; otherwise, read filename as is

  ; remove the /var/www/vtigercrm part
  ; put /home/user/remoteserv
;  (let* ((base-dir (pathname-directory "/var/www/vtigercrm/"))
;	 (target-dir (pathname-directory "/home/user/remoteserv2/"))
;	 (filename-dir (pathname-directory filename))
;	 (without-base (rest-of-list filename-dir (length base-dir)))
;	 (filename-no-dir (file-namestring filename))
;	 (full-filename (cl-fad:merge-pathnames-as-file (make-pathname :directory (append target-dir without-base)) filename-no-dir))
;	 (full-filename (namestring full-filename)))
 ;   (cl-json:encode-json-to-string `((:content . ,(read-file-to-string full-filename)) 
;				     (:filename . ,filename)
;				     (:without-base . ,without-base)
;				     (:new-filename . ,full-filename))))

  (let ((real-filename (get-mapped-filename filename)))
    (cl-json:encode-json-to-string `((:content . ,(read-file-to-string real-filename)) 
				     (:filename . ,filename)
				     (:new-filename . ,real-filename)))))

(defun make-index ()
  (cl-who:with-html-output-to-string (s)
    (:html
     (:head)
     (:body
      (:div 
       (:h2 "Listings")
       (:div (:a :href "/codecovls" "All code coverages from xdebug"))
       (:div (:a :href "/requestls" "All requests logged"))
       (:div (:a :href "/tracesls" "All traces gathered"))
       (:div (:a :href "/profilels" "All profiles gathered")))
      (:div
       (:h2 "Configurations")
       (:div (:a :href "/configprofile" "Configuration profiles")))))))


(defun make-configprofile ()
  (cl-who:with-html-output-to-string (s)
    (:html
     (:head
      (:link :rel "stylesheet" :href "js/configprofile.css")
      (:script :src "js/jquery-2.0.2.min.js"))
     (:body
      (:script :src "js/configprofile.js")
      (:div
       (:a :href "/" "Return to home")
       (:h2 "Mappings")
       (:div (:span "A mapping ") (:i "maps") (:span " paths in the server with local paths.")
	     (:span "If you wish to work locally (php sources and this web server are in the same computer) you do not need to use this. Otherwise all script files with a valid mapping present will be translated."))
       (:div
	(:form :id "realdeal" :action "configprofilesave" :method "post"
	       (:input :id "realdata" :name "realdata" :type "hidden" :value "")
	       (:input :name "submit" :type "submit")))
       (:div
	(:div (:div :style "float: left;" "serverpath") 
	      (:div :style "float: left;" "/")
	      (:div "localpath"))

	(:form :id "puppet-one" ;:action "configprofilesave" :method "post"

;	 (:div :class "line"
;	       (:input :type "text" :name "serverpath")
;	       (:input :type "text" :name "localpath"))

	 (let ((maps (cdr (assoc :maps *current-config*))))	   
	   
		  ; put the rest of the elements, with remove bt
	   (mapcar
	    (lambda (n)
	      (cl-who:htm
	       (:div :class "line" 
		     (:a :class "removeline" :href "#" "Remove")
		     (:input :type "text" :name "serverpath" :value 
			     (cl-who:str (cdr (assoc :serverpath n))))
		     (:input :type "text" :name "localpath" :value
			     (cl-who:str (cdr (assoc :localpath n)))))))
	    maps))
	 (:div (:a :id "addline" :href "#" "Add"))
	 (:div (:input :id "submitid" :type "button" :value "save"))))
       (:h2 "XDebug")
       (:div (:span "Configure here ports for debugging, folders with trace/profile files."))
       )))))

(defun save-configprofile (jdata)
  (let ((data (cl-json:decode-json-from-string jdata)))
    (clsql:with-transaction ()
      (clsql:execute-command "DELETE FROM configstore;")
      (clsql:execute-command "DELETE FROM configmapstore;")
      (clsql:execute-command 
       (format nil "INSERT INTO configstore(description) values ('~a');" ""))
      (let ((configid (caar (clsql:query "select last_insert_rowid()")))
	    (maps (cdr (assoc :maps data))))
	(mapc
	 (lambda (i)
	   (let ((serverpath (cdr (assoc :serverpath i)))
		 (localpath (cdr (assoc :localpath i))))
	     (clsql:execute-command 
	      (format nil "INSERT INTO configmapstore (configid, serverpath, localpath) VALUES (~a, '~a', '~a')" configid serverpath localpath))))
	 maps)
	(setf *current-config* (config-model))
	))))

; create table configstore(id integer primary key, description text);
; create table configmapstore(id integer primary key, configid integer, serverpath text, localpath text);

(defun serve ()
  
  (setf *thread* (make-instance 'hunchentoot:easy-acceptor :port 8001 :document-root "~/logs/www/"))

  (hunchentoot:define-easy-handler (configprofilesave :uri "/configprofilesave") (realdata)
    ;(print (hunchentoot:raw-post-data))
    ;(print "hey")
    (save-configprofile realdata)
    ;(print "ok")
    (hunchentoot:redirect "/")
    )

  (hunchentoot:define-easy-handler (configprofile :uri "/configprofile") ()
    (make-configprofile))

  (hunchentoot:define-easy-handler (index :uri "/") ()
    (make-index))
  
  (hunchentoot:define-easy-handler (savelog :uri "/savelog") (data)
    (save-log data))

  (hunchentoot:define-easy-handler (saveerr :uri "/saveerr") (data)
    (save-err data))

  (hunchentoot:define-easy-handler (savecodecov :uri "/savecodecov") (id request xdebug data) 
    (save-code-cov id request xdebug data)
    )

  (hunchentoot:define-easy-handler (next :uri "/next") (cont-id)
    (make-next cont-id))
  
  (hunchentoot:define-easy-handler (file :uri "/file") (file line)
    (setf file (if (null file) "/" file))
    (setf line (if (null line) 0 line))
    (open-file-or-dir file line))

  (hunchentoot:define-easy-handler (tracesls :uri "/tracesls") (offset count)
    (when (null offset)
      (setf offset 0))
    (when (null count)
      (setf count 20))
    (make-trace offset count))

  (hunchentoot:define-easy-handler (tracehandler :uri "/trace")
      (id)
    (show-trace id))

  (hunchentoot:define-easy-handler (codecovls :uri "/codecovls") (offset count)
    (when (null offset)
      (setf offset 0))
    (when (null count)
      (setf count 20))
    (make-code-cov offset count #'code-cov-list))

  (hunchentoot:define-easy-handler (codecovbyreq :uri "/codecovbyreq")
      (id offset count)
    (if (null offset)
	(setf offset 0)
	(setf offset (parse-integer offset)))
    (if (null count)
	(setf count 20)
	(setf count (parse-integer count)))  
    (make-code-cov offset count (lambda (o c)
				  (code-cov-req-list id o c))))

  (hunchentoot:define-easy-handler (codecov :uri "/codecov")
      (id)
    (show-code-cov id))

  (hunchentoot:define-easy-handler (trace-get-root :uri "/rest/trace/get-root") (id)
    (rest-get-root id))

  (hunchentoot:define-easy-handler (trace-get-childs-of :uri "/rest/trace/get-childs-of") (id parent)
    (rest-get-childs-of id parent))

  (hunchentoot:define-easy-handler (callsviz :uri "/callsviz") (id)
    (show-calls-viz id))

  (hunchentoot:define-easy-handler (profilels :uri "/profilels") 
      (offset count)
    (if (null offset)
	(setf offset 0)
	(setf offset (parse-integer offset)))
    (if (null count)
	(setf count 20)
	(setf count (parse-integer count)))
    (make-profile offset count))

  (hunchentoot:define-easy-handler (showprofilecontent :uri "/profile") 
      (id)
    (show-profile id))

  (hunchentoot:define-easy-handler (showprofilecmdcontent :uri "/profilecmd") 
      (id)
    (show-cmd-profile id))
  
  (hunchentoot:define-easy-handler (requestls :uri "/requestls") 
      (offset count)
    (if (null offset)
	(setf offset 0)
	(setf offset (parse-integer offset)))
    (if (null count)
	(setf count 20)
	(setf count (parse-integer count)))
    (make-request offset count))

  (hunchentoot:define-easy-handler (request :uri "/request") 
      (id)
    (show-request id))

  (hunchentoot:define-easy-handler (rest-profile-line-content :uri "/rest/profile/line")
      (id function-name)
    (rest-profile-line-model id function-name))

  (hunchentoot:define-easy-handler (rest-profile-timefunc-content :uri "/rest/profile/timefunc")
      (id)
    (rest-profile-timefunc-model id))

  (hunchentoot:define-easy-handler (rest-mem-progr-content :uri "/rest/trace/memprogr")
      (id)
    (rest-mem-progr-model id))

  (hunchentoot:define-easy-handler (rest-trace-line-content :uri "/rest/trace/line")
      (id)
    (rest-trace-line-model id))

  (hunchentoot:define-easy-handler (rest-get-file-content :uri "/rest/file/server") 
      (filename)
    (rest-read-file filename))

  (hunchentoot:define-easy-handler (rest-get-trace-nodes :uri "/rest/trace/node")
      (id offset count)
    (rest-trace-seq-diag-model id offset count))

  (hunchentoot:start *thread*))

