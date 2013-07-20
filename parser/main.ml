
type lispval =
  | Nil
  | Cons of lispval * lispval
  | Symbol of string
  | Int of int
  | String of string
;;

let rec write_to_sexp oc obj = 
  let rec write_to_sexp_inside_list oc obj = match obj with
    | Cons(car, Cons(cadr, cddr)) ->
      write_to_sexp oc car;
      output_string oc " ";
      write_to_sexp oc cadr;
      if cddr != Nil then output_string oc " ";
      write_to_sexp_inside_list oc cddr;
    | Cons(car, Nil) ->
      write_to_sexp oc car;
    | Cons(car, otherwise) ->
      write_to_sexp oc obj;
    | _ ->
      output_string oc "";
  in
  match obj with
  | Nil -> output_string oc "NIL";
  | Cons(car, Cons(cadr, cddr)) ->
    output_string oc "(";
    write_to_sexp_inside_list oc obj;
    output_string oc ")";
  | Cons(value, Nil) ->
    output_string oc "(";
    write_to_sexp oc value;
    output_string oc ")";
  | Cons(head, tail) -> 
    output_string oc "(";
    write_to_sexp oc head;
    output_string oc " . ";
    write_to_sexp oc tail;
    output_string oc ")";
  | Symbol(name) ->
    output_string oc ":";
    output_string oc name; 
  | String(value) ->
    output_string oc "\"";
    output_string oc value;
    output_string oc "\"";
  | Int(value) ->
    output_string oc (Printf.sprintf "%d" value);
in
let s_handle ic oc =
  let s = input_line ic
  in let _str = String.uppercase s    
     in output_string oc _str;
     write_to_sexp oc (Cons(Symbol("file"), 
			    Cons(String("A filename"), 
				 Cons(Int(1), 
				      Cons(Int(2), Nil)))));
     write_to_sexp oc (Cons(Nil, Nil));
     write_to_sexp oc (Cons(Cons(Symbol("something"), Int(2)), Nil));
     write_to_sexp oc (Cons(Cons(Symbol("something"), Int(2)), 
			    Cons(Cons(Symbol("other"), 
				      Cons(Int(1), Cons(Int(2), Nil))), 
				 Nil)));
     output_string oc "\r\n";
     flush oc;
     Printf.printf "got input '%s'\n" s;
     flush stdout;
     let r =  match (String.sub s 0 1) with
	 "x" -> false
       | _ -> true in
     r;
in

(*

Socket stuff

*)

let addr = Unix.inet_addr_of_string "192.168.23.164" in
let port = 5678 in
let s_socket = Unix.socket Unix.PF_INET Unix.SOCK_STREAM 0 in
Unix.bind s_socket (Unix.ADDR_INET(addr, port));
Unix.listen s_socket 10;
let serve = ref true in
while !serve do
  let (c_socket, caller) = Unix.accept s_socket in
  let str_addr = match caller with
      Unix.ADDR_INET(c_addr, c_port) -> Unix.string_of_inet_addr c_addr
    | Unix.ADDR_UNIX(c_fname) -> c_fname in
  let in_chan = Unix.in_channel_of_descr c_socket in
  let out_chan = Unix.out_channel_of_descr c_socket in
  Printf.printf "a connection from %s\n" str_addr;
   (*
     Printf.printf "in_chan: %d\n" in_chan;
   *)
  flush stdout;
  serve := s_handle in_chan out_chan;
   (*
   close_in in_chan;
   *)
  close_out out_chan;
(*
  serve := false;
*)
done;
Unix.close s_socket;;
