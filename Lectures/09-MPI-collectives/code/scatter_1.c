#include <stdio.h>
#include <string.h> 
#include "mpi.h"
#define SOME_MAX 8
int main(int argc, char *argv[]){
  int sendbuf[SOME_MAX], recvbuf[2];
  int i, rank, numprocs;
  int root = 0;

  MPI_Init(&argc, &argv);
  MPI_Comm_size(MPI_COMM_WORLD, &numprocs);
  MPI_Comm_rank(MPI_COMM_WORLD, &rank);

  if (rank == root){
    for(i = 0; i < SOME_MAX; i++){
      sendbuf[i] = i;
    }
  }
  // All processes call MPI_Scatter
  MPI_Scatter(&sendbuf[0], 2, MPI_INT,
              &recvbuf[0], 2, MPI_INT,
              root, MPI_COMM_WORLD);
  printf("(Rank %i): recvbuf: %i %i\n",
         rank, recvbuf[0], recvbuf[1]);

  MPI_Finalize();
}
