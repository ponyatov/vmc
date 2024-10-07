let arg (hpp : out_channel) (cpp : out_channel) : unit =
  Printf.fprintf hpp "";
  Printf.fprintf cpp ""

let once (hpp : out_channel) (_cpp : out_channel) : unit =
  Printf.fprintf hpp "#pragma once"

let _ =
  let path : string = Sys.getenv "HOME" ^ "/vmc" in
  let hpp = open_out (path ^ "/inc/vmc.hpp") in
  let cpp = open_out (path ^ "/src/vmc.cpp") in
  once hpp cpp;
  arg hpp cpp;
  close_out hpp;
  close_out cpp
