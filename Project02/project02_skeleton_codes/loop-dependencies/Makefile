CC ?= gcc
CFLAGS = -O3 -fopenmp
LDFLAGS = -O3 -lm -fopenmp

all: recur_seq recur_omp

recur_seq: recur_seq.o walltime.o
	$(CC) $(LDFLAGS) $^ -o $@

recur_seq.o: recur_seq.c walltime.h
	$(CC) -c -O3 $<

recur_omp: recur_omp.c walltime.o
	$(CC) $(LDFLAGS) $^ -o $@

recur_omp.o: recur_omp.c walltime.h
	$(CC) -c $(CFLAGS) $<

walltime.o: walltime.c walltime.h
	$(CC) -c $<

clean:
	$(RM) *.o recur_seq recur_omp
