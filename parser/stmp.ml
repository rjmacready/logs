(* ************************************* *)
(* This file was generated automagically *)
(* ************************************* *)

open Common;;
open Ast_php;;
open Stmpbase;;
module Ast = Ast_php;;

let rec  sexp_of_string_wrap x = "(:nec string wrap)"; 

	and  sexp_of_xhp_tag_wrap x = "(:nec xhp_tag wrap)"; 

	and  sexp_of_type_args_option x = "(:nec type_args option)"; 

	and  sexp_of_hint_type_comma_list_paren x = "(:nec hint_type comma_list paren)"; 

	and  sexp_of__A_tok_T__P_hint_type_comma_list_dots_paren_P__T__A_tok_T_hint_type_A__option_A__paren x = "(:nec (tok * (hint_type comma_list_dots paren) * (tok * hint_type) option) paren)"; 

	and  sexp_of_Scope_php_phpscope_ref x = "(:nec Scope_php.phpscope ref)"; 

	and  sexp_of_argument_comma_list_paren x = "(:nec argument comma_list paren)"; 

	and  sexp_of_expr_option_bracket x = "(:nec expr option bracket)"; 

	and  sexp_of_expr_brace x = "(:nec expr brace)"; 

	and  sexp_of_binaryOp_wrap x = "(:nec binaryOp wrap)"; 

	and  sexp_of_unaryOp_wrap x = "(:nec unaryOp wrap)"; 

	and  sexp_of_assignOp_wrap x = "(:nec assignOp wrap)"; 

	and  sexp_of_fixOp_wrap x = "(:nec fixOp wrap)"; 

	and  sexp_of_expr_option x = "(:nec expr option)"; 

	and  sexp_of_list_assign_comma_list_paren x = "(:nec list_assign comma_list paren)"; 

	and  sexp_of_array_pair_comma_list_paren x = "(:nec array_pair comma_list paren)"; 

	and  sexp_of_array_pair_comma_list_bracket x = "(:nec array_pair comma_list bracket)"; 

	and  sexp_of_array_pair_comma_list_brace x = "(:nec array_pair comma_list brace)"; 

	and  sexp_of_argument_comma_list_paren_option x = "(:nec argument comma_list paren option)"; 

	and  sexp_of_castOp_wrap x = "(:nec castOp wrap)"; 

	and  sexp_of_expr_paren x = "(:nec expr paren)"; 

	and  sexp_of__A_expr_option_paren_A__option x = "(:nec (expr option paren) option)"; 

	and  sexp_of_lvalue_paren x = "(:nec lvalue paren)"; 

	and  sexp_of_lvalue_comma_list_paren x = "(:nec lvalue comma_list paren)"; 

	and  sexp_of_cpp_directive_wrap x = "(:nec cpp_directive wrap)"; 

	and  sexp_of_xhp_tag_option_wrap x = "(:nec xhp_tag option wrap)"; 

	and  sexp_of_stmt_and_def_list_brace x = "(:nec stmt_and_def list brace)"; 

	and  sexp_of_if_else_option x = "(:nec if_else option)"; 

	and  sexp_of_new_else_option x = "(:nec new_else option)"; 

	and  sexp_of_foreach_arrow_option x = "(:nec foreach_arrow option)"; 

	and  sexp_of_expr_comma_list x = "(:nec expr comma_list)"; 

	and  sexp_of_global_var_comma_list x = "(:nec global_var comma_list)"; 

	and  sexp_of_static_var_comma_list x = "(:nec static_var comma_list)"; 

	and  sexp_of_declare_comma_list_paren x = "(:nec declare comma_list paren)"; 

	and  sexp_of__A_tok_T_expr_A__option x = "(:nec (tok * expr) option)"; 

	and  sexp_of_tok_option x = "(:nec tok option)"; 

	and  sexp_of_string_wrap_paren x = "(:nec string wrap paren)"; 

	and  sexp_of__A_tok_T_hint_type_A__option x = "(:nec (tok * hint_type) option)"; 

	and  sexp_of_parameter_comma_list_dots_paren x = "(:nec parameter comma_list_dots paren)"; 

	and  sexp_of_type_params_option x = "(:nec type_params option)"; 

	and  sexp_of_attributes_option x = "(:nec attributes option)"; 

	and  sexp_of_static_scalar_affect_option x = "(:nec static_scalar_affect option)"; 

	and  sexp_of_hint_type_option x = "(:nec hint_type option)"; 

	and  sexp_of_modifier_wrap_option x = "(:nec modifier wrap option)"; 

	and  sexp_of_tok_T_tok_T_tok x = "(:nec tok * tok * tok)"; 

	and  sexp_of_class_stmt_list_brace x = "(:nec class_stmt list brace)"; 

	and  sexp_of_interface_option x = "(:nec interface option)"; 

	and  sexp_of_extend_option x = "(:nec extend option)"; 

	and  sexp_of_class_constant_comma_list x = "(:nec class_constant comma_list)"; 

	and  sexp_of_class_variable_comma_list x = "(:nec class_variable comma_list)"; 

	and  sexp_of_class_name_comma_list x = "(:nec class_name comma_list)"; 

	and  sexp_of__A_tok_M_trait_rule_list_brace_A__Common_either x = "(:nec (tok, trait_rule list brace) Common.either)"; 

	and  sexp_of_xhp_attribute_decl_comma_list x = "(:nec xhp_attribute_decl comma_list)"; 

	and  sexp_of_xhp_category_decl_comma_list x = "(:nec xhp_category_decl comma_list)"; 

	and  sexp_of_xhp_value_affect_option x = "(:nec xhp_value_affect option)"; 

	and  sexp_of_constant_comma_list_brace x = "(:nec constant comma_list brace)"; 

	and  sexp_of_xhp_children_decl_paren x = "(:nec xhp_children_decl paren)"; 

	and  sexp_of__A_ident_M_name_T_tok_T_ident_A__Common_either x = "(:nec (ident, name * tok * ident) Common.either)"; 

	and  sexp_of_ident_option x = "(:nec ident option)"; 

	and  sexp_of_static_scalar_comma_list_paren x = "(:nec static_scalar comma_list paren)"; 

	and  sexp_of_qualified_ident_option x = "(:nec qualified_ident option)"; 

	and  sexp_of_toplevel_list_brace x = "(:nec toplevel list brace)"; 

	and  sexp_of_argument_comma_list x = "(:nec argument comma_list)"; 

	and  sexp_of_modifier_list x = (spf "[%s]" (String.concat ", " (List.map (fun x -> sexp_of_modifier x) x))); 
	and  sexp_of_tok_list x = (spf "[%s]" (String.concat ", " (List.map (fun x -> sexp_of_tok x) x))); 
	and  sexp_of_stmt_list x = (spf "[%s]" (String.concat ", " (List.map (fun x -> sexp_of_stmt x) x))); 
	and  sexp_of_modifier_wrap_list x = (spf "[%s]" (String.concat ", " (List.map (fun x -> sexp_of_modifier_wrap x) x))); 
	and  sexp_of_case_list x = (spf "[%s]" (String.concat ", " (List.map (fun x -> sexp_of_case x) x))); 
	and  sexp_of_catch_list x = (spf "[%s]" (String.concat ", " (List.map (fun x -> sexp_of_catch x) x))); 
	and  sexp_of_new_elseif_list x = (spf "[%s]" (String.concat ", " (List.map (fun x -> sexp_of_new_elseif x) x))); 
	and  sexp_of_stmt_and_def_list x = (spf "[%s]" (String.concat ", " (List.map (fun x -> sexp_of_stmt_and_def x) x))); 
	and  sexp_of_if_elseif_list x = (spf "[%s]" (String.concat ", " (List.map (fun x -> sexp_of_if_elseif x) x))); 
	and  sexp_of_xhp_body_list x = (spf "[%s]" (String.concat ", " (List.map (fun x -> sexp_of_xhp_body x) x))); 
	and  sexp_of_xhp_attribute_list x = (spf "[%s]" (String.concat ", " (List.map (fun x -> sexp_of_xhp_attribute x) x))); 
	and  sexp_of_class_stmt_list x = (spf "[%s]" (String.concat ", " (List.map (fun x -> sexp_of_class_stmt x) x))); 
	and  sexp_of_encaps_list x = (spf "[%s]" (String.concat ", " (List.map (fun x -> sexp_of_encaps x) x))); 
	and  sexp_of_tok _x = "Parse_info_info";
	and  sexp_of_info _x = "tok";
	and  sexp_of_ident (x : Ast.ident) = 
	match x with
	| Name t0 -> spf "Name %s" ((sexp_of_string_wrap t0));
	| XhpName t0 -> spf "XhpName %s" ((sexp_of_xhp_tag_wrap t0));
