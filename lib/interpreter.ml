module S = Rescue.Interpreter.Make (Lang.S)

let interprete (pgm : Lang.Program.t) (src : Rescue.Source.t) : Rescue.Source.t = S.interprete pgm src
