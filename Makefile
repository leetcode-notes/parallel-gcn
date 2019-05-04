UNAME := $(shell uname)
ifeq ($(UNAME), Linux)
	CXX=/home/chengzef/intel/bin/icc
endif
ifeq ($(UNAME), Darwin)
        CXX=gcc
endif
#CXX=gcc
CXXFLAGS= -fopt-info-vec-optimized -O3 -std=c++11 -Wall -Wno-sign-compare -Wno-unused-variable -Wno-unknown-pragmas
LDFLAGS=-lm -lstdc++
CXXFILES=src/gcn.cpp src/optim.cpp src/module.cpp src/variable.cpp src/parser.cpp src/rand.cpp
HFILES=src/gcn.h src/optim.h src/module.h src/variable.h src/sparse.h src/parser.h src/rand.h src/timer.h
TEST_CXXFILES=test/module_test.cpp test/optim_test.cpp test/util.cpp
TEST_HFILES=test/util.h
OMP=-fopenmp -DOMP

#SIMD=-DSIMD
#SIMD=-mavx -march=native #-DSIMD
SIMD=-mavx -march=native -DSIMD
all: seq omp omp-simd

seq: src/main.cpp $(CXXFILES) $(HFILES)
	$(CXX) $(CXXFLAGS) -o gcn-seq $(CXXFILES) src/main.cpp $(LDFLAGS)

omp-simd: src/main.cpp $(CXXFILES) $(HFILES)
	$(CXX) $(CXXFLAGS) $(OMP) $(SIMD) -o gcn-omp-simd $(CXXFILES) src/main.cpp $(LDFLAGS)

omp: src/main.cpp $(CXXFILES) $(HFILES)
	$(CXX) -fno-tree-vectorize $(CXXFLAGS) $(OMP) -o gcn-omp $(CXXFILES) src/main.cpp $(LDFLAGS)




test: $(CXXFILES) $(HFILES) $(TEST_CXXFILES) $(TEST_HFILES)
	$(CXX) $(CXXFLAGS) -Iinclude -o gcn-test $(CXXFILES) $(TEST_CXXFILES) test/main.cpp $(LDFLAGS)
