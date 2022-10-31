{
    open Generator
    exception LexingError
}

let whitespace = [' ' '\t' '\n']
let down = ['v' 'V']
let backspace = ['b' 'B']['a' 'A']['c' 'C']['k' 'K']['s' 'S']['p' 'P']['a' 'A']['c' 'C']['e' 'E']
let insert = ['i' 'I']['n' 'N']['s' 'S']['e' 'E']['r' 'R']['t' 'T']
let origin = ['o' 'O']['r' 'R']['i' 'I']['g' 'G']['i' 'I']['n' 'N']
let digit = ['1'-'9']['0'-'9']

rule read =
    parse
        | whitespace { read lexbuf }
        | digit { NUM (int_of_string (Lexing.lexeme lexbuf)) }
        | "^" { UP }
        | down { DOWN }
        | "<" { LEFT }
        | ">" { RIGHT }
        | "(" { LPAREN }
        | ")" { RPAREN }
        | origin { ORIGIN }
        | backspace { BACKSPACE }
        | insert { INSERT }
        | "raise UndefinedSemantics" { UNDEFINEDSEMANTICS }
        | ";" { SEMICOLON }
        | eof { EOF }
        | _ { raise LexingError }
