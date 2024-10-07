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
  (* *)
  let cpp = open_out "src/vmc.cpp" in
  Printf.fprintf cpp
    "#include \"vmc.hpp\"

int main(int argc, char *argv[]) {  //
    arg(0, argv[0]);
    for (int i = 1; i < argc; i++) {  //
        arg(i, argv[i]);
    }
}

void arg(int argc, char *argv) {  //
    fprintf(stderr, \"argv[%%i] = <%%s>\\n\", argc, argv);
}
";
  close_out cpp;
  (* *)
  let hpp = open_out "inc/vmc.hpp" in
  Printf.fprintf hpp
    "#pragma once

#include <stdio.h>
#include <stdlib.h>
#include <assert.h>

int main(int argc, char *argv[]);
void arg(int argc, char *argv);
";
  close_out hpp
