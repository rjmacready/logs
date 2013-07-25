
open Common;;
open Ocaml;;
open Ast_ml;;
module Ast = Ast_ml;;
module Parse = Parse_ml;;
module V = Visitor_ml;;

let c = open_out "p.tmp";;
let pr2 x = 
  output_string c (x^"\n");;

(* *********************** *)


let str_of_name name = 
  match name with
    | Name((n, _)) -> n;;

let str_of_longname longname =
  match longname with
    | (qualifiers, name) ->
      String.concat "."       
	(List.concat [(List.map (function (n1, _) -> str_of_name n1) qualifiers);
		      [str_of_name name]]);;

let rec str_of_ty ty =
  let str_of_tyargs args =
    (match args with
      | TyArg1 t -> str_of_ty t;
      | TyArgMulti tyls ->
	let (_, tyls, _) = tyls in
	let c = String.concat ", " 
	  (List.concat 
	     (List.map 
		(function Left x -> [str_of_ty x] | Right _ -> []) tyls)) in
	spf "(%s)" c) in
  match ty with
  | TyName(longname) -> 
    str_of_longname longname;
  | TyVar((_, name)) -> 
    spf "'%s" (str_of_name name);
  | TyTuple(tyls) -> 
    
    let c = String.concat " * " (List.concat (List.map (function Left x -> [str_of_ty x] | Right _ -> []) tyls)) in
    spf "%s" c;

  | TyTuple2((_, tyls, _)) -> 
    let c = String.concat " * " (List.concat (List.map (function Left x -> [str_of_ty x] | Right _ -> []) tyls)) in
    spf "(%s)" c;
  | TyFunction((_,_,_)) -> 
    failwith "function";
  | TyApp((args, name)) -> 
    spf "%s %s" 
       (str_of_tyargs args) 
       (str_of_longname name);
  | _ -> failwith "other ty";;


let str_of_param params =
  match params with
    | TyNoParam -> 
      "";
    | TyParam1(par) -> 
      (match par with
	| (_, Name((name, _))) -> 
	  (spf "'%s" name);)
    | TyParamMulti(par, _, _) -> 
      failwith "some params!";;

let str_of_constr_decl = 
  function (n, args) -> 
    match args with
      | NoConstrArg -> str_of_name n
      | Of (_, tyls) -> 
	let c = String.concat " * " (List.concat (List.map (function Left x -> [str_of_ty x] | Right _ -> []) tyls)) in
	spf "%s of %s" (str_of_name n) c;;

let str_of_kind k =
  let str_of_algebraic ls =
    let c = String.concat "\n\t| " (List.concat (List.map (function Left x -> [str_of_constr_decl x] | Right _ -> []) ls)) in
    spf "\n\t| %s" c;
    
  in 
  match k with
    | TyCore(t) -> 
      spf "%s" (str_of_ty t);
    | TyAlgebric(a) ->
      spf "%s" (str_of_algebraic a);
    | TyRecord((_, r, _)) -> 
      let c = String.concat ";\n\t"
	(List.concat 
	   (List.map 
	      (function Left x -> [spf "%s : %s" 
				      (str_of_name x.fld_name) 
				      (str_of_ty x.fld_type)] | Right _ -> []) r)) in
      spf "{\n\t%s\n}" c;;

let str_of_type d =
  match d with
    | TyDef(params, name, _, kind) -> 
      (match params with 
	| TyNoParam -> 
	  pr2 (spf "type %s = %s" (str_of_name name) (str_of_kind kind));
	| TyParam1 _ ->
	  pr2 (spf "type %s %s = %s" (str_of_param params) (str_of_name name) (str_of_kind kind));
	| _ -> failwith "type with more than 1 param!";)
    | _ -> failwith "abstract!";;

let ast = Parse.parse_program "/home/user/pfff/lang_php/parsing/ast_php.ml" in
let visitor = V.mk_visitor {
  V.default_visitor with
    V.ktype_declaration = (fun (k, _) d ->
      str_of_type d;
      k d);
(*    V.kty = (fun (k, _) d ->
      pr2 "a ty!";
      k d); *)
} in
visitor (Ast.Program ast);;
