
; a port of jquery-ish querying to lisp ...

(defclass iterable () ((elem :initarg :elem)))
(defclass iterable-single (iterable) ())
(defclass iterable-list (iterable) ())

(defmethod emap ((f function) (i iterable-single))
  (funcall f (slot-value i 'elem)))

(defmethod emap ((f function) (i iterable-list))
  (mapcar f (slot-value i 'elem)))

; ------------------
(defclass selector ()
  ((attr-name :initarg :attr-name)
   (attr-value :initarg :attr-value)))


; ------------------

(defclass lquery ()
  ((tree :initarg :tree)))

(defmethod select ((e lquery) )
  "select")

; -------------------