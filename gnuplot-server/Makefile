
SYSLIBS=/usr/lib/ocaml/unix.cma

all: out_p.png out_c.png out_mem.png out_mem2.png out_c.html out_c.svg
# a.out 

clean:
	rm -f *.out *.png

a.out: main.ml
	ocamlc $(FLAGS) -custom $(SYSLIBS) $(LIBS) $(INCLUDES) main.ml -cclib -lunix

out_p.png: out_p.dat
	gnuplot -e "set term png; set title 'Time wasted in functions'; set style data histograms; set style histogram clustered; set style fill solid 1.0 border lt -1; plot [-1:50] \"trace.11.out\" using 6, \"trace.11.out\" using 2, \"trace.11.out\" using 4, \"trace.11.out\" using 5 axes x1y2 with lp " > out_p.png

out_c.png: out_c.dat
	gnuplot -e "set term png; set title 'Function calls'; set style data histograms; set style histogram clustered; set style fill solid 1.0 border lt -1; plot [-1:50] \"out_c.dat\" using 2 " > out_c.png


out_mem.png: out_mem.dat
	gnuplot -e "set term png; set title 'Memory usage vs progress'; plot \"out_mem.dat\" using 3:4 with lp, \"out_mem.dat\" using 3:5 axes x1y2 with lp; " > out_mem.png

out_mem2.png: out_mem.dat
	gnuplot -e "set term png; set title 'Memory usage vs nestedness'; plot \"out_mem.dat\" using 3:4 with lp, \"out_mem.dat\" using 3:6 axes x1y2 with lp; " > out_mem2.png

out_c.html: out_c.dat
	gnuplot -e "set term canvas standalone mousing; set title 'Function calls'; set style data histograms; set style histogram clustered; set style fill solid 1.0 border lt -1; plot [-1:50] \"out_c.dat\" using 2 " > out_c.html

out_c.svg: out_c.dat
	gnuplot -e "set term svg mousing; set title 'Function calls'; set style data histograms; set style histogram clustered; set style fill solid 1.0 border lt -1; plot [-1:50] \"out_c.dat\" using 2 " > out_c.svg

trace.11.png: trace.11.out
	gnuplot -e "set term png; set title 'Time wasted in functions'; set style data histograms; set style histogram clustered; set style fill solid 1.0 border lt -1; plot [-1:50] \"trace.11.out\" using 2, \"trace.11.out\" using 4 axes x1y2 with lp " > out_p.png
