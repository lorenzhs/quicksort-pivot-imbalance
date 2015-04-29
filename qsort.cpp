#include <algorithm>
#include <cassert>
#include <iostream>
#include "../common/Common/Timer.h"

#define BASECASE 16

static int skew = 2;

// sort integers [l..r]
void qsort(int* a, int l, int r) {
	while (r-l > BASECASE) {
		int p(l+(r-l)/skew), i(l), j(r);
		do {
			while (a[i] <= p) i++;
			while (a[j] > p) j--;
			if (i <= j) {
				int tmp = a[i];
				a[i++] = a[j];
				a[j--] = tmp;
			}
		} while (i <= j);
		if (i < (l+r)/2) {
			qsort(a, l, j);
			l = j;
		} else {
			qsort(a, i, r);
			r = i;
		}
	}
	// base case, use insertion sort
	if (l <= r)
		std::__insertion_sort(a+l, a+r+1, __gnu_cxx::__ops::__iter_less_iter());
}

int main(int argc, char** argv) {
	int size = 100000;
	if (argc > 1) {
		size = atoi(argv[1]);
	}
	if (argc > 2) {
		skew = atoi(argv[2]);
	}
	std::cout << "Sorting " << size << " numbers, skew = 1/" << skew << std::endl;

	int* numbers = new int[size];
	for (int i = 0; i < size; ++i) numbers[i] = i;

	Common::Timer timer;
	std::shuffle(numbers, numbers + size, std::mt19937{std::random_device{}()});
	std::cout << "Shuffling took " << timer.getAndReset() << "ms" << std::endl;

	if (skew < 2) {
		std::sort(numbers, numbers + size);
		std::cout << "std::sort";
	} else {
		qsort(numbers, 0, size-1);
		auto t = timer.get();
		std::cout << "qsort";
	}
	auto t = timer.get();
	std::cout << " took " << t << "ms" << std::endl;

#ifndef NDEBUG
	bool ok = true;
	for (int i = 0; i < size && ok; ++i) {
		if (numbers[i] != i) ok=false;
	}
	if (ok)
		std::cout << "Verified: OK" << std::endl;
	else
		std::cout << "Numbers were not sorted!" << std::endl;
#endif

	std::cout << "RESULT n=" << size << " skew=" << skew << " time=" << t << std::endl;
	delete[] numbers;
}