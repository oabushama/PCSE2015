#include <stdio.h>
#include "mpi.h"
#define SOME_MAX 8
int main(int argc, char *argv[]){
  int sendbuf[2], recvbuf[SOME_MAX] = { 0 };
  int i, rank, numprocs;
  int root = 3;

  MPI_Init(&argc, &argv);
  MPI_Comm_size(MPI_COMM_WORLD, &numprocs);
  MPI_Comm_rank(MPI_COMM_WORLD, &rank);

  for(i = 0; i < 2; i++){
    sendbuf[i] = (100 * rank) + rank + 1;
  }

  // All processes call MPI_Scatter
  MPI_Gather(&sendbuf[0], 2, MPI_INT,
            &recvbuf[0], 2, MPI_INT,
            root, MPI_COMM_WORLD);

  printf("(Rank %i): recvbuf:", rank);
  for(i = 0; i < SOME_MAX; i++){
    printf(" %i",recvbuf[i]);
  } printf("\n");

  MPI_Finalize();
}
