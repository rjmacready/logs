
(module jquery.flot)

(requires (jquery))

;;; this module doesnt export globals, it add methods to $ / jquery
(exports (addmethods $ (plot)))

(components
 (jsfile "~/logs/www/js/flot/jquery.flot.js"))
