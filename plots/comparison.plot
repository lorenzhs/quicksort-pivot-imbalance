# IMPORT-DATA eval time.log ssssort.log

set terminal pdf size 13.33cm,10cm linewidth 2.0
set pointsize 0.5
set output "comparison.pdf"

set grid xtics ytics

set key bottom left

set title 'Sorting a random permutation of the integers 0..n-1'
set xlabel 'log₂(n)'
set ylabel 'running time / n log₂n in nanoseconds'

## MULTIPLOT(skew) SELECT log(2, n) x, avg(time)*1.0/(n*log(2, n))*1000000.0 AS y, MULTIPLOT
## FROM eval WHERE skew<3 OR skew=7 GROUP BY n, MULTIPLOT,x ORDER BY MULTIPLOT,x
plot \
    'comparison-data.txt' index 2 title "quicksort" with linespoints, \
    'comparison-data.txt' index 1 title "std::sort" with linespoints, \
    'comparison-data.txt' index 3 title "qsort 1:6" with linespoints, \
    'comparison-data.txt' index 0 title "ssssort" with linespoints
