
open Common;;
open Common2;;
open Ast_php;;
module Ast = Ast_php;;


let sexp_of_string_wrap (x : string wrap) =
  "string wrap";;

let sexp_of_xhp_tag_wrap (x: xhp_tag wrap) =
  "xhp_tag wrap";;

let sexp_of_tok (x : tok) = 
  "tok";;

let sexp_of_qualified_ident (x: qualified_ident) =
  "qualified_ident";;

let sexp_of_type_args_option (x : type_args option) =
  "type_args option";;

let sexp_of_hint_type_comma_list_paren (x: hint_type comma_list paren) =
  "hint_type comma_list paren";;

let sexp_of__A_tok_T__P_hint_type_comma_list_dots_paren_P__T__A_tok_T_hint_type_A__option_A__paren x = 
  "very long anonymous type";;

let sexp_of_class_name x =
  "class name";;

let sexp_of_Scope_php_phpscope_ref x =
  "scope php";;

let sexp_of_argument_comma_list_paren x =
  "...";;

let sexp_of_class_name_reference x =
  "...";;

let sexp_of_expr_option_bracket x =
  "...";;

let sexp_of_expr_brace x =
  "...";;

let sexp_of_expr_paren x =
  "...";;

let sexp_of_scalar x =
  "...";;

let sexp_of_binaryOp_wrap x =
  "...";;

let sexp_of_unaryOp_wrap x =
  "...";;

let sexp_of_lvalue x =
  "...";;

let sexp_of_assignOp_wrap x =
  "...";;

let sexp_of_rw_variable x =
  "...";;

let sexp_of_fixOp_wrap x =
  "...";;

let sexp_of_expr_option x =
  "...";;

let sexp_of_list_assign_comma_list_paren x =
  "...";;

let sexp_of_array_pair_comma_list_paren x =
  "...";;

let sexp_of_array_pair_comma_list_bracket x =
  "...";;

let sexp_of_array_pair_comma_list_brace x =
  "...";;

let sexp_of_argument_comma_list_paren_option x =
  "...";;

let sexp_of_castOp_wrap x =
  "...";;

let sexp_of_lambda_def x =
  "...";;

let sexp_of__A_expr_option_paren_A__option x =
  "...";;

let sexp_of_encaps_list x =
  "...";;

let sexp_of_lvalue_paren x =
  "...";;

let sexp_of_lvalue_comma_list_paren x =
  "...";;

let sexp_of_xhp_html x =
  "...";;

let sexp_of_constant x =
  "...";;

let sexp_of_cpp_directive_wrap x =
  "...";;

let sexp_of_class_stmt_list x =
  "...";;

let sexp_of_arithOp x =
  "...";;

let sexp_of_logicalOp x =
  "...";;

let sexp_of_xhp_attribute_list x =
  "...";;

let sexp_of_xhp_body_list x =
  "...";;

let sexp_of_xhp_tag_option_wrap x =
  "...";;

let sexp_of_w_variable x =
  "...";;

let sexp_of_stmt_and_def_list_brace x =
  "...";;

let sexp_of_if_elseif_list x =
  "...";;

let sexp_of_if_else_option x =
  "...";;

let sexp_of_stmt_and_def_list x =
  "...";;

let sexp_of_new_elseif_list x =
  "...";;

let dummy x = "...";;

let sexp_of_new_else_option = dummy;;
let sexp_of_colon_stmt = dummy;;
let sexp_of_for_expr = dummy;;
let sexp_of_switch_case_list = dummy;;
let sexp_of_foreach_var_either = dummy;;
let sexp_of_foreach_arrow_option = dummy;;
let sexp_of_catch = dummy;;
let sexp_of_catch_list = dummy;;
let sexp_of_expr_comma_list = dummy;;
let sexp_of_global_var_comma_list = dummy;;
let sexp_of_static_var_comma_list = dummy;;
let sexp_of_use_filename = dummy;;
let sexp_of_declare_comma_list_paren = dummy;;
let sexp_of__A_tok_T_expr_A__option = dummy;;
let sexp_of_func_def = dummy;;
let sexp_of_class_def = dummy;;
let sexp_of_tok_option = dummy;;
let sexp_of_case_list = dummy;;
let sexp_of_string_wrap_paren = dummy;;
let sexp_of_class_constant_comma_list = dummy;;
let sexp_of_class_var_modifier = dummy;;
let sexp_of_hint_type_option = dummy;;
let sexp_of_class_variable_comma_list = dummy;;
let sexp_of_method_def = dummy;;
let sexp_of_xhp_decl = dummy;;
let sexp_of_class_name_comma_list = dummy;;
let sexp_of__A_tok_M_trait_rule_list_brace_A__Common_either = dummy;;
let sexp_of_modifier_wrap = dummy;;
let sexp_of_xhp_attribute_decl_comma_list = dummy;;
let sexp_of_xhp_children_decl = dummy;;
let sexp_of_xhp_category_decl_comma_list = dummy;;
let sexp_of_xhp_attribute_type = dummy;;
let sexp_of_xhp_value_affect_option = dummy;;
let sexp_of_constant_comma_list_brace = dummy;;
let sexp_of_xhp_children_decl_paren = dummy;;
let sexp_of__A_ident_M_name_T_tok_T_ident_A__Common_either = dummy;;
let sexp_of_ident_option = dummy;;
let sexp_of_static_scalar_comma_list_paren = dummy;;
let sexp_of_constant_def = dummy;;
let sexp_of_type_def = dummy;;
let sexp_of_qualified_ident_option = dummy;;
let sexp_of_toplevel_list_brace = dummy;;
let sexp_of_tok_list = dummy;;
let sexp_of_modifier = dummy;;
let sexp_of_argument_comma_list = dummy;;
let sexp_of_parameter = dummy;;
let sexp_of_parameter_comma_list_dots_paren = dummy;;

(**)