;

	and  sexp_of_xhp_tag _x = "string_list";
	and  sexp_of_dname (x : Ast.dname) = 
	match x with
	| DName t0 -> spf "DName %s" ((sexp_of_string_wrap t0));
;

	and  sexp_of_qualified_ident _x = "qualified_ident_element_list";
	and  sexp_of_qualified_ident_element (x : Ast.qualified_ident_element) = 
	match x with
	| QI t0 -> spf "QI %s" ((sexp_of_ident t0));
	| QITok t0 -> spf "QITok %s" ((sexp_of_tok t0));
;

	and  sexp_of_name (x : Ast.name) = 
	match x with
	| XName t0 -> spf "XName %s" ((sexp_of_qualified_ident t0));
	| Self t0 -> spf "Self %s" ((sexp_of_tok t0));
	| Parent t0 -> spf "Parent %s" ((sexp_of_tok t0));
	| LateStatic t0 -> spf "LateStatic %s" ((sexp_of_tok t0));
;

	and  sexp_of_hint_type (x : Ast.hint_type) = 
	match x with
	| Hint (t0, t1) -> spf "Hint %s" ((spf "%s, %s" (sexp_of_name t0) (sexp_of_type_args_option t1)));
	| HintArray t0 -> spf "HintArray %s" ((sexp_of_tok t0));
	| HintQuestion (t0,t1) -> spf "HintQuestion %s" ((spf "%s" (spf "%s,%s" (sexp_of_tok t0) (sexp_of_hint_type t1))));
	| HintTuple t0 -> spf "HintTuple %s" ((sexp_of_hint_type_comma_list_paren t0));
	| HintCallback t0 -> spf "HintCallback %s" ((sexp_of__A_tok_T__P_hint_type_comma_list_dots_paren_P__T__A_tok_T_hint_type_A__option_A__paren t0));
;

	and  sexp_of_type_args _x = "hint_type_comma_list_single_angle";
	and  sexp_of_type_params _x = "type_param_comma_list_single_angle";
	and  sexp_of_type_param (x : Ast.type_param) = 
	match x with
	| TParam t0 -> spf "TParam %s" ((sexp_of_ident t0));
	| TParamConstraint (t0, t1, t2) -> spf "TParamConstraint %s" ((spf "%s, %s, %s" (sexp_of_ident t0) (sexp_of_tok t1) (sexp_of_class_name t2)));
;

	and  sexp_of_class_name _x = "hint_type";
	and  sexp_of_ptype (x : Ast.ptype) = 
	match x with
	| BoolTy -> "BoolTy"; 
	| IntTy -> "IntTy"; 
	| DoubleTy -> "DoubleTy"; 
	| StringTy -> "StringTy"; 
	| ArrayTy -> "ArrayTy"; 
	| ObjectTy -> "ObjectTy"; 
