
.PHONY: all clean
all: main.out parsefile.out pli.out parseml.out stmp.ml teststmp.out

SYSLIBS=/usr/lib/ocaml/unix.cma \
 /usr/lib/ocaml/str.cma \
 /usr/lib/ocaml/bigarray.cma \
 /usr/lib/ocaml/nums.cma

LIBS=

INCLUDES=-I /usr/lib/ocaml

# -warn-error +a
FLAGS=-g -dtypes -bin-annot -thread -w +9 -w -21

PFROOT=/home/user/pfff

SYSLIBSPF=$(SYSLIBS)
LIBSPF=$(LIBS) \
 $(PFROOT)/commons/lib.cma \
 $(PFROOT)/h_version-control/lib.cma \
 $(PFROOT)/h_program-lang/lib.cma \
 $(PFROOT)/matcher/lib.cma \
 $(PFROOT)/lang_php/parsing/lib.cma

INCLUDESPF=$(INCLUDES) \
 -I $(PFROOT)/commons \
 -I $(PFROOT)/commons/lib-sexp \
 -I $(PFROOT)/commons/lib-json \
 -I $(PFROOT)/h_program-lang \
 -I $(PFROOT)/lang_php/parsing \
 -I $(PFROOT)/h_version-control

LIBSPF2=$(LIBSPF) \
 $(PFROOT)/lang_php/analyze/foundation/lib.cma \
 $(PFROOT)/code_map/lib.cma

INCLUDESPF2=$(INCLUDESPF) \
 -I $(PFROOT)/lang_php/analyze/foundation \
 -I $(PFROOT)/code_map

LIBSPF3=$(LIBS) \
 $(PFROOT)/commons/lib.cma \
 $(PFROOT)/h_program-lang/lib.cma \
 $(PFROOT)/matcher/lib.cma \
 $(PFROOT)/lang_ml/parsing/lib.cma

INCLUDESPF3=$(INCLUDES) \
 -I $(PFROOT)/commons \
 -I $(PFROOT)/commons/ocamlextra \
 -I $(PFROOT)/commons/lib-sexp \
 -I $(PFROOT)/commons/lib-json \
 -I $(PFROOT)/globals \
 -I $(PFROOT)/h_program-lang \
 -I $(PFROOT)/matcher \
 -I $(PFROOT)/lang_ml/parsing

main.out: main.ml
	ocamlc $(FLAGS) -o $@ -custom $(SYSLIBS) $(LIBS) $(INCLUDES) $^ -cclib -lunix -cclib -lpcre

parsefile.out: parsefile.ml
	ocamlc $(FLAGS) -o $@ -custom $(SYSLIBSPF) $(LIBSPF) $(INCLUDESPF) $^ -cclib -lunix -cclib -lpcre

pli.out: pli.ml
	ocamlc $(FLAGS) -o $@ -custom $(SYSLIBSPF) $(LIBSPF2) $(INCLUDESPF2) $^ -cclib -lunix -cclib -lpcre

parseml.out: parseml.ml
	ocamlc $(FLAGS) -o $@ -custom $(SYSLIBSPF) $(LIBSPF3) $(INCLUDESPF3) $^ -cclib -lunix -cclib -lpcre

parsemlsexp.out: parsemlsexp.ml
	ocamlc $(FLAGS) -o $@ -custom $(SYSLIBSPF) $(LIBSPF3) $(INCLUDESPF3) $^ -cclib -lunix -cclib -lpcre

p.tmp: parseml.out
	./parseml.out

stmp.ml: parsemlsexp.out
	./parsemlsexp.out

teststmp.out: stmpbase.ml stmp.ml sexptmp.ml teststmp.ml
	ocamlc $(FLAGS) -o $@ -custom $(SYSLIBSPF) $(LIBSPF) $(INCLUDESPF) $^ -cclib -lunix -cclib -lpcre

clean: 
	rm -f *.out *.tmp *.annot *.cmo *.cmi *.cmt stmp.ml
