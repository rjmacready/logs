
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
