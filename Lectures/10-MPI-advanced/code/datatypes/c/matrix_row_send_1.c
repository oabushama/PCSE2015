// Default way of sending continguous one row of 2D array
#include "mpi.h"
#include <stdio.h>
#define NROWS 3
#define NCOLS 4
int main(int argc, char *argv[]) {
  int  numprocs, rank, len, ierr;
  int i,j,k,dest,src,tag1,row;
  double matrix[NROWS][NCOLS] = { 0 };
  MPI_Status Stat;

  MPI_Init(&argc,&argv);
  MPI_Comm_size(MPI_COMM_WORLD,&numprocs);
  MPI_Comm_rank(MPI_COMM_WORLD,&rank);

  // Initialize matrix on process 0 only 
  if (rank == 0){ 
    for(i = 0; i < NROWS; i++){
      for(j = 0; j < NCOLS; j++){
        matrix[i][j] = NROWS * i + i + j;
      }
    }
  }

  // Print matrix before Send/Recv
  for(k = 0; k < numprocs; k++){ 
    if(rank == k){
      printf("(Rank %i): Matrix:\n",rank);
      for(i = 0; i < NROWS; i++){
        for(j = 0; j < NCOLS; j++){
          printf(" %3.0f",matrix[i][j]);
        }
        printf("\n");
      }
    }
    MPI_Barrier(MPI_COMM_WORLD);
  }
  // Send/Recv
  tag1 = 1; dest=1; src=0; row=1;
  if(rank == 0) {
    printf("\nCompleting Send/Recv from");
    printf(" %i to %i of row %i...\n\n",src,dest,row);
  }
  if(rank == 0){
    MPI_Send(&matrix[row][0],NCOLS,MPI_DOUBLE,dest,tag1,MPI_COMM_WORLD);
  }
  if(rank == 1){
    MPI_Recv(&matrix[row][0],NCOLS,MPI_DOUBLE,src,tag1,MPI_COMM_WORLD,&Stat);
  }
  
  // Print matrix after Send/Recv
  for(k = 0; k < numprocs; k++){ 
    if(rank == k){
      printf("(Rank %i): Matrix:\n",rank);
      for(i = 0; i < NROWS; i++){
        for(j = 0; j < NCOLS; j++){
          printf(" %3.0f",matrix[i][j]);
        }
        printf("\n");
      }
    }
    MPI_Barrier(MPI_COMM_WORLD);
  }
  MPI_Finalize();
}
