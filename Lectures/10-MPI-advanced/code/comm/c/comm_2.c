#include <mpi.h>
#include <stdio.h>
#include <stdlib.h>
#define NPROCS 8

int main(int argc, char *argv[])  {
  int rank, new_rank, sendbuf, recvbuf, numprocs, color;
  MPI_Comm new_comm;
  
  MPI_Init(&argc,&argv);
  MPI_Comm_rank(MPI_COMM_WORLD, &rank);
  MPI_Comm_size(MPI_COMM_WORLD, &numprocs);
  
  if (numprocs != NPROCS) {
    printf("Must specify NPROCS= %i. Terminating.\n",NPROCS);
    MPI_Finalize();
    exit(0);
  }
  
  sendbuf = rank;
  
  // Divide tasks into two distinct colors based upon rank
  if (rank < NPROCS/2) { color = 1; }
  else { color = 2; }
  
  // Create new new communicator and then perform collective communications
  printf("(Rank %i): color: %i\n",rank,color);
  MPI_Comm_split(MPI_COMM_WORLD, color, rank, &new_comm);
  MPI_Allreduce(&sendbuf, &recvbuf, 1, MPI_INT, MPI_SUM, new_comm);
  
  MPI_Comm_rank(new_comm, &new_rank);
  printf("(Rank %i): newrank: %i recvbuf: %i\n",rank,new_rank,recvbuf);
  
  MPI_Finalize();
}