;

	and  sexp_of_expr (x : Ast.expr) = 
	match x with
	| Id t0 -> spf "Id %s" ((sexp_of_name t0));
	| IdVar (t0, t1) -> spf "IdVar %s" ((spf "%s, %s" (sexp_of_dname t0) (sexp_of_Scope_php_phpscope_ref t1)));
	| This t0 -> spf "This %s" ((sexp_of_tok t0));
	| Call (t0, t1) -> spf "Call %s" ((spf "%s, %s" (sexp_of_expr t0) (sexp_of_argument_comma_list_paren t1)));
	| ObjGet (t0, t1, t2) -> spf "ObjGet %s" ((spf "%s, %s, %s" (sexp_of_expr t0) (sexp_of_tok t1) (sexp_of_expr t2)));
	| ClassGet (t0, t1, t2) -> spf "ClassGet %s" ((spf "%s, %s, %s" (sexp_of_class_name_reference t0) (sexp_of_tok t1) (sexp_of_expr t2)));
	| ArrayGet (t0, t1) -> spf "ArrayGet %s" ((spf "%s, %s" (sexp_of_expr t0) (sexp_of_expr_option_bracket t1)));
	| HashGet (t0, t1) -> spf "HashGet %s" ((spf "%s, %s" (sexp_of_expr t0) (sexp_of_expr_brace t1)));
	| BraceIdent t0 -> spf "BraceIdent %s" ((sexp_of_expr_brace t0));
	| Deref (t0, t1) -> spf "Deref %s" ((spf "%s, %s" (sexp_of_tok t0) (sexp_of_expr t1)));
	| Sc t0 -> spf "Sc %s" ((sexp_of_scalar t0));
	| Binary (t0, t1, t2) -> spf "Binary %s" ((spf "%s, %s, %s" (sexp_of_expr t0) (sexp_of_binaryOp_wrap t1) (sexp_of_expr t2)));
	| Unary (t0, t1) -> spf "Unary %s" ((spf "%s, %s" (sexp_of_unaryOp_wrap t0) (sexp_of_expr t1)));
	| Assign (t0, t1, t2) -> spf "Assign %s" ((spf "%s, %s, %s" (sexp_of_lvalue t0) (sexp_of_tok t1) (sexp_of_expr t2)));
	| AssignOp (t0, t1, t2) -> spf "AssignOp %s" ((spf "%s, %s, %s" (sexp_of_lvalue t0) (sexp_of_assignOp_wrap t1) (sexp_of_expr t2)));
	| Postfix (t0, t1) -> spf "Postfix %s" ((spf "%s, %s" (sexp_of_rw_variable t0) (sexp_of_fixOp_wrap t1)));
	| Infix (t0, t1) -> spf "Infix %s" ((spf "%s, %s" (sexp_of_fixOp_wrap t0) (sexp_of_rw_variable t1)));
	| CondExpr (t0, t1, t2, t3, t4) -> spf "CondExpr %s" ((spf "%s, %s, %s, %s, %s" (sexp_of_expr t0) (sexp_of_tok t1) (sexp_of_expr_option t2) (sexp_of_tok t3) (sexp_of_expr t4)));
	| AssignList (t0, t1, t2, t3) -> spf "AssignList %s" ((spf "%s, %s, %s, %s" (sexp_of_tok t0) (sexp_of_list_assign_comma_list_paren t1) (sexp_of_tok t2) (sexp_of_expr t3)));
	| ArrayLong (t0, t1) -> spf "ArrayLong %s" ((spf "%s, %s" (sexp_of_tok t0) (sexp_of_array_pair_comma_list_paren t1)));
	| ArrayShort t0 -> spf "ArrayShort %s" ((sexp_of_array_pair_comma_list_bracket t0));
	| Collection (t0, t1) -> spf "Collection %s" ((spf "%s, %s" (sexp_of_name t0) (sexp_of_array_pair_comma_list_brace t1)));
	| New (t0, t1, t2) -> spf "New %s" ((spf "%s, %s, %s" (sexp_of_tok t0) (sexp_of_class_name_reference t1) (sexp_of_argument_comma_list_paren_option t2)));
	| Clone (t0, t1) -> spf "Clone %s" ((spf "%s, %s" (sexp_of_tok t0) (sexp_of_expr t1)));
	| AssignRef (t0, t1, t2, t3) -> spf "AssignRef %s" ((spf "%s, %s, %s, %s" (sexp_of_lvalue t0) (sexp_of_tok t1) (sexp_of_tok t2) (sexp_of_lvalue t3)));
	| AssignNew (t0, t1, t2, t3, t4, t5) -> spf "AssignNew %s" ((spf "%s, %s, %s, %s, %s, %s" (sexp_of_lvalue t0) (sexp_of_tok t1) (sexp_of_tok t2) (sexp_of_tok t3) (sexp_of_class_name_reference t4) (sexp_of_argument_comma_list_paren_option t5)));
	| Cast (t0, t1) -> spf "Cast %s" ((spf "%s, %s" (sexp_of_castOp_wrap t0) (sexp_of_expr t1)));
	| CastUnset (t0, t1) -> spf "CastUnset %s" ((spf "%s, %s" (sexp_of_tok t0) (sexp_of_expr t1)));
	| InstanceOf (t0, t1, t2) -> spf "InstanceOf %s" ((spf "%s, %s, %s" (sexp_of_expr t0) (sexp_of_tok t1) (sexp_of_class_name_reference t2)));
	| Eval (t0, t1) -> spf "Eval %s" ((spf "%s, %s" (sexp_of_tok t0) (sexp_of_expr_paren t1)));
	| Lambda t0 -> spf "Lambda %s" ((sexp_of_lambda_def t0));
	| Exit (t0, t1) -> spf "Exit %s" ((spf "%s, %s" (sexp_of_tok t0) (sexp_of__A_expr_option_paren_A__option t1)));
	| At (t0, t1) -> spf "At %s" ((spf "%s, %s" (sexp_of_tok t0) (sexp_of_expr t1)));
	| Print (t0, t1) -> spf "Print %s" ((spf "%s, %s" (sexp_of_tok t0) (sexp_of_expr t1)));
	| BackQuote (t0, t1, t2) -> spf "BackQuote %s" ((spf "%s, %s, %s" (sexp_of_tok t0) (sexp_of_encaps_list t1) (sexp_of_tok t2)));
	| Include (t0, t1) -> spf "Include %s" ((spf "%s, %s" (sexp_of_tok t0) (sexp_of_expr t1)));
	| IncludeOnce (t0, t1) -> spf "IncludeOnce %s" ((spf "%s, %s" (sexp_of_tok t0) (sexp_of_expr t1)));
	| Require (t0, t1) -> spf "Require %s" ((spf "%s, %s" (sexp_of_tok t0) (sexp_of_expr t1)));
	| RequireOnce (t0, t1) -> spf "RequireOnce %s" ((spf "%s, %s" (sexp_of_tok t0) (sexp_of_expr t1)));
	| Empty (t0, t1) -> spf "Empty %s" ((spf "%s, %s" (sexp_of_tok t0) (sexp_of_lvalue_paren t1)));
	| Isset (t0, t1) -> spf "Isset %s" ((spf "%s, %s" (sexp_of_tok t0) (sexp_of_lvalue_comma_list_paren t1)));
	| XhpHtml t0 -> spf "XhpHtml %s" ((sexp_of_xhp_html t0));
	| Yield (t0, t1) -> spf "Yield %s" ((spf "%s, %s" (sexp_of_tok t0) (sexp_of_expr t1)));
	| YieldBreak (t0, t1) -> spf "YieldBreak %s" ((spf "%s, %s" (sexp_of_tok t0) (sexp_of_tok t1)));
	| SgrepExprDots t0 -> spf "SgrepExprDots %s" ((sexp_of_tok t0));
	| ParenExpr t0 -> spf "ParenExpr %s" ((sexp_of_expr_paren t0));
;

	and  sexp_of_scalar (x : Ast.scalar) = 
	match x with
	| C t0 -> spf "C %s" ((sexp_of_constant t0));
	| Guil (t0, t1, t2) -> spf "Guil %s" ((spf "%s, %s, %s" (sexp_of_tok t0) (sexp_of_encaps_list t1) (sexp_of_tok t2)));
	| HereDoc (t0, t1, t2) -> spf "HereDoc %s" ((spf "%s, %s, %s" (sexp_of_tok t0) (sexp_of_encaps_list t1) (sexp_of_tok t2)));
;

	and  sexp_of_constant (x : Ast.constant) = 
	match x with
	| Int t0 -> spf "Int %s" ((sexp_of_string_wrap t0));
	| Double t0 -> spf "Double %s" ((sexp_of_string_wrap t0));
	| String t0 -> spf "String %s" ((sexp_of_string_wrap t0));
	| PreProcess t0 -> spf "PreProcess %s" ((sexp_of_cpp_directive_wrap t0));
	| XdebugClass (t0, t1) -> spf "XdebugClass %s" ((spf "%s, %s" (sexp_of_name t0) (sexp_of_class_stmt_list t1)));
	| XdebugResource -> "XdebugResource"; 
