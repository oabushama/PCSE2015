#include <stdio.h>
#include "mpi.h"
int main(int argc, char *argv[]){
  int sendbuf, recvbuf = 0 ;
  int i, rank, numprocs;

  MPI_Init(&argc, &argv);
  MPI_Comm_size(MPI_COMM_WORLD, &numprocs);
  MPI_Comm_rank(MPI_COMM_WORLD, &rank);

  sendbuf = rank;

  // All processes call MPI_Scan
  MPI_Scan(&sendbuf, &recvbuf, 1, MPI_INT,
           MPI_SUM, MPI_COMM_WORLD);

  printf("(Rank %i): recvbuf:", rank);
  printf(" %i",recvbuf);
  printf("\n");

  MPI_Finalize();
}
