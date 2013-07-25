.PHONY: all clean

all: main.out

main.out: main.lisp make.lisp
	sbcl --load make.lisp

clean:
	rm -f *.out