;

	and  sexp_of_cpp_directive (x : Ast.cpp_directive) = 
	match x with
	| Line -> "Line"; 
	| File -> "File"; 
	| Dir -> "Dir"; 
	| ClassC -> "ClassC"; 
	| TraitC -> "TraitC"; 
	| MethodC -> "MethodC"; 
	| FunctionC -> "FunctionC"; 
	| NamespaceC -> "NamespaceC"; 
;

	and  sexp_of_encaps (x : Ast.encaps) = 
	match x with
	| EncapsString t0 -> spf "EncapsString %s" ((sexp_of_string_wrap t0));
	| EncapsVar t0 -> spf "EncapsVar %s" ((sexp_of_lvalue t0));
	| EncapsCurly (t0, t1, t2) -> spf "EncapsCurly %s" ((spf "%s, %s, %s" (sexp_of_tok t0) (sexp_of_lvalue t1) (sexp_of_tok t2)));
	| EncapsDollarCurly (t0, t1, t2) -> spf "EncapsDollarCurly %s" ((spf "%s, %s, %s" (sexp_of_tok t0) (sexp_of_lvalue t1) (sexp_of_tok t2)));
	| EncapsExpr (t0, t1, t2) -> spf "EncapsExpr %s" ((spf "%s, %s, %s" (sexp_of_tok t0) (sexp_of_expr t1) (sexp_of_tok t2)));
;

	and  sexp_of_fixOp (x : Ast.fixOp) = 
	match x with
	| Dec -> "Dec"; 
	| Inc -> "Inc"; 
;

	and  sexp_of_binaryOp (x : Ast.binaryOp) = 
	match x with
	| Arith t0 -> spf "Arith %s" ((sexp_of_arithOp t0));
	| Logical t0 -> spf "Logical %s" ((sexp_of_logicalOp t0));
	| BinaryConcat -> "BinaryConcat"; 
;

	and  sexp_of_arithOp (x : Ast.arithOp) = 
	match x with
	| Plus -> "Plus"; 
	| Minus -> "Minus"; 
	| Mul -> "Mul"; 
	| Div -> "Div"; 
	| Mod -> "Mod"; 
	| DecLeft -> "DecLeft"; 
	| DecRight -> "DecRight"; 
	| And -> "And"; 
	| Or -> "Or"; 
	| Xor -> "Xor"; 
;

	and  sexp_of_logicalOp (x : Ast.logicalOp) = 
	match x with
	| Inf -> "Inf"; 
	| Sup -> "Sup"; 
	| InfEq -> "InfEq"; 
	| SupEq -> "SupEq"; 
	| Eq -> "Eq"; 
	| NotEq -> "NotEq"; 
	| Identical -> "Identical"; 
	| NotIdentical -> "NotIdentical"; 
	| AndLog -> "AndLog"; 
	| OrLog -> "OrLog"; 
	| XorLog -> "XorLog"; 
	| AndBool -> "AndBool"; 
	| OrBool -> "OrBool"; 
;

	and  sexp_of_assignOp (x : Ast.assignOp) = 
	match x with
	| AssignOpArith t0 -> spf "AssignOpArith %s" ((sexp_of_arithOp t0));
	| AssignConcat -> "AssignConcat"; 
;

	and  sexp_of_unaryOp (x : Ast.unaryOp) = 
	match x with
	| UnPlus -> "UnPlus"; 
	| UnMinus -> "UnMinus"; 
	| UnBang -> "UnBang"; 
	| UnTilde -> "UnTilde"; 
;

	and  sexp_of_castOp _x = "ptype";
	and  sexp_of_list_assign (x : Ast.list_assign) = 
	match x with
	| ListVar t0 -> spf "ListVar %s" ((sexp_of_lvalue t0));
	| ListList (t0, t1) -> spf "ListList %s" ((spf "%s, %s" (sexp_of_tok t0) (sexp_of_list_assign_comma_list_paren t1)));
	| ListEmpty -> "ListEmpty"; 
;

	and  sexp_of_array_pair (x : Ast.array_pair) = 
	match x with
	| ArrayExpr t0 -> spf "ArrayExpr %s" ((sexp_of_expr t0));
	| ArrayRef (t0, t1) -> spf "ArrayRef %s" ((spf "%s, %s" (sexp_of_tok t0) (sexp_of_lvalue t1)));
	| ArrayArrowExpr (t0, t1, t2) -> spf "ArrayArrowExpr %s" ((spf "%s, %s, %s" (sexp_of_expr t0) (sexp_of_tok t1) (sexp_of_expr t2)));
	| ArrayArrowRef (t0, t1, t2, t3) -> spf "ArrayArrowRef %s" ((spf "%s, %s, %s, %s" (sexp_of_expr t0) (sexp_of_tok t1) (sexp_of_tok t2) (sexp_of_lvalue t3)));
;

	and  sexp_of_vector_elt (x : Ast.vector_elt) = 
	match x with
	| VectorExpr t0 -> spf "VectorExpr %s" ((sexp_of_expr t0));
	| VectorRef (t0, t1) -> spf "VectorRef %s" ((spf "%s, %s" (sexp_of_tok t0) (sexp_of_lvalue t1)));
;

	and  sexp_of_map_elt (x : Ast.map_elt) = 
	match x with
	| MapArrowExpr (t0, t1, t2) -> spf "MapArrowExpr %s" ((spf "%s, %s, %s" (sexp_of_expr t0) (sexp_of_tok t1) (sexp_of_expr t2)));
	| MapArrowRef (t0, t1, t2, t3) -> spf "MapArrowRef %s" ((spf "%s, %s, %s, %s" (sexp_of_expr t0) (sexp_of_tok t1) (sexp_of_tok t2) (sexp_of_lvalue t3)));
;

	and  sexp_of_xhp_html (x : Ast.xhp_html) = 
	match x with
	| Xhp (t0, t1, t2, t3, t4) -> spf "Xhp %s" ((spf "%s, %s, %s, %s, %s" (sexp_of_xhp_tag_wrap t0) (sexp_of_xhp_attribute_list t1) (sexp_of_tok t2) (sexp_of_xhp_body_list t3) (sexp_of_xhp_tag_option_wrap t4)));
	| XhpSingleton (t0, t1, t2) -> spf "XhpSingleton %s" ((spf "%s, %s, %s" (sexp_of_xhp_tag_wrap t0) (sexp_of_xhp_attribute_list t1) (sexp_of_tok t2)));
;

	and  sexp_of_xhp_attribute _x = "xhp_attr_name_T_tok_T_xhp_attr_value";
	and  sexp_of_xhp_attr_name _x = "string_wrap";
	and  sexp_of_xhp_attr_value (x : Ast.xhp_attr_value) = 
	match x with
	| XhpAttrString (t0, t1, t2) -> spf "XhpAttrString %s" ((spf "%s, %s, %s" (sexp_of_tok t0) (sexp_of_encaps_list t1) (sexp_of_tok t2)));
	| XhpAttrExpr t0 -> spf "XhpAttrExpr %s" ((sexp_of_expr_brace t0));
	| SgrepXhpAttrValueMvar t0 -> spf "SgrepXhpAttrValueMvar %s" ((sexp_of_string_wrap t0));
