#include <stdio.h>
#include "mpi.h"

int main(int argc, char* argv[]){
  
  int ierr, my_task_id, num_tasks;

  ierr = MPI_Init(&argc, &argv);
  

  MPI_Comm_rank(MPI_COMM_WORLD, &my_task_id);
  MPI_Comm_size(MPI_COMM_WORLD, &num_tasks);

  printf("Hello World! I am %d out of %d\n", my_task_id, num_tasks);

  MPI_Finalize();

  return 0;
}
