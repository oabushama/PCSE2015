! Divide MPI_COMM_WORLD into two distinct Comms using 
! COMM_GROUP, GROUP_INCL, COMM_CREATE
program group
  use mpi
  implicit none
  integer, parameter :: NPROCS = 8
  integer rank, new_rank, sendbuf, recvbuf, numprocs
  integer ranks1(4), ranks2(4), ierr
  integer orig_group, new_group, new_comm
  data ranks1 /0, 1, 2, 3/, ranks2 /4, 5, 6, 7/

  call MPI_INIT(ierr)
  call MPI_COMM_RANK(MPI_COMM_WORLD, rank, ierr)
  call MPI_COMM_SIZE(MPI_COMM_WORLD, numprocs, ierr)

  if (numprocs .ne. NPROCS) then
    write(*,*)"Must specify NPROCS=",NPROCS," Terminating."
    call MPI_FINALIZE(ierr)
    stop
  endif

  sendbuf = rank

  ! Extract the original group handle
  call MPI_COMM_GROUP(MPI_COMM_WORLD, orig_group, ierr)

  ! Divide tasks into two distinct groups based upon rank
  if (rank .lt. NPROCS/2) then
    call MPI_GROUP_INCL(orig_group,NPROCS/2,ranks1,new_group,ierr)
  else 
    call MPI_GROUP_INCL(orig_group,NPROCS/2,ranks2,new_group,ierr)
  endif

  call MPI_COMM_CREATE(MPI_COMM_WORLD,new_group,new_comm,ierr)
  call MPI_ALLREDUCE(sendbuf,recvbuf,1,MPI_INTEGER, &
                     MPI_SUM, new_comm, ierr)

  call MPI_GROUP_RANK(new_group, new_rank, ierr)
  write(*,*)"(Rank ",rank,"): newrank: ",new_rank," recvbuf: ",recvbuf

  call MPI_FINALIZE(ierr)
end program group
