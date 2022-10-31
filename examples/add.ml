(* add.ml *)
let rec map : ('a -> 'b) -> 'a list -> 'b list
= fun f l ->
  match l with
  | [] -> []
  | hd::tl -> (f hd)::(map f tl)

let add : int list -> int -> int list
= fun l a -> map (fun e -> e + a) l

add [1; 2; 3] 1
add [2; 4; 6] 2
