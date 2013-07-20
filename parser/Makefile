

all: main.out parsefile.out

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

#  $(PFROOT)/lang_php/analyze/lib.cma \
 $(PFROOT)/lang_php/analyze/checker/lib.cma \
 $(PFROOT)/lang_php/analyze/foundation/lib.cma \
 $(PFROOT)/lang_php/analyze/tools/lib.cma \
 $(PFROOT)/lang_php/analyze/visual/lib.cma \
 $(PFROOT)/lang_php/analyze/qa_test/lib.cma \

#  $(PFROOT)/globals/lib.cma \


INCLUDESPF=$(INCLUDES) \
 -I $(PFROOT)/commons \
 -I $(PFROOT)/commons/lib-sexp \
 -I $(PFROOT)/commons/lib-json \
 -I $(PFROOT)/h_program-lang \
 -I $(PFROOT)/lang_php/parsing \
 -I $(PFROOT)/h_version-control

main.out: main.ml
	ocamlc $(FLAGS) -o $@ -custom $(SYSLIBS) $(LIBS) $(INCLUDES) $^ -cclib -lunix -cclib -lpcre

parsefile.out: parsefile.ml
	ocamlc $(FLAGS) -o $@ -custom $(SYSLIBSPF) $(LIBSPF) $(INCLUDESPF) $^ -cclib -lunix -cclib -lpcre

clean: 
	rm -f *.out