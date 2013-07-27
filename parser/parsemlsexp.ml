
open Common;;
open Ocaml;;
open Ast_ml;;
module Ast = Ast_ml;;
module Parse = Parse_ml;;
module V = Visitor_ml;;

type 'a dummyDict = (string * 'a) list;;


let keyexists (ls : 'a dummyDict) (key : string) = 
  List.exists (fun (item, _) -> item = key) ls;;

let add (ls : 'a dummyDict) (key : string) (value : 'a) =
  if keyexists ls key then
    ls
  else
    (key, value) :: ls;;



let c = open_out "stmp.ml";;
let pr2 x = 
  output_string c x;;
let pr2n x = 
  pr2 (x^"\n");;

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
  | _ -> failwith "str_of_ty missing something";;

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

(* ******************************** *)

let map_of_either_list (all : ('a, Ast.tok) Common.either list) (funcy : 'a -> 'b)  =
  let ret = ref [] in
  List.iter (function Left elem -> ret := (funcy elem) :: !ret | Right _ -> ()) all;
  !ret;;

let sexp_of_either_list (all : ('a, Ast.tok) Common.either list) (funcy : 'a -> unit) =
  List.iter (function Left elem -> funcy elem | Right _ -> ()) all;;

let sexp_of_ty _t = 
  "t";  in

let fun_str_of_param params =
  match params with
    | TyNoParam -> 
      "";
    | TyParam1(par) -> 
      (match par with
	| (_, Name((name, _))) -> 
	  (spf "_%s" name);)
    | TyParamMulti(par, _, _) -> 
      failwith "some params!"
in

let rec fun_str_of_ty ty =
  match ty with
  | TyName(longname) -> 
    fun_str_of_longname longname;
  | TyVar((_, name)) -> 
    spf "%s" (str_of_name name);
(*  | TyFunction((_,_,_)) -> 
    failwith "function"; *)
  | TyTuple(tyls) ->     
    let c = String.concat "_T_" (List.concat (List.map (function Left x -> [fun_str_of_ty x] | Right _ -> []) tyls)) in
    spf "%s" c;
  | TyTuple2((_, tyls, _)) -> 
    let c = String.concat "_T_" (List.concat (List.map (function Left x -> [fun_str_of_ty x] | Right _ -> []) tyls)) in
    spf "_P_%s_P_" c; 
  | TyApp((args, name)) -> 
    spf "%s_%s" 
       (fun_str_of_tyargs args) 
       (fun_str_of_longname name);
  | _ -> failwith "other ty";
and fun_str_of_longname longname =
    match longname with
      | (qualifiers, name) ->
	String.concat "_"
	  (List.concat [(List.map (function (n1, _) -> str_of_name n1) qualifiers);
			[str_of_name name]])
and fun_str_of_tyargs args =
    (match args with
      | TyArg1 t -> fun_str_of_ty t;
      | TyArgMulti tyls ->
	let (_, tyls, _) = tyls in
	let c = String.concat "_M_" 
	  (List.concat 
	     (List.map 
		(function Left x -> [fun_str_of_ty x] | Right _ -> []) tyls)) in
	spf "_A_%s_A_" c);
  
in

let alllists = ref [] in
let alldefs = ref [] in

let matcher_for_args ls =
  let i = ref (-1) in
  let rec this_matcher ls =
    (let rec f x = 
       (match x with	 
	 | TyName _ | TyApp _ ->
	   i := !i + 1;
	   spf "t%d" !i;
	 | TyTuple(ls) ->
	    String.concat "," (List.rev (map_of_either_list ls f));
	  | TyTuple2(_, ls, _) ->
	    spf "(%s)" (String.concat "," (List.rev (map_of_either_list ls f)));
	  | _ -> failwith "matcher for args missing something";
       ) in
     let ls = List.rev (map_of_either_list ls f) in
     match ls with
       | [] -> failwith "wtf? empty ls???";
       | [a] -> a;
       | _ -> 
	 spf "(%s)" (String.concat ", " ls))
  in
  this_matcher ls;
in

let k a = (fun _ -> a);
in

let with_output_string dummy = 
  (let s = ref "" in
  let pr2 x = 
    s := !s^x;
    (); in
  let pr2n x = pr2 (x^"\n") in
  dummy pr2 pr2n;
  !s;) in

let matcher_for_values ls _constrname =
  let i = ref (-1) in
  let rec this_matcher ls =
    (let rec f x = 
       (match x with
	 | TyApp (args, (_, Name("list", _))) ->

	   let stargs = fun_str_of_tyargs args
	   in
	   let name = spf "sexp_of_%s" (fun_str_of_ty x)
	   in 
	   alllists := add !alllists 
	     name (stargs);
	   
	   (*
	   alldefs := (with_output_string (fun pr2 pr2n ->
	     print_string "hello!!!\n";
	     pr2n (spf "%s x = \"%s\"; " name name))) :: !alldefs;
	   *)

	   i := !i + 1;
	   spf "(%s t%d)" name !i;
	   
	  | TyName _ | TyApp _ ->
	    i := !i + 1;
	    spf "(sexp_of_%s t%d)" (fun_str_of_ty x) !i;
	  | TyTuple(ls) | TyTuple2(_, ls, _) ->
	    let stringers = (List.rev (map_of_either_list ls f)) in
	    let fmt = List.map (k "%s") stringers in
	    spf "(spf \"%s\" %s)" (String.concat "," fmt) 
	      (String.concat " " stringers);
	  | _ -> failwith "matcher for args missing something";
       ) in
     let ls = List.rev (map_of_either_list ls f) in
     match ls with
       | [] -> failwith "wtf? empty ls???";
       | [a] -> a;
       | _ -> 
	 spf "(spf \"%s\" %s)" 
	   (String.concat ", " (List.map (k "%s") ls)) 
	   (String.concat " " ls))
  in
  this_matcher ls;
in
(*
let matcher_for_values ls =
  let i = ref (-1) in
  let f = (fun x ->
    i := !i + 1;    
    spf "(sexp_of_%s t%d)" (fun_str_of_ty x) !i
  ) in
  let ls = List.rev (map_of_either_list ls f) in
  let fmt = spf "(%s)" (String.concat "," (List.map (k "%s") ls)) in
  spf "spf \"%s\" %s" fmt (String.concat " " ls);
  
in
*)
let sexp_of d = match d with
  | TyDef(params, name, _, TyAlgebric(opts)) ->
    alldefs := (with_output_string (fun pr2 pr2n -> 
      let typename = (str_of_name name) in
      (* header of the function *)
      pr2n (spf " sexp_of_%s (x : Ast.%s) = " typename typename);
      pr2n "\tmatch x with";
      (* lets match against all constructors *)
      sexp_of_either_list opts (fun (name, args) -> 
	let constrname = str_of_name name in
	match args with
	  | NoConstrArg -> 
	    pr2n (spf "\t| %s -> \"%s\"; " constrname constrname); 
	  | Of(_, tyls) ->
	    (* let lsts = map_of_either_list tyls sexp_of_ty in
	       String.concat ", " lsts in *)
	    let concated = matcher_for_args tyls in
	    let concated2 = matcher_for_values tyls constrname in
	    pr2n (spf "\t| %s %s -> spf \"%s %%s\" (%s);" 
		    constrname concated 
		    constrname concated2);
      );  
      pr2n ";";)) :: !alldefs;
    ();
  | TyDef(TyNoParam, name, _, TyCore(ty)) ->

    alldefs := (spf " sexp_of_%s _x = \"%s\";" 
		  (str_of_name name) 
		  (fun_str_of_ty ty)) :: !alldefs;
    ();
  | _ -> (); in

(* ******************************** *)

let visitor = V.mk_visitor {
  V.default_visitor with 
    V.ktype_declaration = (fun (k, _) d ->      
      sexp_of d;
    k d);
} in
pr2n "(* ************************************* *)";
pr2n "(* This file was generated automagically *)";
pr2n "(* ************************************* *)";
pr2n "";
pr2n "open Common;;";
pr2n "open Ast_php;;";
pr2n "open Stmpbase;;";
pr2n "module Ast = Ast_php;;";
pr2n "";
let ast = Parse.parse_program "/home/user/pfff/lang_php/parsing/ast_php.ml" in
visitor (Ast.Program ast);
(*
print_string (spf "%d\n" (List.length !alldefs));
print_string "HI!\n";
*)
(* let alldefs = List.rev !alldefs in *)

let alldefs = List.rev !alldefs in  
let alldefs = List.append (List.map (fun (x, (c)) -> 
  spf " %s x = (spf \"[%%s]\" (String.concat \", \" (List.map (fun x -> sexp_of_%s x) x))); " x c) !alllists) alldefs
in
pr2 "let rec ";
pr2 (String.concat "\n\tand " alldefs);

(*let alllists = List.rev !alllists in
List.iter (fun (x, _) -> 
  print_string (x^"\n");) alllists;
*)


(*
List.iter (fun x ->
  pr2n x;
) (List.rev !alldefs);;

*)
