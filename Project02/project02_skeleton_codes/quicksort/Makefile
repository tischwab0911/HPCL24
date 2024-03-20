CC     = gcc
CFLAGS = -O3 -fopenmp

all: quicksort quicksort_omp

quicksort_omp: quicksort_omp.o walltime.o
	$(CC) $(CFLAGS) $^ -o $@

quicksort_omp.o: quicksort_omp.c walltime.h
	$(CC) -c $(CFLAGS) $<

quicksort: quicksort.o walltime.o
	$(CC) $(CFLAGS) $^ -o $@

quicksort.o: quicksort.c walltime.h
	$(CC) -c $(CFLAGS) $<

walltime.o: walltime.c walltime.h
	$(CC) -c $(CFLAGS) $<

.PHONY: clean
clean:
	$(RM) *.o quicksort quicksort_omp
