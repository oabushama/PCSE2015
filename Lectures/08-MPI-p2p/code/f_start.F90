program simple
   use mpi
   implicit none
   integer numtasks, rank, len, ierr, errorcode
   character(MPI_MAX_PROCESSOR_NAME) hostname
   double precision t1,t2,my_sleep_time

   call MPI_INIT(ierr)
   call MPI_COMM_RANK(MPI_COMM_WORLD, rank, ierr)
   call MPI_COMM_SIZE(MPI_COMM_WORLD, numtasks, ierr)
   call MPI_GET_PROCESSOR_NAME(hostname, len, ierr)
   write(*,*)"Number of tasks=",numtasks," My rank=",rank, &
   &        " Running on=",trim(hostname)
  
  t1 = MPI_WTIME()
  call sleep(2*(rank+1))
  t2 = MPI_WTIME()
  my_sleep_time = t2 - t1
  write(*,*)"My rank=",rank," Running on ",trim(hostname), &
  &         ": Sleep",my_sleep_time

  call MPI_FINALIZE(ierr)
end program simple
