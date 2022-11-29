# Rescue (2022 Fall)

COSE212-22F 강의의 학생들이 확장한 Rescue 언어(Rescue v5)입니다.
기본 Rescue 언어는 [[여기]](https://github.com/kupl/rescue-lang)에서 확인할 수 있습니다.

## Rescue

#### 문법

Rescue 프로그램 `P`는 작은 수정을 정의한 언어로 명령의 리스트로 이루어져 있습니다.
```
P = I*
I = C | C N
C = ^ | v | < | >
  | origin
  | backspace
  | insert(S)
N = positibe integer (* i.e., 1, 2, ... *)
S = raise UndefinedSemantics
  | ;
  | V
  | " "       // 공백 문자로 큰 따옴표 없이 입력해야 합니다. e.g.) insert( )
  | (
  | \)        // insert의 )와 구분하기 위한 \가 필요합니다. 입력은 )만 입력됩니다. e.g.) insert(\))
  | raise TypeError
  | __entry__ // 진입점 함수의 이름(e.g., min)이 삽입됩니다.
              // 진입점 함수의 이름 또는 __entry__ 중 어느 것을 사용하여도 삽입되는 문자열은 같습니다.
              // 예를 들어, 진입점 함수가 min일 경우 아래 두 insert는 모두 min을 삽입합니다:
              //   insert(__entry__)
              //   insert(min)
V = __ | _V   // 2개 이상의 _의 나열
```

#### 의미
* `C N`: `C` 커맨드를 `N`번 반복합니다.
* `^`, `v`, `<`, `>`: 각각 상하좌우 방향으로 커서를 움직이는 것을 의미합니다.
* `origin`: 커서를 맨 위, 맨 왼쪽으로 이동시킵니다.
* `backspace`: 커서 위치에서 한 글자 지웁니다.
* `insert(S)`: 커서 위치에 `S`를 삽입합니다.


#### 예시
1. `fact.ml`의 중간의 `;;;`중 `;` 하나 지우기

오류 코드
```ocaml
(* fact.ml *)
let rec fact : int -> int
= fun n -> if n > 1 then 1 else n * fact (n - 1);;;

fact 10;;
```

Rescue
```sh
rescue -verbose -target examples/fact.ml "vv>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>backspace"
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
rescue -verbose -target examples/add.ml "vvvvvvvv >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> insert(;)insert(;) origin vvvvvvvvvv >>>>>>>>>>>>>>> insert(;)insert(;) origin vvvvvvvvvvv >>>>>>>>>>>>>>> insert(;)insert(;)"
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

3. `diff.ml`의 진입점 함수 `diff`에 발생한 오타 수정

오류 코드
```ocaml
(* diff.ml *)
let dif : int -> int -> int
= fun a b -> if a > b then a - b else b - a
```

Rescue
```sh
rescue -verbose -entry diff -target examples/diff.ml "v>7backspace3insert(diff)"
```

수정된 코드
```ocaml
(* diff.ml *)
let diff : int -> int -> int
= fun a b -> if a > b then a - b else b - a
```

## 사용법
Rescue는 아래 두 프로그램을 이용하여 빌드합니다.
* [`opam`](https://opam.ocaml.org/doc/Install.html)
* [`dune`](https://dune.build/install)
```sh
git clone https://github.com/kupl/rescue-22f.git
cd rescue-22f
opam pin add --yes rescue https://github.com/kupl/rescue-lang.git
dune build
dune install
# your command: rescue ...
```
