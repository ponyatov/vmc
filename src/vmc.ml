type expr =
  | Int of int
  | Num of float
  | Char of char
  | Str of string
  | Id of string

let dump (e : expr) : string =
  match e with
  | Int n -> "int:" ^ string_of_int n
  | Num f -> "num:" ^ string_of_float f
  | Char c -> "char:'" ^ Char.escaped c
  | Str s -> "str:\"" ^ s ^ "\""
  | Id id -> "id:" ^ id

(** pretty-printer for utop *)
let pp (fmt : Format.formatter) (e : expr) = Format.pp_print_string fmt (dump e)

type env = (string * expr) list
(** environment type (symbol table) *)

(** global environment *)
let glob : env = [ ("pi", Num 3.1415); ("zero", Int 0) ]

(** lookup symbol in environment *)
let lookup (env : env) (v : string) : expr = List.assoc v env

(** evaluate expression into  *)
let eval (env : env) (e : expr) : expr =
  match e with
  | Int n -> e
  | Num f -> e
  | Char c -> e
  | Str s -> e
  | Id v -> lookup env v

let%test "int" = "int:123" = (Int 123 |> eval glob |> dump)
let%test "id" = "num:3.1415" = (Id "pi" |> eval glob |> dump)
let%test "zero" = "int:0" = (Id "zero" |> eval glob |> dump)

let _ =
  Sys.getcwd () |> print_endline;
  open_out "src/vmc.cpp" |> close_out;
  open_out "inc/vmc.hpp" |> close_out
