#gnuplot -e "set term png; set title 'Stuff'; plot for [df in \"out_9.dat out_10.dat out_11.dat out_12.dat\"] df using 3:4 with lp; " > test.png

#gnuplot -e \
#"set term png;
#set title 'More stuff';
#set style data histograms;
#set style histogram clustered;
#set style fill solid 1.0 border lt -1;
#plot \"out_c.dat\" using 2 " > test.png

#gnuplot -e \
#"set term png;
#set title 'Time wasted in functions';
#set style data histograms;
#set style histogram clustered;
#set style fill solid 1.0 border lt -1;
#plot [-1:50] \"out_p.dat\" using 6, \"out_p.dat\" using 2, \"out_p.dat\" using 4, \"out_p.dat\" using 5 axes x1y2 with lp " > test.png
# , \"out_p.dat\" using 7 axes x1y2 with lp
#