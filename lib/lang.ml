module PredefinedString = struct
  type t =
  (* raise UndefinedSemantics *)
  | RaiseUndefinedSemantics
  (* ; *)
  | Semicolon

  let from_string (str : string) : t =
    match str with
    | "raise UndefinedSemantics" -> RaiseUndefinedSemantics
    | ";" -> Semicolon
    | _ -> raise (Rescue.Lang.NotINPredefinedStringSet str)

  let get_string_value (value : t) : string =
    match value with
    | RaiseUndefinedSemantics -> "raise UndefinedSemantics"
    | Semicolon -> ";"

  let pp (formatter : Format.formatter) (str : t) : unit =
    get_string_value str |> Format.fprintf formatter "%s"
end

module S = Rescue.Lang.Make (PredefinedString)
module Command = S.Command
module Program = S.Program