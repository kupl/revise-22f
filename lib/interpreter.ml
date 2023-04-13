module S = Revise.Interpreter.Make (Lang.S)

let interprete (pgm : Lang.Program.t) (src : Revise.Source.t) : Revise.Source.t =
  S.interprete pgm src
