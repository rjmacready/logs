
open Common;;

(*module Ast = Ast_php_simple
module Env = Env_typing_php
module Infer  = Typing_php
module Builtins = Builtins_typed_php
*)
module InferH = Typing_helpers_php

open Env_interpreter_php
module Env = Env_interpreter_php
module Interp = Abstract_interpreter_php.Interp (Tainting_fake_php.Taint)
module Db = Database_juju_php
module CG = Callgraph_php2

let to_string env t =
  let buf = Buffer.create 256 in
  let o   = Buffer.add_string buf in
  let ()  = InferH.Print.show_type env o t in
  Buffer.contents buf

let prepare content =
  let tmp_file =
    Parse_php.tmp_php_file_from_string content in
  let db =
    Db.code_database_of_juju_db  (Db.juju_db_of_files [tmp_file]) in
  let env =
    Env.empty_env db tmp_file in
  let ast =
    Ast_php_simple_build.program (Parse_php.parse_program tmp_file) in
  env, ast;;

(* let env, ast = prepare " $x = 42; " in *)
let env, ast = prepare " function a() { return 1; }; print a(); " in
pr2 (spf "%s\n" !(env.file));;