;

	and  sexp_of_xhp_body (x : Ast.xhp_body) = 
	match x with
	| XhpText t0 -> spf "XhpText %s" ((sexp_of_string_wrap t0));
	| XhpExpr t0 -> spf "XhpExpr %s" ((sexp_of_expr_brace t0));
	| XhpNested t0 -> spf "XhpNested %s" ((sexp_of_xhp_html t0));
;

	and  sexp_of_argument (x : Ast.argument) = 
	match x with
	| Arg t0 -> spf "Arg %s" ((sexp_of_expr t0));
	| ArgRef (t0, t1) -> spf "ArgRef %s" ((spf "%s, %s" (sexp_of_tok t0) (sexp_of_w_variable t1)));
;

	and  sexp_of_lvalue _x = "expr";
	and  sexp_of_class_name_reference _x = "expr";
	and  sexp_of_rw_variable _x = "lvalue";
	and  sexp_of_r_variable _x = "lvalue";
	and  sexp_of_w_variable _x = "lvalue";
	and  sexp_of_static_scalar _x = "expr";
	and  sexp_of_stmt (x : Ast.stmt) = 
	match x with
	| ExprStmt (t0, t1) -> spf "ExprStmt %s" ((spf "%s, %s" (sexp_of_expr t0) (sexp_of_tok t1)));
	| EmptyStmt t0 -> spf "EmptyStmt %s" ((sexp_of_tok t0));
	| Block t0 -> spf "Block %s" ((sexp_of_stmt_and_def_list_brace t0));
	| If (t0, t1, t2, t3, t4) -> spf "If %s" ((spf "%s, %s, %s, %s, %s" (sexp_of_tok t0) (sexp_of_expr_paren t1) (sexp_of_stmt t2) (sexp_of_if_elseif_list t3) (sexp_of_if_else_option t4)));
	| IfColon (t0, t1, t2, t3, t4, t5, t6, t7) -> spf "IfColon %s" ((spf "%s, %s, %s, %s, %s, %s, %s, %s" (sexp_of_tok t0) (sexp_of_expr_paren t1) (sexp_of_tok t2) (sexp_of_stmt_and_def_list t3) (sexp_of_new_elseif_list t4) (sexp_of_new_else_option t5) (sexp_of_tok t6) (sexp_of_tok t7)));
	| While (t0, t1, t2) -> spf "While %s" ((spf "%s, %s, %s" (sexp_of_tok t0) (sexp_of_expr_paren t1) (sexp_of_colon_stmt t2)));
	| Do (t0, t1, t2, t3, t4) -> spf "Do %s" ((spf "%s, %s, %s, %s, %s" (sexp_of_tok t0) (sexp_of_stmt t1) (sexp_of_tok t2) (sexp_of_expr_paren t3) (sexp_of_tok t4)));
	| For (t0, t1, t2, t3, t4, t5, t6, t7, t8) -> spf "For %s" ((spf "%s, %s, %s, %s, %s, %s, %s, %s, %s" (sexp_of_tok t0) (sexp_of_tok t1) (sexp_of_for_expr t2) (sexp_of_tok t3) (sexp_of_for_expr t4) (sexp_of_tok t5) (sexp_of_for_expr t6) (sexp_of_tok t7) (sexp_of_colon_stmt t8)));
	| Switch (t0, t1, t2) -> spf "Switch %s" ((spf "%s, %s, %s" (sexp_of_tok t0) (sexp_of_expr_paren t1) (sexp_of_switch_case_list t2)));
	| Foreach (t0, t1, t2, t3, t4, t5, t6, t7) -> spf "Foreach %s" ((spf "%s, %s, %s, %s, %s, %s, %s, %s" (sexp_of_tok t0) (sexp_of_tok t1) (sexp_of_expr t2) (sexp_of_tok t3) (sexp_of_foreach_var_either t4) (sexp_of_foreach_arrow_option t5) (sexp_of_tok t6) (sexp_of_colon_stmt t7)));
	| Break (t0, t1, t2) -> spf "Break %s" ((spf "%s, %s, %s" (sexp_of_tok t0) (sexp_of_expr_option t1) (sexp_of_tok t2)));
	| Continue (t0, t1, t2) -> spf "Continue %s" ((spf "%s, %s, %s" (sexp_of_tok t0) (sexp_of_expr_option t1) (sexp_of_tok t2)));
	| Return (t0, t1, t2) -> spf "Return %s" ((spf "%s, %s, %s" (sexp_of_tok t0) (sexp_of_expr_option t1) (sexp_of_tok t2)));
	| Throw (t0, t1, t2) -> spf "Throw %s" ((spf "%s, %s, %s" (sexp_of_tok t0) (sexp_of_expr t1) (sexp_of_tok t2)));
	| Try (t0, t1, t2, t3) -> spf "Try %s" ((spf "%s, %s, %s, %s" (sexp_of_tok t0) (sexp_of_stmt_and_def_list_brace t1) (sexp_of_catch t2) (sexp_of_catch_list t3)));
	| Echo (t0, t1, t2) -> spf "Echo %s" ((spf "%s, %s, %s" (sexp_of_tok t0) (sexp_of_expr_comma_list t1) (sexp_of_tok t2)));
	| Globals (t0, t1, t2) -> spf "Globals %s" ((spf "%s, %s, %s" (sexp_of_tok t0) (sexp_of_global_var_comma_list t1) (sexp_of_tok t2)));
	| StaticVars (t0, t1, t2) -> spf "StaticVars %s" ((spf "%s, %s, %s" (sexp_of_tok t0) (sexp_of_static_var_comma_list t1) (sexp_of_tok t2)));
	| InlineHtml t0 -> spf "InlineHtml %s" ((sexp_of_string_wrap t0));
	| Use (t0, t1, t2) -> spf "Use %s" ((spf "%s, %s, %s" (sexp_of_tok t0) (sexp_of_use_filename t1) (sexp_of_tok t2)));
	| Unset (t0, t1, t2) -> spf "Unset %s" ((spf "%s, %s, %s" (sexp_of_tok t0) (sexp_of_lvalue_comma_list_paren t1) (sexp_of_tok t2)));
	| Declare (t0, t1, t2) -> spf "Declare %s" ((spf "%s, %s, %s" (sexp_of_tok t0) (sexp_of_declare_comma_list_paren t1) (sexp_of_colon_stmt t2)));
	| TypedDeclaration (t0, t1, t2, t3) -> spf "TypedDeclaration %s" ((spf "%s, %s, %s, %s" (sexp_of_hint_type t0) (sexp_of_lvalue t1) (sexp_of__A_tok_T_expr_A__option t2) (sexp_of_tok t3)));
	| FuncDefNested t0 -> spf "FuncDefNested %s" ((sexp_of_func_def t0));
	| ClassDefNested t0 -> spf "ClassDefNested %s" ((sexp_of_class_def t0));
