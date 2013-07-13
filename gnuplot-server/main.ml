open Unix;;
open Printf;;
(*
let err_st = Unix.dup stderr in
let out_st = Unix.dup stdout in
let ins_st = Unix.dup stdin in
Printf.printf "dupped\n";
let args = [| "gnuplot" |] in
let pid = Unix.create_process "gnuplot" args ins_st out_st err_st in 
Printf.printf "pid is %d\n" pid;
*)
(*
FUCK PIPES.FUCK'EM.
*)
let out_r, out_w = Unix.pipe () in
let ins_r, ins_w = Unix.pipe () in
let err_r, err_w = Unix.pipe () in
Unix.dup2 Unix.stdin out_r;
let args = [| "gnuplot" |] in
let pid = Unix.create_process "gnuplot" args ins_r out_w err_w in 
Printf.printf "pid is %d\n" pid;
flush Pervasives.stdout;
let a, b, c = Unix.select [ins_r] [out_w] [err_w] 0.0 in 
Printf.printf "select returned %d %d %d\n" (List.length a) (List.length b) (List.length c);
flush Pervasives.stdout;
let x = input_line (Unix.in_channel_of_descr Unix.stdin) in
Printf.printf "%s\n" x;;
(*let rr = List.hd b in
let buf = String.make 1 '.' in
let n = Unix.read out_r buf 0 1 in
Printf.printf "Read %d: %s" n buf;;  *)


