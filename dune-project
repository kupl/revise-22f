(lang dune 3.5)

(name revise22f)

(maintainers "Seokhyun Lee <seokhyunlee@korea.ac.kr>")
(authors "Seokhyun Lee <seokhyunlee@korea.ac.kr>")

(generate_opam_files true)

(source
 (github kupl/revise-22f))

(using menhir 2.1)

(package
 (name revise22f)
 (synopsis "A language define minor revision - 2022 Fall")
 (depends core))
