
open Common;;
open Common2;;
open Ast_php;;
module V = Visitor_php;;


let str_of_info info =
  let file = Parse_info.file_of_info info in
  let line = Parse_info.line_of_info info in
  let col = Parse_info.col_of_info info in
  spf "(:file \"%s\" :line %d :column %d)" file line col;;

let sexp_of_func_def func_def =
  let s = Ast_php.str_of_ident func_def.f_name in 
  let info = Ast_php.info_of_ident func_def.f_name in
  let strinfo = str_of_info info in
  pr2 (spf "(:type :function :name \"%s\" :location %s)" s strinfo);;

let sexp_of_class_def class_def =
  let s = Ast_php.str_of_ident class_def.c_name in
  let info = Ast_php.info_of_ident class_def.c_name in
  let strinfo = str_of_info info in
  pr2 (spf "(:type :class :name \"%s\" :location %s)" s strinfo);;

let sexp_of_method_def method_def =
  let s = Ast_php.str_of_ident method_def.f_name in
  let info = Ast_php.info_of_ident method_def.f_name in
  let strinfo = str_of_info info in
  pr2 (spf "(:type :method :name \"%s\" :location %s)" s strinfo);;

let walk_file file = (* "/home/user/logs/test/index.php" in *)
let ast = Parse_php.parse_program file in
(*pr2 (spf "AST: %s" (Export_ast_php.ml_pattern_string_of_program ast));*)
let visitor = V.mk_visitor { V.default_visitor with
  (* V.kexpr = (fun (k, _) e ->
    
    match e with
      | Call (Id funcname, args) ->
        let s = Ast_php.str_of_name funcname in
        let info = Ast_php.info_of_name funcname in
        let line = Parse_info.line_of_info info in
        pr2 (spf "Call to %s at line %d" s line);
        k e     
      | _ ->
        k e
  ); *)
  V.kfunc_def = (fun (k, _) d -> 
    sexp_of_func_def d;
    k d);
  V.kclass_def = (fun (_, _) c ->
    sexp_of_class_def c;
    (unbrace c.c_body) +> List.iter (fun class_stmt -> 
     match class_stmt with
       | Method func_def ->
	 sexp_of_method_def func_def
       | _ -> ())); 
} in
visitor (Program  ast);; (*
Printf.printf "%s\n" file;;
*)


(*let walk_file2 fname = 
*)


let files = Lib_parsing_php.find_php_files_of_dir_or_files ["/home/user/logs/test/"] in
files +> List.iter (fun x -> pr2 (spf "%s" x));
files +> List.iter (fun x -> walk_file x);
