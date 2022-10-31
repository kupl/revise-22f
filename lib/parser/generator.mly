%{
  let rec repeat (cmd: Ast.Lang.Command.t) (n : int) : Ast.Lang.Command.t list =
    if n > 0 then cmd::(repeat cmd (n - 1)) else []
%}

%token <int> NUM

%token UP
%token DOWN
%token LEFT
%token RIGHT

%token LPAREN
%token RPAREN

%token ORIGIN
%token BACKSPACE
%token INSERT

%token UNDEFINEDSEMANTICS
%token SEMICOLON

%token EOF

%start <Ast.Lang.Program.t> parse

%%

parse:
  | program = program ; EOF { program }

program:
  | { Ast.Lang.Program.empty () }
  | pgm=program ; iter=iter { let cmd, n = iter in repeat cmd n |> Ast.Lang.Program.add_commands pgm }

iter:
  | cmd=command ; num=number { (cmd, num) }

command:
  | UP { Ast.Lang.Command.up () }
  | DOWN { Ast.Lang.Command.down () }
  | LEFT { Ast.Lang.Command.left () }
  | RIGHT { Ast.Lang.Command.right () }
  | ORIGIN { Ast.Lang.Command.origin () }
  | BACKSPACE { Ast.Lang.Command.backspace () }
  | INSERT; LPAREN; str=string; RPAREN { Ast.Lang.Command.insert str }

string:
  | UNDEFINEDSEMANTICS { Ast.Lang.PredefinedString.undefinedSemantics () }
  | SEMICOLON { Ast.Lang.PredefinedString.semicolon () }

number:
  | { 1 }
  | num=NUM { num }
