## Quicksort Pivot Imbalance

What if, instead of choosing the "optimal" pivot (i.e. the median),
we were to knowingly choose a sub-optimal pivot in quicksort?

The answer lies in the depths of the CPU, more specifically, in its
branch prediction unit. If the pivot is the median, then there is
a 50% chance that the next element will belong to the left side of
the partition and a 50% chance that it will go right. In other words,
the branch predictor will have to guess, and it will be wrong half
of the time and will have to flush the pipeline. That costs a lot
of time—according to [toplev](https://github.com/andikleen/pmu-tools/),
the running time of quicksort and `std::sort` is dominated by branch
mispredictions! This means that on a micro-architectural level, the
CPU wastes half of its time on instructions that are never executed
and waiting for those that will be executed to move through the pipeline.

If, on the other hand, we choose the pivot so that only a quarter
of all elements will be on the left side of the partition, then
the CPU could guess "right" all the time and it could be right 75%
of the time in the best case, resulting in a significantly reduced
number of branch misses.

To show that this can, in fact, be faster, we use a completely
artificial "benchmark"—sorting a random permutation of the integers
0 to n-1. The input size n is specified as the first parameter, the
skew parameter as the second.

- 0 will do nothing (useful to measure initialization time)
- 1 will use `std::sort`
- s>1 will partition 1/s-th of the elements to the left and the other (s-1)/s-th elements to the right

Thus, a skew of 2 means equal partioning, 3 means 1/3rd left and 2/3rds right, etc.

On my machine (Haswell Core-i7 4790T), it seems that s=7 yields
the fastest running times. The detailed measurements are available
in [time.pdf](plots/time.pdf) for skew between 2 and 12 as well
as `std::sort` (all times are averaged over 10 iterations). In fact,
with s=7, the CPU only misses 13% of branches versus 30% for "perfect"
partitioning. For s=12, this further reduces to under 9%. However, the
additional work required to cope with the unbalanced partitioning
starts to show and increases total execution time compared to s=7.

All of this is not to say that we should suddenly use suboptimal pivot choices.
Not only would this imply overhead to find the skewed pivot in practice
(remember that we are getting the pivot for free in this contrived setting),
but it also just doesn't make sense. Instead, it might be worth striving for
branch-avoiding sorting algorithms where they are appropriate. This is
the rationale behind *Super Scalar Sample Sort* [1], which makes only
a constant number of *hard-to-predict branches*. This is illustrated by
the running time chart below, which features balanced quicksort, std::sort,
the fastest unbalanced quicksort, and super-scalar sample sort.

![comparison](/plots/comparison.png)

(This issue has been previously studied on the Prescott architecture in [2],
where due to the much longer pipeline (31 steps!), a skew of 11 proved optimal.
Nowadays, the pipeline comprises 14-19 steps, which explains the lower skew.)

## References
- [1] Peter Sanders, Sebastian Winkel: **Super Scalar Sample Sort**, ESA 2004. Technical
Report available [here](http://people.mpi-inf.mpg.de/~sanders/papers/ssss.ps.gz)
- [2] Kanela Kaligosi, Peter Sanders: **How Branch Mispredictions Affect Quicksort**, ESA 2006.
Available [here](http://algo2.iti.kit.edu/sanders/papers/KalSan06.pdf)
