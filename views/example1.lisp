(control chart 
	 (version 0.0.1))

;;; list of requirements (modules, etc)
;;; is a good idea to infere this at compile time?
;;; I guess maybe not ...
(requires (jquery.flot))

;;; 

;;; on load of this fragment
(load (lambda ()
	nil))

;;; binds on events will be setup at control load;
(plotclick (lambda (event pos item)
	     nil))
