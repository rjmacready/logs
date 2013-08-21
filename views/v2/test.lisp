
(defparameter *tree* nil)

; init tree. 
; ideally, this html could be compiled from a .html file
(setf *tree* (fromwho '(:html 
			(:head
			 (:title)) 
			(:body 
			 (:h1 "test")
			 (:div :id "header" :class "header se" )
			 (:div :id "container" :class "se ve ral")
			 (:div :class "ve")
			 (:div :id "footer" :class "se")))))

; lets walk the htmlnode tree, print ourselves some tags
(walk (lambda (node)
	(with-slots (tagname attrs) node
	  (print `(,tagname ,attrs)))) *tree*)

; create instance of lquery (analogous to $)
(defparameter *lq* nil)
(setf *lq* (make-instance 'lquery :tree *tree*))

(defparameter *res* nil)

; dump tree
(towho *tree*)

; change content of <title>
; $('title').html('hello world');
(setf *res* (select *lq* (make-instance 'selector-tagname
					:tagname :title)))
(html *res* "hello world")

; change content of div#container
; $('#container').html('<div>...</div><div>...</div>');
(setf *res* (select *lq* (make-instance 'selector-attr
					:attr-name :id 
					:attr-value "container")))

(html *res* 
      '(:div "added dynamically") 
      '(:div "so was this one"))

; dump tree
(towho *tree*)

(setf *res* (select *lq* (make-instance 'selector-class
					:class "se")))

(setf *res* (select *lq* (make-instance 'selector-class
					:class '("se" "ve"))))

(setf *res* 
      (select *lq* 
	      (make-instance 'selector-combination 
			     :selectors (list
					 (make-instance 'selector-tagname
							:tagname :div)
					 (make-instance 'selector-class
							:class '("se" "ve"))))))

(ql:quickload 'cl-html-parse)

;(html-parse)

(with-open-stream (v (open "/home/user/logs/views/v2/index.html"))
  (let ((htmltree (html-parse:parse-html v)))
    ; TODO check doctype, it might be the head, it might not. :|
    (defparameter *tree* (cadr htmltree))
    
    ;(print *tree*)
    ; this tree is not what we have in mind
    ; lets clean it
    
    ;(mapcar (compose print car) (cadr htmltree))
    ; a list where:
    ; * car is the node
    ; * cdr are the children
     (labels ((do-node (node)
		(typecase node
		  (string node)
		  (list 
		   (let ((tagname-and-attrs (car node))
			 (children (cdr node)))
		  ; a node can be a single keyword (no attrs)
		  ; or a list (and the head is the tagname and cdr the attrs. weird.)
		  
		     (unless (eq :comment tagname-and-attrs)
		       `(,@(if (listp tagname-and-attrs)
			       tagname-and-attrs
			       (list tagname-and-attrs))

			   ,@(reverse 
			      (reduce (lambda (tot n)
					(let ((r (do-node n)))
					  (unless (null r) 
					    (push r tot))
					  tot))
				      children
				      :initial-value nil))
			   ;,@(mapcar #'do-node children)
			   ))
		     
		     )))))
      
       (let ((e (do-node *tree*)))
	 ;(print e)
	 ;(print '------)
	 (print (eval `(cl-who:with-html-output-to-string (s)
	 		 ,e)))
	 )
	 
    )))

(ql:quickload 'cl-who)

(progn
  (setf (cl-who:html-mode) :html5)

  (cl-who:with-html-output-to-string (s nil :prologue T)
    (:html 
     (:head)
     (:body))))

; TODO
; test conversions...
; convert file -> tree -> cl-who -> file
; redo and match. basically, see if html-parse <=> cl-who is simmetrical / inversable


; playing around ...

(defmacro compose (f g)
  `(lambda (n) (,f (,g n))))


(set-macro-character #\!
		     (lambda (stream _)
		       (let ((arg-no (read stream)))
			     (unless (numberp arg-no)
			       (error "expected a number!"))
			     `(*L-Args-get-argument* ,arg-no))) )

(defmacro -\ (&body sexp)
  `(lambda (&rest *L-Args-Name*)
     (labels ((*L-Args-get-argument* (arg-no) (nth arg-no *L-Args-Name*)))
       ,@sexp)))

(-\ (print "hi"))
(-\ (print !0))

(funcall (,\ (print !0)) "hello world")


(defmacro curry (function no-args)
  (when (< no-args 1)
    (error "hasta la vista funny guy"))
  
  (let ((args (loop for x from 1 to no-args
		 collect (gensym)))) 
    
    (labels ((rec-curry (narg larg)
	       (if (= narg 1)
		   `(lambda (,(car larg))
		      (funcall ,function
			       ,@args))
		   `(lambda (,(car larg))
		      ,(rec-curry (- narg 1) (cdr larg)))))))
    
    (rec-curry no-args args))))

; TODO ...
(defmacro defcurried (name (&rest args-list) &body body)
  `(defun ,name (,@args-list)
     nil))

(defcurried print-3 (a b c)
  (print a b c))
