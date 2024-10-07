(** head includes section *)
let incl (hpp : out_channel) (cpp : out_channel) : unit =
  Printf.fprintf hpp
    "/// @file @brief Virtual Machine Compiled (headers)
#pragma once";
  Printf.fprintf cpp
    "/// @file @brief Virtual Machine Compiled (code)
#include \"vmc.hpp\""

(** libc headers *)
let libc (hpp : out_channel) (_cpp : out_channel) : unit =
  Printf.fprintf hpp
    "\n
#include <stdio.h>
#include <stdlib.h>
#include <assert.h>
"

let main (hpp : out_channel) (cpp : out_channel) : unit =
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

let arg (hpp : out_channel) (cpp : out_channel) : unit =
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

let main_g hpp cpp =
  Printf.fprintf hpp "
/// @defgroup main main
/// @{
";
  main hpp cpp;
  arg hpp cpp;
  Printf.fprintf hpp "
/// @}
"

let dirs (path : string) : unit =
  let dir (path : string) : unit =
    try Sys.mkdir path 0o700 with
    | Sys_error _ -> ()
  in

  List.iter
    (fun d ->
      path ^ d |> dir;
      path ^ "/.gitignore" |> open_out |> close_out)
    [ ""; "/.vscode"; "/bin"; "/doc"; "/lib"; "/inc"; "/src"; "/tmp"; "/ref" ]

let _ =
  let path : string = Sys.getenv "HOME" ^ "/vmc/meta" in
  dirs path;
  let hpp = open_out (path ^ "/inc/vmc.hpp") in
  let cpp = open_out (path ^ "/src/vmc.cpp") in
  incl hpp cpp;
  libc hpp cpp;
  main_g hpp cpp;
  close_out hpp;
  close_out cpp
