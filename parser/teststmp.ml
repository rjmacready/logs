open Sexptmp;;
open Common;;
open Common2;;
open Ast_php;;

(* parse files, output cst as s-expression *)
let files = Lib_parsing_php.find_php_files_of_dir_or_files ["/home/user/logs/test/"] in
files +> List.iter (fun x -> 
  pr2 (spf "File %s" x);
  let cst = Parse_php.parse_program x in
  let s = Sexptmp.sexp_of_program cst in
  List.map pr2 s;
  ());
