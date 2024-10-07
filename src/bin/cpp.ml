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

  [ ""; "/.vscode"; "/bin"; "/doc"; "/lib"; "/inc"; "/src"; "/tmp"; "/ref" ]
  |> List.iter (fun d ->
         path ^ d |> dir;
         path ^ d ^ "/.gitignore" |> open_out |> close_out)

let gen (name : string) : unit =
  let path : string = Sys.getenv "HOME" ^ "/vmc/" ^ name in
  dirs path name;
  let hpp = open_out (path ^ "/inc/" ^ name ^ ".hpp") in
  let cpp = open_out (path ^ "/src/" ^ name ^ ".cpp") in
  incl hpp cpp name;
  libc hpp cpp name;
  main_g hpp cpp name;
  close_out hpp;
  close_out cpp

let _ = gen "meta"
