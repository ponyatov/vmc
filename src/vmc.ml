let project name = 
  try Sys.mkdir name 0o700; with Sys_error _ -> ();
  open_out (name ^ "/README.md") |> close_out;
  open_out (name ^ "/LICENSE") |> close_out;
  open_out (name ^ "/rc") |> close_out;
  open_out (name ^ "/README.md") |> close_out;
  open_out (name ^ "/README.md") |> close_out;
  open_out (name ^ "/README.md") |> close_out;

let () = project "meta"

let pp (fmt:Format.formater) (ast:AST): string = ""
