#include "mpi.h"
#include <stdio.h>
#include <unistd.h>
int main(int argc, char *argv[]) {
  int  numtasks, rank, len, ierr;
  double t1,t2,my_sleep_time;
  char hostname[MPI_MAX_PROCESSOR_NAME];

  ierr = MPI_Init(&argc,&argv);
  MPI_Comm_size(MPI_COMM_WORLD,&numtasks);
  MPI_Comm_rank(MPI_COMM_WORLD,&rank);
  MPI_Get_processor_name(hostname, &len);
  printf("Number of tasks= %d ", numtasks);
  printf("My rank= %d Running on %s\n",rank,hostname);
  
  t1 = MPI_Wtime();
  sleep(2*(rank+1));
  t2 = MPI_Wtime();
  my_sleep_time = t2 - t1;
  printf ("My rank= %d Running on %s: Sleep %f\n",
          rank,hostname,my_sleep_time);
  
  MPI_Finalize();
}
