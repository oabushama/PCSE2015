// Using MPI_Type_contiguous to send one row of 2D array to 1D array
#include "mpi.h"
#include <stdio.h>
#define NROWS 3
#define NCOLS 4
int main(int argc, char *argv[]) {
  int  numprocs, rank, len, ierr;
  int i,j,k,dest,src,tag1,row;
  double matrix[NROWS][NCOLS] = { 0 };
  double vector[NCOLS] = { 0 };
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
  // Print vector before Send/Recv
  for(k = 0; k < numprocs; k++){ 
    if(rank == k){
      printf("(Rank %i): Row Vector:\n",rank);
      for(i = 0; i < NCOLS; i++){
        printf(" %3.0f",vector[i]);
      }
      printf("\n");
    }
    MPI_Barrier(MPI_COMM_WORLD);
  }
  // Create derived contiguous type
  MPI_Datatype MY_MPI_ROW;
  MPI_Type_contiguous(NCOLS,MPI_DOUBLE,&MY_MPI_ROW);
  MPI_Type_commit(&MY_MPI_ROW);
  // Send/Recv
  tag1 = 1; dest=1; src=0; row=1;
  if(rank == 0) {
    printf("\nCompleting Send/Recv from");
    printf(" %i to %i of row %i...\n\n",src,dest,row);
  }
  if(rank == 0){
    MPI_Send(&matrix[row][0],1,MY_MPI_ROW,dest,tag1,MPI_COMM_WORLD);
  }
  if(rank == 1){
    MPI_Recv(&vector[0],NCOLS,MPI_DOUBLE,src,tag1,MPI_COMM_WORLD,&Stat);
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
  // Print vector after Send/Recv
  for(k = 0; k < numprocs; k++){ 
    if(rank == k){
      printf("(Rank %i): Row Vector:\n",rank);
      for(i = 0; i < NCOLS; i++){
        printf(" %3.0f",vector[i]);
      }
      printf("\n");
    }
    MPI_Barrier(MPI_COMM_WORLD);
  }
  MPI_Finalize();
}
