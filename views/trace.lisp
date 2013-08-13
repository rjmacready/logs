;;; the "top-level" is a page
(page trace.html)

;;; ideally we can load a html page or a cl-who tree as a template
;;; we then can use a jquery-ish interface to query 
;;; and manipulate tags / elements
(base 
 (htmlfile "~/logs/www/trace.html"))


;;; we may need a simpler syntax ...
;;;     $('title').innerText('Trace page');
(with (title) (e)
      (setf e.innerText "Trace page"))


