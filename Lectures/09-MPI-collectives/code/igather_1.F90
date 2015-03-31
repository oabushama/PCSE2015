program igather
  use mpi
  implicit none
  integer, parameter :: SOME_MAX = 8
  integer sendbuf(2), recvbuf(SOME_MAX)
  integer req ! Request handle to query when transfer has completed
  integer stat(MPI_STATUS_SIZE) ! Holds information on function call
  integer i, rank, numprocs, root, ierr
  data root/3/
  recvbuf = 0

  call MPI_INIT(ierr)
  call MPI_COMM_RANK(MPI_COMM_WORLD, rank, ierr)
  call MPI_COMM_SIZE(MPI_COMM_WORLD, numprocs, ierr)

  do i = 1, 2 
    sendbuf(i) = (100 * rank) + rank + 1
  end do

  ! All processes call MPI_GATHER
  call MPI_IGATHER(sendbuf, 2, MPI_INTEGER, &
                  recvbuf, 2, MPI_INTEGER, &
                  root, MPI_COMM_WORLD, req, ierr)
  ! Potentially do work here
  call MPI_WAIT(req, stat, ierr) ! Wait until data has safely transferred

  write(*,*)"(Rank ", rank ,"): recvbuf: ", recvbuf

  call MPI_FINALIZE(ierr)  
end program igather
