CXX ?= g++

.PHONY: qsort qsortDebug

all: qsort

qsort: qsort.cpp
	${CXX} -Ofast -DNDEBUG -std=c++11 -g -o qsort qsort.cpp 

qsortDebug: qsort.cpp
	${CXX} -O0 -std=c++11 -ggdb -o qsort qsort.cpp

