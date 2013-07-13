
SYSLIBS=/usr/lib/ocaml/unix.cma

a.out: main.ml
	ocamlc $(FLAGS) -custom $(SYSLIBS) $(LIBS) $(INCLUDES) main.ml -cclib -lunix
