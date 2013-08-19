
; a port of jquery-ish querying to lisp ...
; this has some "monadic" behaviour (or at least, what i perceive to be monadic)

(defclass iterable () ())
(defclass iterable-notnull (iterable) ((elem :initarg :elem)))
(defclass iterable-null (iterable) ())
(defclass iterable-single (iterable-notnull) ())
(defclass iterable-list (iterable-notnull) ())

(defmethod wrap-iterable ((e iterable))
  ; stay frosty. return as-is.
  e)
(defmethod wrap-iterable ((e null))
  (make-instance 'iterable-null))
(defmethod wrap-iterable ((e list))
  (make-instance 'iterable-list :elem e))
(defmethod wrap-iterable (e)
  (make-instance 'iterable-single :elem e))


(defmethod emap ((f function) (i iterable-null))
  ; continue frosty. return as-is, do nothing.
  i)
(defmethod emap ((f function) (i iterable-single))
  (wrap-iterable (funcall f (slot-value i 'elem))))
(defmethod emap ((f function) (i iterable-list))
  (wrap-iterable (mapcar f (slot-value i 'elem))))

; ------------------

; TODO we need a selector factory!
; TODO we need a transparent way of combinating selectors!
; TODO slots should be read-only! setable only at constructor-time!
(defclass selector () ())

; ------------------

; works like an (AND selector-1 ... selector-n)
(defclass selector-combination (selector)
  ((selectors :initarg :selectors)))

; TODO we need to enforce:
; * selectors should be a list
; * selectors should have at least one element
; * each element should be a subtype of selector

(defmethod compileselector ((s selector-combination))
  (with-slots (selectors) s
    (if (= 1 (length selectors))
	(compileselector (car selectors))
	; assume we dont have an empty list!
	; condition should be caught at construtor!
	(let ((compiled (mapcar #'compileselector selectors)))
	  (lambda (node)
	    (not 
	     ; (1) by default loop returns nil, and for now
	     ; I can't seem to find a way to work around this.
	     ; so we'll use T to signal a condition fail, then
	     ; we'll "not" the value
	     (loop 
		for x in compiled
		for y = (funcall x node)
		when (not y) return T)))))))

; ------------------

(defclass selector-class (selector)
  ((class :initarg :class)))

(defmethod initialize-instance ((s selector-class) &key class)
  (unless (or (typep class 'list) (typep class 'string))
    (error "class should be a list or a string!"))
  (setf (slot-value s 'class) class))

; TODO this could be cleaner, more optimized ...
(defmethod compileselector ((s selector-class))
  (with-slots (class) s
    (lambda (node)
      ; lets get to the :class attribute
      (let ((classes (assoc :class (slot-value node 'attrs))))
	(unless (null classes)
	  (let ((class-value (cdr classes)))
	    (typecase class
	      (string (if (position-if (lambda (n) (equal n class)) class-value)
			  T
			  nil))
              ; ALL classes should be matched!
	      (list
	       ; check comment signaled with (1)
	       (not 
		(loop 
		   for class in class
		   ; look for it ...
		   unless (position-if (lambda (n) (equal n class)) class-value)
		   return T))))))))))

; ------------------

(defclass selector-tagname (selector)
  ((tagname :initarg :tagname)))

(defmethod initialize-instance ((s selector-tagname) &key tagname)
  (unless (typep tagname 'keyword)
    (error "tagname should be a keyword!"))
  (setf (slot-value s 'tagname) tagname))

(defmethod compileselector ((s selector-tagname))  
  (with-slots (tagname) s
    (lambda (node)
      (eql tagname (slot-value node 'tagname)))))

; ------------------

(defclass selector-attr (selector)
  ((attr-name :initarg :attr-name)
   (attr-value :initarg :attr-value)))

(defmethod initialize-instance ((s selector-attr) &key attr-name attr-value)
  (unless (typep attr-name 'keyword)
    (error "attr-name should be a keyword!"))
  (unless (typep attr-value 'string)
    (error "attr-value should be a string!"))
  (setf (slot-value s 'attr-name) attr-name)
  (setf (slot-value s 'attr-value) attr-value))

(defmethod compileselector ((s selector-attr))
    (with-slots (attr-name attr-value) s
      (lambda (node)
	(with-slots (attrs) node
	  (equal (cdr (assoc attr-name attrs)) attr-value)))))

; ------------------

(defclass htmlnode ()
  ((tagname :initarg :tagname)
   (attrs :initarg :attrs)
   (inner :initarg :inner)))


(defun split-by-whitespace (s)
  ; when the string starts with empty spaces, we
  ; win a wonderfull price: an empty string at the car
  ; of cl-ppcre:split. Of course I could run a cl-ppcre:scan to
  ; find the first non-whitespacy char of the string, 
  ; but is that really better? is this way really ugly? 
  ; for now I'll keep things "lispy", so here we go:
  (remove-if (lambda (s) (equal s "")) 
	     (cl-ppcre:split "\\s+" s)))

; -------------------
; Convert from cl-who trees to htmlnode (our) trees
; our trees will be more friendly for querying

(defun parsewhonode (whonode)
  "Parses a cl-who tree (WHONODE) and returns its tagname attrs and children, unprocessed"
  ; all this calls are destructive.
  ; we'll wreak havoc on whonode!! :v
  (let* ((tagname (pop whonode))
	(children nil)
	(attrs nil))    
    ; read attributes
    (labels ((depair ()
	       (when (keywordp (car whonode))
		 (let* ((key (pop whonode))
			(value (pop whonode)))

		   (when (eql key :class)
		     (setf value (split-by-whitespace value)))

		   (setf attrs (acons key value attrs)))
		 (depair))))
      (depair))
    ; reverse attrs. usually, id is the first defined element.
    (setf attrs (reverse attrs))    
    ; read children (... rest)
    (setf children whonode)
    ; return stuff
    (values tagname attrs children)))

; ------------------
; convert a cl-who into a htmlnode tree.

(defmethod fromwho ((rawtext string))
  rawtext)

(defmethod fromwho (whotree)
  "Converts a cl-who html tree into a htmlnode tree (easier for querying).
We can think some steps ahead and index the all tree, but thats a different story."
  ; lets assume the cl-who tree is validated
  (multiple-value-bind (tagname attrs children) (parsewhonode whotree)
    (make-instance 'htmlnode 
		   :tagname tagname 
		   :attrs attrs 
		   :inner (mapcar #'fromwho children))))

; -------------------


(defmethod flatten-str ((s string))
  s)

(defmethod flatten-str ((l list))
  "Join elements in a list, separated with spaces"
  (format nil "~{~A~^ ~}" l))

; -------------------
; convert our trees into cl-who trees.
; the goal, being printable with with-output-to-html 

(defmethod towho (other)
  other)

(defmethod towho ((node htmlnode))
  (with-slots (tagname attrs inner) node
    (let ((r `(,tagname)))
      (unless (null attrs)
	; lets flatten attrs.
	; some attributes (such as :class) are slit in lists;
	; of course flattening a string results in the same string
	(setf r (append r (mapcan (lambda (e) 
				    `(,(car e) 
				       ,(flatten-str (cdr e)))) attrs))))
      (unless (null inner)
	(setf r (append r (mapcar #'towho inner))))
    
      r)))

; -------------------

; more for debugging. i should create also a read-object
(defmethod print-object ((node htmlnode) stream)
  (with-slots (tagname attrs inner) node
    (write-string "('htmlnode " stream)
    (write tagname :stream stream)
    (write-string " " stream)
    (write attrs :stream stream)
    (write-string " " stream)
    (write inner :stream stream)
    (write-string ")" stream)))

; -------------------
; Walk/Manipulate a htmlnode tree

(defmethod walk ((cb function) (node htmlnode))
  ; call cb on this node
  (funcall cb node)
  ; call walk on inner
  (walk cb (slot-value node 'inner))
  nil)

(defmethod walk ((cb function) (l list))
  (mapcar (lambda (e) (walk cb e)) l)
  nil)

(defmethod walk ((cb function) _)
  nil)

; ------------------
; Top level stuff

(defclass lquery ()
  ((tree :initarg :tree)))

(defmethod select ((e lquery) (s selector))
  "Your regular $(\"tagname #a_id .a_class\")"
  ; Lets walk the tree and return all nodes that match s
  (let ((scan (compileselector s))
	(result nil))
    (walk (lambda (e)	    
	    (when (funcall scan e)
	      (push e result))) (slot-value e 'tree))
    (wrap-iterable result)))

(defmethod html ((e iterable) &rest new-trees)
  (let ((compiled (mapcar #'fromwho new-trees)))
    (emap (lambda (e)
	    (with-slots (inner) e
	      (setf inner compiled)
	      nil)) e)
    e))

; -------------------