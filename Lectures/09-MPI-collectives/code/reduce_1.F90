program reduce
  use mpi
  implicit none
  integer, parameter :: SOME_MAX = 8
  integer sendbuf, recvbuf
  integer i, rank, numprocs, root, ierr
  data root/3/
  recvbuf = 0

  call MPI_INIT(ierr)
  call MPI_COMM_RANK(MPI_COMM_WORLD, rank, ierr)
  call MPI_COMM_SIZE(MPI_COMM_WORLD, numprocs, ierr)

  sendbuf = rank

  ! All processes call MPI_REDUCE
  call MPI_REDUCE(sendbuf, recvbuf, 1, MPI_INTEGER, &
                  MPI_SUM, root, MPI_COMM_WORLD, ierr)

  write(*,*)"(Rank ", rank ,"): recvbuf: ", recvbuf

  call MPI_FINALIZE(ierr)  
end program reduce
