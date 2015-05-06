# IMPORT-DATA eval ../qsort.log ../ssssort-perf.log

set terminal pdf size 16cm,12cm linewidth 2.0
set pointsize 0.5
set output "instructions.pdf"

set grid xtics ytics

set key top right

set title 'Sorting a random permutation of the integers 0..n-1'
set xlabel 'log₂(n)'
set ylabel 'instructions executed / n log₂n'
set yrange [9:37]

## MULTIPLOT(skew) SELECT log(2, n) x, avg(instructions)/(n*log(2,n)) AS y, MULTIPLOT
## FROM eval GROUP BY n, MULTIPLOT,x ORDER BY MULTIPLOT,x
plot \
    'instructions-data.txt' index 0 title "ssssort" with linespoints, \
    'instructions-data.txt' index 1 title "std::sort" with linespoints, \
    'instructions-data.txt' index 2 title "skew=2" with linespoints, \
    'instructions-data.txt' index 3 title "skew=3" with linespoints, \
    'instructions-data.txt' index 4 title "skew=4" with linespoints, \
    'instructions-data.txt' index 5 title "skew=5" with linespoints, \
    'instructions-data.txt' index 6 title "skew=6" with linespoints, \
    'instructions-data.txt' index 7 title "skew=7" with linespoints, \
    'instructions-data.txt' index 8 title "skew=8" with linespoints, \
    'instructions-data.txt' index 9 title "skew=9" with linespoints, \
    'instructions-data.txt' index 10 title "skew=10" with linespoints, \
    'instructions-data.txt' index 11 title "skew=11" with linespoints, \
    'instructions-data.txt' index 12 title "skew=12" with linespoints
