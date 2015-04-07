#include <mpi.h>
#include <stdio.h>
int main(int argc, char *argv[])  {
  int i, rank, numprocs;
  int buf, size, displacement, intsize;
  int target_rank, target_disp, target_cnt;
  MPI_Info info;
  MPI_Win win;
  
  intsize = sizeof(int);
  
  MPI_Init(&argc,&argv);
  MPI_Comm_rank(MPI_COMM_WORLD, &rank);
  MPI_Comm_size(MPI_COMM_WORLD, &numprocs);

  if(rank == 0){
    // Everyone will retrieve from a buffer on root
    buf = 42; size = intsize; displacement = intsize; MPI_Info_create(&info);
  }
  else {
    // Others only retrieve, so these windows can be size 0
    buf = 0; size = 0; displacement = intsize; info = MPI_INFO_NULL;
  }

  // Print buf before RMA calls
  for(i = 0; i < numprocs; i++){
    if(rank == i){
      printf("(Rank %i): buf: %i\n",rank,buf);
    }
    MPI_Barrier(MPI_COMM_WORLD);
  }

  // Create a Window for RMA calls
  MPI_Win_create(&buf,size,displacement,info,MPI_COMM_WORLD,&win); 
  
  // No local operations prior to this epoch, so give an assertion
  MPI_Win_fence(MPI_MODE_NOPRECEDE,win);
  
  if(rank != 0){
    target_rank = 0; target_disp = 0; target_cnt = intsize;
    // Inside the fence, make RMA calls to GET from rank 0
    MPI_Get(&buf,1,MPI_INT,
            target_rank,target_disp,target_cnt,
            MPI_INT,win);
  }
  else printf("\nUsing MPI_Win_create and MPI_Get to fill buf from %i...\n\n",rank);
  
  // Complete the epoch - this will block until MPI_Get is complete
  MPI_Win_fence(0,win); // Using no assertions
  
  // All done with the window - tell MPI there are no more epochs
  MPI_Win_fence(MPI_MODE_NOSUCCEED,win);
  
  // Free up our window
  MPI_Win_free(&win);

  // Print buf after RMA calls
  for(i = 0; i < numprocs; i++){
    if(rank == i){
      printf("(Rank %i): buf: %i\n",rank,buf);
    }
    MPI_Barrier(MPI_COMM_WORLD);
  }
  MPI_Finalize();
}
