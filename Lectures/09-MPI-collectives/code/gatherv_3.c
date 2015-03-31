#include <stdio.h>
#include "mpi.h"
#define SOME_MAX 13
#define NPROCS 4
int main(int argc, char *argv[]){
  int sendbuf[NPROCS], recvbuf[SOME_MAX] = { 0 };
  int recvcount[NPROCS]; // Num of elements received from each process
  int displacement[NPROCS]; // Place data from process i at recvbuf[displacement[i]]
  int i, rank, numprocs, sum;
  int root = 3;
  MPI_Init(&argc, &argv);
  MPI_Comm_size(MPI_COMM_WORLD, &numprocs);
  MPI_Comm_rank(MPI_COMM_WORLD, &rank);
  for(i = 0; i < NPROCS; i++){
    sendbuf[i] = (100 * rank) + rank + 1;
  }
  // recvbuf, recvcounts, displacement, recvtype are
  // significant for the root process only.
  if(rank == root){
    for(i = 0; i < numprocs; i++){
      recvcount[i] = (i+1); // Recv i=rank elements from each process
      sum += (i+1); displacement[i] = sum-1 ; // Offset based on sum
  } } // squish

  // All processes call MPI_Scatter
  MPI_Gatherv(&sendbuf[0], rank+1, MPI_INT,
              &recvbuf[0], recvcount, displacement, MPI_INT,
              root, MPI_COMM_WORLD);

  printf("(Rank %i): recvbuf:", rank);
  for(i = 0; i < SOME_MAX; i++){
    printf(" %i",recvbuf[i]);
  } printf("\n");
  MPI_Finalize();
}
