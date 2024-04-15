#include <mpi.h> // MPI
#include <stdio.h>

int main(int argc, char *argv[]) {

  // Initialize MPI, get size and rank
  int size, rank;
  MPI_Init(&argc, &argv);
  MPI_Comm_size(MPI_COMM_WORLD, &size);
  MPI_Comm_rank(MPI_COMM_WORLD, &rank);

  // IMPLEMENT: Ring sum algorithm
  int sum = rank; // initialize sum
  printf("Process %i: Sum = %i\n", rank, sum);

  // ring sum
  int recvBuf[size];
  recvBuf[0] = rank;
  for(int i = 1; i < size; ++i){
    MPI_Send(&rank, 1, MPI_INT, (rank+i)%size, 42, MPI_COMM_WORLD);
    MPI_Recv(&recvBuf[i], 1, MPI_INT, MPI_ANY_SOURCE, MPI_ANY_TAG, MPI_COMM_WORLD);
    MPI_Barrier(MPI_COMM_WORLD);
    sum += recvBuf[i];
    printf("Process %i: Sum = %i\n", rank, sum);
  }

  MPI

  // Finalize MPI
  MPI_Finalize();

  return 0;
}
