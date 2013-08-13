;;; a module defines reusable js code, ideally frameworks
;;; such as jquery, underscore, etc etc etc 

;;; jquery may be a bad example. we may want to commit our view compiling
;;; stuff with jquery. jquery is awesome.
(module jquery
	; add version information, it may be usefull.
	(version 2.0.2))

;;; this will help us resolving dependencies.
;;; the global keyword means that the js' global 
;;; scope will be poluitted with global variables
;;; as '$' is an alias for 'jQuery', put them all together
(exports (global $ jQuery))

(components
 ;;; point here to physical files.
 ;;; its way more usefull to reuse existing js files than
 ;;; translate everything to lisp
 (jsfile "~/logs/www/js/jquery-2.0.2.min.js"))
