let parse (src : string) : Lang.Program.t =
  let lexbuf = Lexing.from_string src in
  Generator.parse Lexer.read lexbuf