;

	and  sexp_of_switch_case_list (x : Ast.switch_case_list) = 
	match x with
	| CaseList (t0, t1, t2, t3) -> spf "CaseList %s" ((spf "%s, %s, %s, %s" (sexp_of_tok t0) (sexp_of_tok_option t1) (sexp_of_case_list t2) (sexp_of_tok t3)));
	| CaseColonList (t0, t1, t2, t3, t4) -> spf "CaseColonList %s" ((spf "%s, %s, %s, %s, %s" (sexp_of_tok t0) (sexp_of_tok_option t1) (sexp_of_case_list t2) (sexp_of_tok t3) (sexp_of_tok t4)));
;

	and  sexp_of_case (x : Ast.case) = 
	match x with
	| Case (t0, t1, t2, t3) -> spf "Case %s" ((spf "%s, %s, %s, %s" (sexp_of_tok t0) (sexp_of_expr t1) (sexp_of_tok t2) (sexp_of_stmt_and_def_list t3)));
	| Default (t0, t1, t2) -> spf "Default %s" ((spf "%s, %s, %s" (sexp_of_tok t0) (sexp_of_tok t1) (sexp_of_stmt_and_def_list t2)));
;

	and  sexp_of_if_elseif _x = "tok_T_expr_paren_T_stmt";
	and  sexp_of_if_else _x = "_P_tok_T_stmt_P_";
	and  sexp_of_for_expr _x = "expr_comma_list";
	and  sexp_of_foreach_arrow _x = "tok_T_foreach_variable";
	and  sexp_of_foreach_variable _x = "is_ref_T_lvalue";
	and  sexp_of_foreach_var_either _x = "_A_foreach_variable_M_lvalue_A__Common_either";
	and  sexp_of_catch _x = "tok_T__A_class_name_T_dname_A__paren_T_stmt_and_def_list_brace";
	and  sexp_of_use_filename (x : Ast.use_filename) = 
	match x with
	| UseDirect t0 -> spf "UseDirect %s" ((sexp_of_string_wrap t0));
	| UseParen t0 -> spf "UseParen %s" ((sexp_of_string_wrap_paren t0));
;

	and  sexp_of_declare _x = "ident_T_static_scalar_affect";
	and  sexp_of_colon_stmt (x : Ast.colon_stmt) = 
	match x with
	| SingleStmt t0 -> spf "SingleStmt %s" ((sexp_of_stmt t0));
	| ColonStmt (t0, t1, t2, t3) -> spf "ColonStmt %s" ((spf "%s, %s, %s, %s" (sexp_of_tok t0) (sexp_of_stmt_and_def_list t1) (sexp_of_tok t2) (sexp_of_tok t3)));
;

	and  sexp_of_new_elseif _x = "tok_T_expr_paren_T_tok_T_stmt_and_def_list";
	and  sexp_of_new_else _x = "tok_T_tok_T_stmt_and_def_list";
	and  sexp_of_func_def x = spf "(:class func_def :fields (%s %s %s %s %s %s %s %s %s %s))" (sexp_of_stmt_and_def_list_brace x.f_body) (sexp_of__A_tok_T_hint_type_A__option x.f_return_type) (sexp_of_parameter_comma_list_dots_paren x.f_params) (sexp_of_type_params_option x.f_tparams) (sexp_of_ident x.f_name) (sexp_of_is_ref x.f_ref) (sexp_of_modifier_wrap_list x.f_modifiers) (sexp_of_function_type x.f_type) (sexp_of_tok x.f_tok) (sexp_of_attributes_option x.f_attrs);

	and  sexp_of_function_type (x : Ast.function_type) = 
	match x with
	| FunctionRegular -> "FunctionRegular"; 
	| FunctionLambda -> "FunctionLambda"; 
	| MethodRegular -> "MethodRegular"; 
	| MethodAbstract -> "MethodAbstract"; 
;

	and  sexp_of_parameter x = spf "(:class parameter :fields (%s %s %s %s %s %s))" (sexp_of_static_scalar_affect_option x.p_default) (sexp_of_dname x.p_name) (sexp_of_is_ref x.p_ref) (sexp_of_hint_type_option x.p_type) (sexp_of_modifier_wrap_option x.p_modifier) (sexp_of_attributes_option x.p_attrs);

	and  sexp_of_is_ref _x = "tok_option";
	and  sexp_of_lambda_def _x = "_P_lexical_vars_option_T_func_def_P_";
	and  sexp_of_lexical_vars _x = "tok_T_lexical_var_comma_list_paren";
	and  sexp_of_lexical_var (x : Ast.lexical_var) = 
	match x with
	| LexicalVar (t0, t1) -> spf "LexicalVar %s" ((spf "%s, %s" (sexp_of_is_ref t0) (sexp_of_dname t1)));
;

	and  sexp_of_constant_def x = spf "(:class constant_def :fields (%s %s %s %s))" (sexp_of_static_scalar x.cst_val) (sexp_of_hint_type_option x.cst_type) (sexp_of_ident x.cst_name) (sexp_of_tok_T_tok_T_tok x.cst_toks);

	and  sexp_of_class_def x = spf "(:class class_def :fields (%s %s %s %s %s %s %s))" (sexp_of_class_stmt_list_brace x.c_body) (sexp_of_interface_option x.c_implements) (sexp_of_extend_option x.c_extends) (sexp_of_type_params_option x.c_tparams) (sexp_of_ident x.c_name) (sexp_of_class_type x.c_type) (sexp_of_attributes_option x.c_attrs);

	and  sexp_of_class_type (x : Ast.class_type) = 
	match x with
	| ClassRegular t0 -> spf "ClassRegular %s" ((sexp_of_tok t0));
	| ClassFinal (t0, t1) -> spf "ClassFinal %s" ((spf "%s, %s" (sexp_of_tok t0) (sexp_of_tok t1)));
	| ClassAbstract (t0, t1) -> spf "ClassAbstract %s" ((spf "%s, %s" (sexp_of_tok t0) (sexp_of_tok t1)));
	| Interface t0 -> spf "Interface %s" ((sexp_of_tok t0));
	| Trait t0 -> spf "Trait %s" ((sexp_of_tok t0));
