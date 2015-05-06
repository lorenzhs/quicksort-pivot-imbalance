# IMPORT-DATA eval ../time.log

set terminal pdf size 13.33cm,10cm linewidth 2.0
set pointsize 0.5
set output "time.pdf"

set grid xtics ytics

set key top right

set title 'Sorting a random permutation of the integers 0..n-1'
set xlabel 'log₂(n)'
set ylabel 'running time / n log₂n in nanoseconds'

set yrange [2.17:3.133]

## MULTIPLOT(skew) SELECT log(2, n) x, avg(time)*1.0/(n*log(2, n))*1000000.0 AS y, MULTIPLOT
## FROM eval WHERE skew>1 GROUP BY n, MULTIPLOT,x ORDER BY MULTIPLOT,x
plot \
    'time-data.txt' index 0 title "skew=2" with linespoints, \
    'time-data.txt' index 1 title "skew=3" with linespoints, \
    'time-data.txt' index 2 title "skew=4" with linespoints, \
    'time-data.txt' index 3 title "skew=5" with linespoints, \
    'time-data.txt' index 4 title "skew=6" with linespoints, \
    'time-data.txt' index 5 title "skew=7" with linespoints, \
    'time-data.txt' index 6 title "skew=8" with linespoints, \
    'time-data.txt' index 7 title "skew=9" with linespoints, \
    'time-data.txt' index 8 title "skew=10" with linespoints, \
    'time-data.txt' index 9 title "skew=11" with linespoints, \
    'time-data.txt' index 10 title "skew=12" with linespoints
