(* fact.ml *)
let rec fact : int -> int
= fun n -> if n > 1 then 1 else n * fact (n - 1);;;

fact 10;;