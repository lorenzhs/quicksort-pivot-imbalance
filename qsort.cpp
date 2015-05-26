#include <algorithm>
#include <cassert>
#include <iostream>
#include "Timer.h"

#define BASECASE 16
#define likely(x) __builtin_expect((x), 1)
#define unlikely(x) __builtin_expect((x), 0)

static int skew = 2;

// sort integers [l..r]
template <typename T>
void qsort(T* __restrict__ a, int l, int r) {
	while (r-l > BASECASE) {
		T p(l+(r-l)/skew);
		int i(l), j(r);
		/*
		 * While nearly the same code seems is generated for both cases, GCC's
		 * optimizer handles the loop over i a lot better when it is separated
		 * from i's initialization by a jump, yielding a 2-3% improvement
		 */
		if (skew > 2)
			do {
				// skewed, left side is smaller
				while (unlikely(a[i] <= p)) i++;
				while (likely(a[j] > p)) --j;
				if (i <= j) {
					std::swap(a[i++], a[j--]);
				}
			} while (i <= j);
		else
			do {
				while (a[i] <= p) i++;
				while (a[j] > p) --j;
				if (i <= j) {
					std::swap(a[i++], a[j--]);
				}
			} while (i <= j);
		if (i <= l+(r-l)/2) {
			qsort(a, l, j);
			l = j;
		} else {
			qsort(a, i, r);
			r = i;
		}
	}
	// base case, use insertion sort
	if (l <= r)
		// +1 because it uses [begin, end) iterators (i.e., end is exclusive)
		std::__insertion_sort(a+l, a+r+1, __gnu_cxx::__ops::__iter_less_iter());
}

int main(int argc, char** argv) {
	Common::Timer timer;
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

	std::cout << "Initialization took " << timer.get() << "ms" << std::endl;
	std::shuffle(numbers, numbers + size, std::mt19937{std::random_device{}()});
	std::cout << "Initialization + Shuffling took " << timer.getAndReset() << "ms" << std::endl;

	if (skew == 0) {
		return 0;
	} else if (skew == 1) {
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
