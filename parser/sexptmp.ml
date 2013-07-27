
open Stmp;;

(* main stub. hand written. *)
let sexp_of_program (x : 'a list) =
  List.map Stmp.sexp_of_toplevel x;;
