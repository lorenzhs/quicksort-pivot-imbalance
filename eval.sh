#!/bin/zsh

for s in {14..26}; do
	n=$((2**$s));
	echo -n "evaluating n=$n, skew = "
	for skew in {1..12}; do
		echo -n "$skew… "
		for it in {1..10}; do
			./plog.sh ./qsort $n $skew >> qsort.log
		done
	done;
	echo "";
done;
