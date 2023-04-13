module Source = Revise.Source
module PredefinedString = Revise22f.Lang.PredefinedString
module Program = Revise22f.Lang.Program
module Parser = Revise22f.Parser
module Interpreter = Revise22f.Interpreter

let main () =
  (* Args *)
  let pgm = ref "" in
  let opt_target = ref "" in
  let opt_verbose = ref false in
  let opt_inplace = ref false in
  let options =
    [
      "-target", Arg.String (fun x -> opt_target := x), "Target to revise";
      "-verbose", Arg.Set opt_verbose, "Show edit step by step";
      "-inplace", Arg.Set opt_inplace, "Inplace the update";
      "-entry", Arg.String (fun x -> PredefinedString.entry_function := x), "Name of entry function";
    ]
  in
  let usage = "Usage: revise [-verbose] [-inplace] -target <target.ml> REVISE" in
  let _ = Arg.parse options (fun x -> pgm := x) usage in
  let _ =
    if (not (Sys.file_exists !opt_target)) && !opt_inplace then (
      print_endline "-target must be a file with -inplace option";
      exit 1)
  in
  (* Revise *)
  let pgm =
    (if Sys.file_exists !pgm then Util.File.read_file_from_path !pgm else !pgm) |> Parser.parse
  in
  (* Source *)
  let target =
    (if Sys.file_exists !opt_target then Util.File.read_file_from_path !opt_target else !opt_target)
    |> Source.from_string
  in
  (* Interprete *)
  let processed =
    if !opt_verbose then (
      Format.fprintf Format.std_formatter "\n\n\n\n\n\n\n\n\n\n\n\027[11F";
      Format.pp_print_flush Format.std_formatter ();
      Format.fprintf Format.std_formatter "\0277";
      let src =
        List.fold_left
          (fun (src : Source.t) cmd ->
            Source.pp ~with_display:(List.length src.source > 11) Format.std_formatter src;
            Format.fprintf Format.std_formatter "\n";
            Format.pp_print_flush Format.std_formatter ();
            Unix.sleepf 0.1;
            Format.fprintf Format.std_formatter "\0278\027[0J";
            Interpreter.interprete [cmd] src)
          target
          pgm
      in
      Source.pp ~with_display:(List.length src.source > 11) Format.std_formatter src;
      Format.fprintf Format.std_formatter "\n";
      Format.pp_print_flush Format.std_formatter ();
      Format.fprintf Format.std_formatter "\0278\027[0J";
      Unix.sleep 1;
      src)
    else Interpreter.interprete pgm target
  in
  (* Print *)
  if !opt_inplace then
    Source.pp
      ~with_cursor:false
      (!opt_target |> open_out |> Format.formatter_of_out_channel)
      processed
  else (
    Source.pp ~with_cursor:false Format.std_formatter processed;
    Format.fprintf Format.std_formatter "\n")

let () = main ()
