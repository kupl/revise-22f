{
    open Generator
    exception LexingError
}

let whitespace = [' ' '\t' '\n']
let down = ['v' 'V']
let backspace = ['b' 'B']['a' 'A']['c' 'C']['k' 'K']['s' 'S']['p' 'P']['a' 'A']['c' 'C']['e' 'E']
let insert = ['i' 'I']['n' 'N']['s' 'S']['e' 'E']['r' 'R']['t' 'T']
let origin = ['o' 'O']['r' 'R']['i' 'I']['g' 'G']['i' 'I']['n' 'N']
let digit = ['1'-'9']['0'-'9']*
let allowed = ['a'-'z''A'-'Z''_''('' '';']

rule read =
    parse
    | whitespace { read lexbuf }
    | digit { NUM (int_of_string (Lexing.lexeme lexbuf)) }
    | "^" { UP }
    | down { DOWN }
    | "<" { LEFT }
    | ">" { RIGHT }
    | "(" { predefined (Buffer.create 20) lexbuf }
    | origin { ORIGIN }
    | backspace { BACKSPACE }
    | insert { INSERT }
    | eof { EOF }
    | _ { raise LexingError }

and predefined buf =
    parse
    | ")" { PREDEFINED (Buffer.contents buf) }
    | "\\)" { let str = Lexing.lexeme lexbuf in (String.length str - 1) |> String.sub str 1 |>  Buffer.add_string buf; predefined buf lexbuf }
    | allowed { Buffer.add_string buf (Lexing.lexeme lexbuf); predefined buf lexbuf }
    | _ { raise LexingError }
