# RESCUE (2022 Fall)

COSE212-22F 강의의 학생들이 확장한 Rescue 언어(Rescue v2)입니다.
기본 Rescue 언어(Rescue v1)는 [[여기]](https://github.com/kupl/rescue-lang)에서 확인할 수 있습니다.

## Rescue

#### 문법

Rescue는 작은 수정을 정의한 언어로 명령의 리스트로 이루어져 있습니다.
```
P = C*
C = M | M N
  | origin
  | backspace
  | insert(S)
M = ^ | v | < | >
N = non-negative integer (* i.e., 0, 1, 2, ... *)
S = raise UndefinedSemantics
  | ;
```

#### 의미

* `M`: `^`, `v`, `<`, `>`이 각각 상하좌우 방향으로 커서를 움직이는 것을 의미합니다.
* `M N`: `M` 커맨드를 `N` 번 반복합니다.
* `origin`: 커서를 맨 위, 맨 왼쪽으로 이동시킵니다.
* `backspace`: 커서 위치에서 한 글자 지웁니다.
* `insert(S)`: 커서 위치에 `S`를 삽입합니다.


#### 예시
1. `fact.ml`의 맨 마지막 `;` 지우기

오류 코드
```ocaml
(* fact.ml *)
let rec fact : int -> int
= fun n -> if n > 1 then 1 else n * fact (n - 1);;;

fact 10;;
```

Rescue
```sh
$ rescue -verbose -target examples/fact.ml "vv>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>backspace"
```

수정된 코드
```ocaml
(* fact.ml *)
let rec fact : int -> int
= fun n -> if n > 1 then 1 else n * fact (n - 1);;

fact 10;;
```

2. `add.ml`에 `;;` 삽입

오류 코드
```ocaml
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
```

Rescue
```sh
$ rescue -verbose -target examples/add.ml "vvvvvvvv >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> insert(;)insert(;) origin vvvvvvvvvv >>>>>>>>>>>>>>> insert(;)insert(;) origin vvvvvvvvvvv >>>>>>>>>>>>>>> insert(;)insert(;)"
```

수정된 코드
```ocaml
(* add.ml *)
let rec map : ('a -> 'b) -> 'a list -> 'b list
= fun f l ->
  match l with
  | [] -> []
  | hd::tl -> (f hd)::(map f tl)

let add : int list -> int -> int list
= fun l a -> map (fun e -> e + a) l;;

add [1; 2; 3] 1;;
add [2; 4; 6] 2;;
```
