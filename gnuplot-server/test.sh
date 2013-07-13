gnuplot -e "set term png; set title 'Stuff'; plot for [df in \"out_9.dat out_10.dat out_11.dat out_12.dat\"] df using 3:4 with lp; " > test.png
