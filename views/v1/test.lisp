
(progn
  (print "TESTING")

  ; now we can make this:
  (defparameter *page* (make-instance 'default2))
  (setf (slot-value *page* 'title) "hello world")
  (print (toview *page*))

  (setf *page* (make-instance 'default3))
  (setf (slot-value *page* 'title) "hello world")
  (setf (slot-value *page* 'more) 
	(make-instance 'html :tree '(:div "hello hello!")))
  (print (toview *page*)))

(with-page default3 page
  (with-slots (title) page
    (setf title "a title")
    (print (toview page))))
