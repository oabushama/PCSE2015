! Divide MPI_COMM_WORLD into two distinct Comms using 
! COMM_GROUP, GROUP_INCL, COMM_CREATE
program group
  use mpi
  implicit none
  integer, parameter :: NPROCS = 8
  integer rank, new_rank, sendbuf, recvbuf, numprocs
  integer color, new_comm, ierr

  call MPI_INIT(ierr)
  call MPI_COMM_RANK(MPI_COMM_WORLD, rank, ierr)
  call MPI_COMM_SIZE(MPI_COMM_WORLD, numprocs, ierr)

  if (numprocs .ne. NPROCS) then
    write(*,*)"Must specify NPROCS=",NPROCS," Terminating."
    call MPI_FINALIZE(ierr)
    stop
  endif

  sendbuf = rank
  

  ! Divide tasks into two distinct groups based upon rank
  if (rank .lt. NPROCS/2) then
    color = 1
  else 
    color = 2
  endif

  write(*,*)"(Rank ",rank,"): color: ",color
  call MPI_COMM_SPLIT(MPI_COMM_WORLD, color, rank, new_comm, ierr)
  call MPI_ALLREDUCE(sendbuf,recvbuf,1,MPI_INTEGER, &
                     MPI_SUM, new_comm, ierr)

  call MPI_COMM_RANK(new_comm, new_rank, ierr)
  write(*,*)"(Rank ",rank,"): newrank: ",new_rank," recvbuf: ",recvbuf

  call MPI_FINALIZE(ierr)
end program group
