#include <stdio.h>
#include "mpi.h"

int main(int argc, char* argv[]){
  
  int ierr, my_task_id, num_tasks;
  int on_mic;

  ierr = MPI_Init(&argc, &argv);
  

  MPI_Comm_rank(MPI_COMM_WORLD, &my_task_id);
  MPI_Comm_size(MPI_COMM_WORLD, &num_tasks);

  on_mic = 0; // false

#ifdef __MIC__
  on_mic = 1; // true
#endif

  if(on_mic) {
    printf("On MIC!  I am %d out of %d\n", my_task_id, num_tasks);
  }
  else {
    printf("On HOST! I am %d out of %d\n", my_task_id, num_tasks);
  }

  MPI_Finalize();

  return 0;
}
