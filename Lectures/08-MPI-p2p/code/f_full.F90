program simple
   use mpi
   implicit none
   integer numtasks, rank, len, ierr, errorcode
   character(MPI_MAX_PROCESSOR_NAME) hostname
   double precision t1,t2,my_sleep_time
   integer dest,src,tag1,tag2
   integer stat(MPI_STATUS_SIZE)
   double precision their_sleep_time

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
  &         ":    My Sleep",my_sleep_time
  tag1 = 42
  tag2 = 67
  if (rank == 0) then
    dest = 1; src = 1
    call MPI_SEND(my_sleep_time,1, MPI_DOUBLE_PRECISION,dest, &
    &             tag1,MPI_COMM_WORLD,ierr)  
    call MPI_RECV(their_sleep_time,1,MPI_DOUBLE_PRECISION,src, &
    &             tag2,MPI_COMM_WORLD,stat,ierr)
  else if (rank == 1) then
    src = 0; dest = 0
    call MPI_RECV(their_sleep_time,1,MPI_DOUBLE_PRECISION,src, &
    &             tag1,MPI_COMM_WORLD,stat,ierr)
    call MPI_SEND(my_sleep_time,1, MPI_DOUBLE_PRECISION,dest, &
    &             tag2,MPI_COMM_WORLD,ierr)  
  end if
  write(*,*)"My rank=",rank," Running on ",trim(hostname), &
  &         ": Their Sleep",their_sleep_time
  

  call MPI_FINALIZE(ierr)
end program simple
