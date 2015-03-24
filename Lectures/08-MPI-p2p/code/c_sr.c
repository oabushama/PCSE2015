#include "mpi.h"
#include <stdio.h>
#include <unistd.h>
int main(int argc, char *argv[]) {
  int  numtasks, rank, len, ierr;
  double t1,t2,my_sleep_time;
  char hostname[MPI_MAX_PROCESSOR_NAME];
  int dest,src,tag1,tag2;
  MPI_Status Stat;
  double their_sleep_time;

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
  printf ("My rank= %d Running on %s:    My Sleep %f\n",
          rank,hostname,my_sleep_time);
  tag1 = 42;
  tag2 = 67;
  if (rank == 0){
    dest = 1; src = 1;
    MPI_Sendrecv (&my_sleep_time,1,MPI_DOUBLE,src,tag1, 
                  &their_sleep_time,1,MPI_DOUBLE,dest,tag2, 
                  MPI_COMM_WORLD,&Stat);
  } else if (rank == 1) {
    src = 0; dest = 0;
    MPI_Sendrecv (&my_sleep_time,1,MPI_DOUBLE,src,tag2, 
                  &their_sleep_time,1,MPI_DOUBLE,dest,tag1, 
                  MPI_COMM_WORLD,&Stat);
  }
  printf ("My rank= %d Running on %s: Their Sleep %f\n",
          rank,hostname,their_sleep_time);
  MPI_Finalize();
}
