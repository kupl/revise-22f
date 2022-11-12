%{
  let rec repeat (cmd: Lang.Command.t) (n : int) : Lang.Command.t list =
    if n > 0 then cmd::(repeat cmd (n - 1)) else []
%}

%token <int> NUM

%token UP
%token DOWN
%token LEFT
%token RIGHT

%token ORIGIN
%token BACKSPACE
%token INSERT

%token <string> PREDEFINED 

%token EOF

%start <Lang.Program.t> parse

%%

parse:
  | program = program ; EOF { program }

program:
  | { Lang.Program.empty () }
  | pgm=program ; iter=iter { let cmd, n = iter in repeat cmd n |> Lang.Program.add_commands pgm }

iter:
  | cmd=command ; num=number { (cmd, num) }

command:
  | UP { Lang.Command.up () }
  | DOWN { Lang.Command.down () }
  | LEFT { Lang.Command.left () }
  | RIGHT { Lang.Command.right () }
  | ORIGIN { Lang.Command.origin () }
  | BACKSPACE { Lang.Command.backspace () }
  | INSERT; str=PREDEFINED; { Lang.PredefinedString.from_string str |> Lang.Command.insert }

number:
  | { 1 }
  | num=NUM { num }
