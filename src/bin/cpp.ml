(** head includes section *)
let incl (hpp : out_channel) (cpp : out_channel) (name : string) : unit =
  Printf.fprintf hpp
    "/// @file @brief Virtual Machine Compiled (headers)
#pragma once";
  Printf.fprintf cpp
    "/// @file @brief Virtual Machine Compiled (code)
#include \"%s.hpp\"" name

(** libc headers *)
let libc (hpp : out_channel) (_cpp : out_channel) (_name : string) : unit =
  Printf.fprintf hpp
    "\n
#include <stdio.h>
#include <stdlib.h>
#include <assert.h>
"

let main (hpp : out_channel) (cpp : out_channel) (_name : string) : unit =
  Printf.fprintf hpp
    "
/// @brief program entry point (POSIX/UNIX)
/// @param[in] argc number of arguments
/// @param[in] argv argument values (including program binary name)
int main(int argc, char* argv[]);
";
  Printf.fprintf cpp
    "\n
int main(int argc, char *argv[]) {  //
    arg(0, argv[0]);
    for (int i = 1; i < argc; i++) {  //
        arg(i, argv[i]);
    }
}"

let arg (hpp : out_channel) (cpp : out_channel) (_name : string) : unit =
  Printf.fprintf hpp
    "
/// @brief print command line argument `argv[index] = <value>`
/// @param[in] argc index
/// @param[in] argv value
void arg(int argc, char* argv);
";
  Printf.fprintf cpp
    "\n
void arg(int argc, char *argv) {  //
    fprintf(stderr, \"argv[%%i] = <%%s>\\n\", argc, argv);
}
"

let main_g hpp cpp (name : string) =
  Printf.fprintf hpp "
/// @defgroup main main
/// @{
";
  main hpp cpp name;
  arg hpp cpp name;
  Printf.fprintf hpp "
/// @}
"

let dirs (path : string) (_name : string) : unit =
  let dir (path : string) : unit =
    try Sys.mkdir path 0o700 with
    | Sys_error _ -> ()
  in
  let star = [ "/bin"; "/tmp"; "/ref" ] in
  [ ""; "/.vscode"; "/doc"; "/lib"; "/inc"; "/src" ] @ star
  |> List.iter (fun d ->
         path ^ d |> dir;
         let giti = path ^ d ^ "/.gitignore" |> open_out in
         let g = Printf.fprintf giti in
         if d = "" then "*~\n*.swp\n*.log\n/docs/\n" |> g;
         if List.exists (( = ) d) star then "*\n" |> g;
         "!.gitignore\n" |> g;
         close_out giti)

let apt (path : string) (_name : string) : unit =
  let apt = path ^ "/apt.txt" |> open_out in
  let a = Printf.fprintf apt in
  "git make curl
code meld doxygen clang-format
g++ flex bison libreadline-dev
" |> a;
  apt |> close_out

let ini (path : string) (name : string) : unit =
  let ini = path ^ "/lib/" ^ name ^ ".ini" |> open_out in
  let i = Printf.fprintf ini in
  let ix f x = Printf.fprintf ini x f in
  "# line comment\n" |> i;
  "MODULE = '%s'\n" |> ix name;
  ini |> close_out

let mk (path : string) (name : string) : unit =
  let mk = path ^ "/Makefile" |> open_out in
  let m = Printf.fprintf mk in
  let mx x f = Printf.fprintf mk f x in
  (* *)
  "# var
MODULE ?= %s
" |> mx name;
  (* *)
  "
# dir
CWD = $(CURDIR)
" |> m;
  (* *)
  "
# tool
CURL = curl -L -o
CF   = clang-format -style=file -i
" |> m;
  (* *)
  "
# src
C += $(wildcard src/*.c*)
H += $(wildcard inc/*.h*)
S += lib/$(MODULE).ini $(wildcard lib/*.s)
"
  |> m;
  (* *)
  "
# cfg
CFLAGS += -O0 -ggdb -Iinc -Itmp
" |> m;
  (* *)
  let bi = "bin/$(MODULE) $(S)" in
  "\n# all\n.PHONY: all run" |> m;
  "\nall: %s" |> mx bi;
  "\nrun: %s" |> mx bi;
  "\n\t$^\n" |> m;
  (* *)
  "
# format
.PHONY: format
format: tmp/format_cpp
tmp/format_cpp: $(C) $(H)
\t$(CF) $^ && touch $@
"
  |> m;
  (* *)
  "
# rule
bin/$(MODULE): $(C) $(H)
\t$(CXX) $(CFLAGS) -o $@ $(C) $(L) && $(SIZE) $@
"
  |> m;
  (* *)
  "
# doc
.PHONY: doc
doc:
" |> m;
  (* *)
  "
# install
.PHONY: install update ref gz
install: doc ref gz
\t$(MAKE) update
update:
\tsudo apt update
\tsudo apt install -uy `cat apt.txt`
ref:
gz:
"
  |> m;
  (* *)
  close_out mk

let gen (name : string) : unit =
  let path : string = Sys.getenv "HOME" ^ "/vmc/" ^ name in
  dirs path name;
  mk path name;
  apt path name;
  ini path name;
  let hpp = open_out (path ^ "/inc/" ^ name ^ ".hpp") in
  let cpp = open_out (path ^ "/src/" ^ name ^ ".cpp") in
  incl hpp cpp name;
  libc hpp cpp name;
  main_g hpp cpp name;
  close_out hpp;
  close_out cpp

let _ = gen "meta"
