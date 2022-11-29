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
    (* __entry__ *)
    | Entry

  let entry_function = ref "__entry__"

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
    | "__entry__" -> Entry
    | str when str = !entry_function -> Entry
    | _ -> raise (Rescue.Lang.NotInPredefinedStringSet str)

  let get_string_value (value : t) : string =
    match value with
    | RaiseUndefinedSemantics -> "raise UndefinedSemantics"
    | Semicolon -> ";"
    | NewVar underscores -> underscores
    | Space -> " "
    | LParen -> "("
    | RParen -> ")"
    | Entry -> !entry_function

  let pp (formatter : Format.formatter) (str : t) : unit =
    get_string_value str |> Format.fprintf formatter "%s"
end

module S = Rescue.Lang.Make (PredefinedString)
module Command = S.Command
module Program = S.Program