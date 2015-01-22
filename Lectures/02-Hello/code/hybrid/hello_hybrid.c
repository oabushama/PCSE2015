

#include <stdio.h>
#include "mpi.h"

int main(int argc, char* argv[]){

  int ierr, my_task_id, num_mpi_tasks;
  int thread_id, num_omp_threads;

  ierr = MPI_Init(&argc, &argv);


  MPI_Comm_rank(MPI_COMM_WORLD, &my_task_id);
  MPI_Comm_size(MPI_COMM_WORLD, &num_mpi_tasks);

  #pragma omp parallel private(thread_id)
  {
    num_omp_threads = omp_get_num_threads();
    thread_id = omp_get_thread_num();
  
    printf("Thread %d out of %d OpenMP threads; MPI task %d out of %d MPI tasks.\n", 
           thread_id, num_omp_threads, my_task_id, num_mpi_tasks);
  }
 
  MPI_Finalize();

  return 0;
}

