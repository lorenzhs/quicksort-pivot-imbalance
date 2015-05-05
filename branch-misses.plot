# IMPORT-DATA eval qsort.log

set terminal pdf size 20cm,15cm linewidth 2.0
set pointsize 0.5
set output "branch-misses.pdf"

set grid xtics ytics

set key top left
set yrange [0.23:0.54]

set title 'Sorting a random permutation of the integers 0..n-1'
set xlabel 'log₂(n)'
set ylabel 'branch misses / n log₂n'

## MULTIPLOT(skew) SELECT log(2, n) x, avg(branch_misses)/(n*log(2,n)) AS y, MULTIPLOT
## FROM eval GROUP BY n, MULTIPLOT,x ORDER BY MULTIPLOT,x
plot \
    'branch-misses-data.txt' index 0 title "std::sort" with linespoints, \
    'branch-misses-data.txt' index 1 title "skew=2" with linespoints, \
    'branch-misses-data.txt' index 2 title "skew=3" with linespoints, \
    'branch-misses-data.txt' index 3 title "skew=4" with linespoints, \
    'branch-misses-data.txt' index 4 title "skew=5" with linespoints, \
    'branch-misses-data.txt' index 5 title "skew=6" with linespoints, \
    'branch-misses-data.txt' index 6 title "skew=7" with linespoints, \
    'branch-misses-data.txt' index 7 title "skew=8" with linespoints, \
    'branch-misses-data.txt' index 8 title "skew=9" with linespoints, \
    'branch-misses-data.txt' index 9 title "skew=10" with linespoints, \
    'branch-misses-data.txt' index 10 title "skew=11" with linespoints, \
    'branch-misses-data.txt' index 11 title "skew=12" with linespoints
