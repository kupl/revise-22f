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
  | pgm=program ; cmd=command { Ast.Lang.Program.add_command pgm cmd }

command:
  | UP { Ast.Lang.Command.up () }
  | DOWN { Ast.Lang.Command.down () }
  | LEFT { Ast.Lang.Command.left () }
  | RIGHT { Ast.Lang.Command.right () }
  | ORIGIN { Ast.Lang.Command.origin () }
  | BACKSPACE { Ast.Lang.Command.backspace () }
  | INSERT; LPAREN; str=string; RPAREN { Ast.Lang.Command.insert str }

string:
  UNDEFINEDSEMANTICS { Ast.Lang.PredefinedString.undefinedSemantics () }
  | SEMICOLON { Ast.Lang.PredefinedString.semicolon () }
