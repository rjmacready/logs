
(eval-when (:compile-toplevel)
  (ql:quickload 'cl-who)

  ; a scalar var.
  ; a value or a single html node
  (defclass htmlvar ()
    ((name :accessor htmlvar-name :initarg :name)))

  ; #@varname
  (set-dispatch-macro-character #\# #\@ 
				#'(lambda (a b c) 
				    (declare (ignore b c))
				    (make-instance 'htmlvar :name (read a))))

  (defun tree-map (fun ls)
    (labels ((walker (e)
	       (typecase e
		 (list (mapcar #'walker e))
		 (T (multiple-value-bind (r v) (funcall fun e)
		      (if (null r)
			  e
			  v))))))
      (mapcar #'walker ls)))
  )


; -----------------------------------------------------------

; a html tree ready to be dumped
(defclass html ()
  ((tree :accessor html-tree :initarg :tree)))

(defmethod toview ((e html))
  (eval `(cl-who:with-html-output-to-string (s)
	   ,(html-tree e))))

; -----------------------------------------------------------

(defmethod toview ((e string)) e)

; -----------------------------------------------------------

; Failsafe, leave these ones alone
(defmethod toview ((e null))
  "")

(defmethod toview (another)
  (let ((typof-another (type-of another)))
    (error 
     (format nil "I dont know how to handle ~a. Do (defmethod toview ((_ ~a)) ...) or (defmethod toview ((_ some-parent-type)) ...)"
	     typof-another
	     typof-another))))

; -----------------------------------------------------------

(defmacro defmaster (name &body body)
  (let ((tbody body))
    `(defun ,name ()
       (cl-who:with-html-output-to-string (s)
	 ,@tbody))))

; a defmaster defines the main html.
; this is important because certain components
; need to do stuff on head, or body alone
(defmaster default
    (:html
     (:head
      (:title))
     (:body)))

; -----------------------------------------------------------

(defmacro defmaster2 (name &body body)
  (let* ((name name)
	(*vars '())
        ; analyze body, look for vars ...   
        ; we dont care about correctness, for now ...
	(tbody
	 (tree-map 
	  (lambda (i)
	    (typecase i
	      (htmlvar (let ((varname (htmlvar-name i)))
			 (push varname *vars)
			 (values T `(cl-who:str (toview ,varname)))))
	      (T nil)))
	  body)))
  
    `(progn

       ; define a class
       (defclass ,name ()
	 ; define slots
	 (,@(loop for x in *vars
	       collect `(,x :initform nil))
	  ))

       ; define toview. the tree is not "hidden" inside the class
       ; because i'm evil
       (defmethod toview ((instance ,name))
	 (with-slots ,(loop for x in *vars collect x) instance
	   (cl-who:with-html-output-to-string (s)
	     ,@tbody))))))


; we define a view, with variables
(defmaster2 default2
    (:html
     (:head
      (:title #@title))
     (:body
      (:div :id "content"))))

(defmaster2 default3
    (:html
     (:head
      (:title #@title))
     (:body
      (:div :id "content")
      #@more)))

(defmacro with-page (type pagename &body body)
  `(let ((,pagename (make-instance ',type)))
     ,@body))

