module PredefinedString = struct
  type t =
    (* raise UndefinedSemantics *)
    | RaiseUndefinedSemantics
    (* ; *)
    | Semicolon
    (* __* *)
    | NewVar of string
    (* ' ' *)
    | Space
    (* ( *)
    | LParen
    (* ) *)
    | RParen

  let from_string (str : string) : t =
    let is_underscore_variable (var : string) : bool =
      let underscores = Str.regexp "___*$" in
      Str.string_match underscores var 0
    in
    match str with
    | "raise UndefinedSemantics" -> RaiseUndefinedSemantics
    | ";" -> Semicolon
    | underscores when is_underscore_variable underscores -> NewVar underscores
    | " " -> Space
    | "(" -> LParen
    | ")" -> RParen
    | _ -> raise (Rescue.Lang.NotINPredefinedStringSet str)

  let get_string_value (value : t) : string =
    match value with
    | RaiseUndefinedSemantics -> "raise UndefinedSemantics"
    | Semicolon -> ";"
    | NewVar underscores -> underscores
    | Space -> " "
    | LParen -> "("
    | RParen -> ")"

  let pp (formatter : Format.formatter) (str : t) : unit =
    get_string_value str |> Format.fprintf formatter "%s"
end

module S = Rescue.Lang.Make (PredefinedString)
module Command = S.Command
module Program = S.Program