;

	and  sexp_of_extend _x = "tok_T_class_name";
	and  sexp_of_interface _x = "tok_T_class_name_comma_list";
	and  sexp_of_class_stmt (x : Ast.class_stmt) = 
	match x with
	| ClassConstants (t0, t1, t2) -> spf "ClassConstants %s" ((spf "%s, %s, %s" (sexp_of_tok t0) (sexp_of_class_constant_comma_list t1) (sexp_of_tok t2)));
	| ClassVariables (t0, t1, t2, t3) -> spf "ClassVariables %s" ((spf "%s, %s, %s, %s" (sexp_of_class_var_modifier t0) (sexp_of_hint_type_option t1) (sexp_of_class_variable_comma_list t2) (sexp_of_tok t3)));
	| Method t0 -> spf "Method %s" ((sexp_of_method_def t0));
	| XhpDecl t0 -> spf "XhpDecl %s" ((sexp_of_xhp_decl t0));
	| UseTrait (t0, t1, t2) -> spf "UseTrait %s" ((spf "%s, %s, %s" (sexp_of_tok t0) (sexp_of_class_name_comma_list t1) (sexp_of__A_tok_M_trait_rule_list_brace_A__Common_either t2)));
;

	and  sexp_of_class_constant _x = "ident_T_static_scalar_affect";
	and  sexp_of_class_variable _x = "dname_T_static_scalar_affect_option";
	and  sexp_of_class_var_modifier (x : Ast.class_var_modifier) = 
	match x with
	| NoModifiers t0 -> spf "NoModifiers %s" ((sexp_of_tok t0));
	| VModifiers t0 -> spf "VModifiers %s" ((sexp_of_modifier_wrap_list t0));
;

	and  sexp_of_method_def _x = "func_def";
	and  sexp_of_modifier (x : Ast.modifier) = 
	match x with
	| Public -> "Public"; 
	| Private -> "Private"; 
	| Protected -> "Protected"; 
	| Static -> "Static"; 
	| Abstract -> "Abstract"; 
	| Final -> "Final"; 
;

	and  sexp_of_xhp_decl (x : Ast.xhp_decl) = 
	match x with
	| XhpAttributesDecl (t0, t1, t2) -> spf "XhpAttributesDecl %s" ((spf "%s, %s, %s" (sexp_of_tok t0) (sexp_of_xhp_attribute_decl_comma_list t1) (sexp_of_tok t2)));
	| XhpChildrenDecl (t0, t1, t2) -> spf "XhpChildrenDecl %s" ((spf "%s, %s, %s" (sexp_of_tok t0) (sexp_of_xhp_children_decl t1) (sexp_of_tok t2)));
	| XhpCategoriesDecl (t0, t1, t2) -> spf "XhpCategoriesDecl %s" ((spf "%s, %s, %s" (sexp_of_tok t0) (sexp_of_xhp_category_decl_comma_list t1) (sexp_of_tok t2)));
;

	and  sexp_of_xhp_attribute_decl (x : Ast.xhp_attribute_decl) = 
	match x with
	| XhpAttrInherit t0 -> spf "XhpAttrInherit %s" ((sexp_of_xhp_tag_wrap t0));
	| XhpAttrDecl (t0, t1, t2, t3) -> spf "XhpAttrDecl %s" ((spf "%s, %s, %s, %s" (sexp_of_xhp_attribute_type t0) (sexp_of_xhp_attr_name t1) (sexp_of_xhp_value_affect_option t2) (sexp_of_tok_option t3)));
;

	and  sexp_of_xhp_attribute_type (x : Ast.xhp_attribute_type) = 
	match x with
	| XhpAttrType t0 -> spf "XhpAttrType %s" ((sexp_of_hint_type t0));
	| XhpAttrVar t0 -> spf "XhpAttrVar %s" ((sexp_of_tok t0));
	| XhpAttrEnum (t0, t1) -> spf "XhpAttrEnum %s" ((spf "%s, %s" (sexp_of_tok t0) (sexp_of_constant_comma_list_brace t1)));
;

	and  sexp_of_xhp_value_affect _x = "tok_T_static_scalar";
	and  sexp_of_xhp_children_decl (x : Ast.xhp_children_decl) = 
	match x with
	| XhpChild t0 -> spf "XhpChild %s" ((sexp_of_xhp_tag_wrap t0));
	| XhpChildCategory t0 -> spf "XhpChildCategory %s" ((sexp_of_xhp_tag_wrap t0));
	| XhpChildAny t0 -> spf "XhpChildAny %s" ((sexp_of_tok t0));
	| XhpChildEmpty t0 -> spf "XhpChildEmpty %s" ((sexp_of_tok t0));
	| XhpChildPcdata t0 -> spf "XhpChildPcdata %s" ((sexp_of_tok t0));
	| XhpChildSequence (t0, t1, t2) -> spf "XhpChildSequence %s" ((spf "%s, %s, %s" (sexp_of_xhp_children_decl t0) (sexp_of_tok t1) (sexp_of_xhp_children_decl t2)));
	| XhpChildAlternative (t0, t1, t2) -> spf "XhpChildAlternative %s" ((spf "%s, %s, %s" (sexp_of_xhp_children_decl t0) (sexp_of_tok t1) (sexp_of_xhp_children_decl t2)));
	| XhpChildMul (t0, t1) -> spf "XhpChildMul %s" ((spf "%s, %s" (sexp_of_xhp_children_decl t0) (sexp_of_tok t1)));
	| XhpChildOption (t0, t1) -> spf "XhpChildOption %s" ((spf "%s, %s" (sexp_of_xhp_children_decl t0) (sexp_of_tok t1)));
	| XhpChildPlus (t0, t1) -> spf "XhpChildPlus %s" ((spf "%s, %s" (sexp_of_xhp_children_decl t0) (sexp_of_tok t1)));
	| XhpChildParen t0 -> spf "XhpChildParen %s" ((sexp_of_xhp_children_decl_paren t0));
;

	and  sexp_of_xhp_category_decl _x = "xhp_tag_wrap";
	and  sexp_of_trait_rule (x : Ast.trait_rule) = 
	match x with
	| InsteadOf (t0, t1, t2, t3, t4, t5) -> spf "InsteadOf %s" ((spf "%s, %s, %s, %s, %s, %s" (sexp_of_name t0) (sexp_of_tok t1) (sexp_of_ident t2) (sexp_of_tok t3) (sexp_of_class_name_comma_list t4) (sexp_of_tok t5)));
	| As (t0, t1, t2, t3, t4) -> spf "As %s" ((spf "%s, %s, %s, %s, %s" (sexp_of__A_ident_M_name_T_tok_T_ident_A__Common_either t0) (sexp_of_tok t1) (sexp_of_modifier_wrap_list t2) (sexp_of_ident_option t3) (sexp_of_tok t4)));
;

	and  sexp_of_type_def x = spf "(:class type_def :fields (%s %s %s %s %s %s))" (sexp_of_tok x.t_sc) (sexp_of_type_def_kind x.t_kind) (sexp_of_tok x.t_tokeq) (sexp_of_type_params_option x.t_tparams) (sexp_of_ident x.t_name) (sexp_of_tok x.t_tok);

	and  sexp_of_type_def_kind (x : Ast.type_def_kind) = 
	match x with
	| Alias t0 -> spf "Alias %s" ((sexp_of_hint_type t0));
	| Newtype t0 -> spf "Newtype %s" ((sexp_of_hint_type t0));
