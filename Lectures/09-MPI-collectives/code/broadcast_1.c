#include <stdio.h>
#include <string.h> 
#include "mpi.h"
int main(int argc, char *argv[]){
  char message[14];
  int rank, size;
  int root = 0;

  MPI_Init(&argc, &argv);
  MPI_Comm_size(MPI_COMM_WORLD, &size);
  MPI_Comm_rank(MPI_COMM_WORLD, &rank);

  if (rank == root){ // root can be any valid process
    strcpy(message, "Hello, world!"); // len 13
  } // don't forget the null terminated character
  MPI_Bcast(&message[0], 14, MPI_CHAR, root, MPI_COMM_WORLD);
  printf( "(Rank %i): Message received: %s\n", rank, message);

  MPI_Finalize();
}