;

	and  sexp_of_global_var (x : Ast.global_var) = 
	match x with
	| GlobalVar t0 -> spf "GlobalVar %s" ((sexp_of_dname t0));
	| GlobalDollar (t0, t1) -> spf "GlobalDollar %s" ((spf "%s, %s" (sexp_of_tok t0) (sexp_of_r_variable t1)));
	| GlobalDollarExpr (t0, t1) -> spf "GlobalDollarExpr %s" ((spf "%s, %s" (sexp_of_tok t0) (sexp_of_expr_brace t1)));
;

	and  sexp_of_static_var _x = "dname_T_static_scalar_affect_option";
	and  sexp_of_static_scalar_affect _x = "tok_T_static_scalar";
	and  sexp_of_stmt_and_def _x = "stmt";
	and  sexp_of_namespace_use_rule (x : Ast.namespace_use_rule) = 
	match x with
	| ImportNamespace t0 -> spf "ImportNamespace %s" ((sexp_of_qualified_ident t0));
	| AliasNamespace (t0, t1, t2) -> spf "AliasNamespace %s" ((spf "%s, %s, %s" (sexp_of_qualified_ident t0) (sexp_of_tok t1) (sexp_of_ident t2)));
;

	and  sexp_of_attribute (x : Ast.attribute) = 
	match x with
	| Attribute t0 -> spf "Attribute %s" ((sexp_of_string_wrap t0));
	| AttributeWithArgs (t0, t1) -> spf "AttributeWithArgs %s" ((spf "%s, %s" (sexp_of_string_wrap t0) (sexp_of_static_scalar_comma_list_paren t1)));
;

	and  sexp_of_attributes _x = "attribute_comma_list_angle";
	and  sexp_of_toplevel (x : Ast.toplevel) = 
	match x with
	| StmtList t0 -> spf "StmtList %s" ((sexp_of_stmt_list t0));
	| FuncDef t0 -> spf "FuncDef %s" ((sexp_of_func_def t0));
	| ClassDef t0 -> spf "ClassDef %s" ((sexp_of_class_def t0));
	| ConstantDef t0 -> spf "ConstantDef %s" ((sexp_of_constant_def t0));
	| TypeDef t0 -> spf "TypeDef %s" ((sexp_of_type_def t0));
	| NamespaceDef (t0, t1, t2) -> spf "NamespaceDef %s" ((spf "%s, %s, %s" (sexp_of_tok t0) (sexp_of_qualified_ident t1) (sexp_of_tok t2)));
	| NamespaceBracketDef (t0, t1, t2) -> spf "NamespaceBracketDef %s" ((spf "%s, %s, %s" (sexp_of_tok t0) (sexp_of_qualified_ident_option t1) (sexp_of_toplevel_list_brace t2)));
	| NamespaceUse (t0, t1, t2) -> spf "NamespaceUse %s" ((spf "%s, %s, %s" (sexp_of_tok t0) (sexp_of_namespace_use_rule t1) (sexp_of_tok t2)));
	| NotParsedCorrectly t0 -> spf "NotParsedCorrectly %s" ((sexp_of_tok_list t0));
	| FinalDef t0 -> spf "FinalDef %s" ((sexp_of_tok t0));
;

	and  sexp_of_program _x = "toplevel_list";
	and  sexp_of_entity (x : Ast.entity) = 
	match x with
	| FunctionE t0 -> spf "FunctionE %s" ((sexp_of_func_def t0));
	| ClassE t0 -> spf "ClassE %s" ((sexp_of_class_def t0));
	| ConstantE t0 -> spf "ConstantE %s" ((sexp_of_constant_def t0));
	| TypedefE t0 -> spf "TypedefE %s" ((sexp_of_type_def t0));
	| StmtListE t0 -> spf "StmtListE %s" ((sexp_of_stmt_list t0));
	| MethodE t0 -> spf "MethodE %s" ((sexp_of_method_def t0));
	| ClassConstantE t0 -> spf "ClassConstantE %s" ((sexp_of_class_constant t0));
	| ClassVariableE (t0, t1) -> spf "ClassVariableE %s" ((spf "%s, %s" (sexp_of_class_variable t0) (sexp_of_modifier_list t1)));
	| XhpAttrE t0 -> spf "XhpAttrE %s" ((sexp_of_xhp_attribute_decl t0));
	| MiscE t0 -> spf "MiscE %s" ((sexp_of_tok_list t0));
;

	and  sexp_of_any (x : Ast.any) = 
	match x with
	| Expr t0 -> spf "Expr %s" ((sexp_of_expr t0));
	| Stmt2 t0 -> spf "Stmt2 %s" ((sexp_of_stmt t0));
	| StmtAndDefs t0 -> spf "StmtAndDefs %s" ((sexp_of_stmt_and_def_list t0));
	| Toplevel t0 -> spf "Toplevel %s" ((sexp_of_toplevel t0));
	| Program t0 -> spf "Program %s" ((sexp_of_program t0));
	| Entity t0 -> spf "Entity %s" ((sexp_of_entity t0));
	| Argument t0 -> spf "Argument %s" ((sexp_of_argument t0));
	| Arguments t0 -> spf "Arguments %s" ((sexp_of_argument_comma_list t0));
	| Parameter t0 -> spf "Parameter %s" ((sexp_of_parameter t0));
	| Parameters t0 -> spf "Parameters %s" ((sexp_of_parameter_comma_list_dots_paren t0));
	| Body t0 -> spf "Body %s" ((sexp_of_stmt_and_def_list_brace t0));
	| ClassStmt t0 -> spf "ClassStmt %s" ((sexp_of_class_stmt t0));
	| ClassConstant2 t0 -> spf "ClassConstant2 %s" ((sexp_of_class_constant t0));
	| ClassVariable t0 -> spf "ClassVariable %s" ((sexp_of_class_variable t0));
	| ListAssign t0 -> spf "ListAssign %s" ((sexp_of_list_assign t0));
	| ColonStmt2 t0 -> spf "ColonStmt2 %s" ((sexp_of_colon_stmt t0));
	| Case2 t0 -> spf "Case2 %s" ((sexp_of_case t0));
	| XhpAttribute t0 -> spf "XhpAttribute %s" ((sexp_of_xhp_attribute t0));
	| XhpAttrValue t0 -> spf "XhpAttrValue %s" ((sexp_of_xhp_attr_value t0));
	| XhpHtml2 t0 -> spf "XhpHtml2 %s" ((sexp_of_xhp_html t0));
	| XhpChildrenDecl2 t0 -> spf "XhpChildrenDecl2 %s" ((sexp_of_xhp_children_decl t0));
	| Info t0 -> spf "Info %s" ((sexp_of_tok t0));
	| InfoList t0 -> spf "InfoList %s" ((sexp_of_tok_list t0));
	| Ident2 t0 -> spf "Ident2 %s" ((sexp_of_ident t0));
	| Hint2 t0 -> spf "Hint2 %s" ((sexp_of_hint_type t0));
;
