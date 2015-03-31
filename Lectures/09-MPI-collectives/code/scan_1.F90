program myscan
  use mpi
  implicit none
  integer sendbuf, recvbuf
  integer i, rank, numprocs, ierr
  recvbuf = 0

  call MPI_INIT(ierr)
  call MPI_COMM_RANK(MPI_COMM_WORLD, rank, ierr)
  call MPI_COMM_SIZE(MPI_COMM_WORLD, numprocs, ierr)

  sendbuf = rank

  ! All processes call MPI_SCAN
  call MPI_scan(sendbuf, recvbuf, 1, MPI_INTEGER, &
                MPI_SUM, MPI_COMM_WORLD, ierr)

  write(*,*)"(Rank ", rank ,"): recvbuf: ", recvbuf

  call MPI_FINALIZE(ierr)  
end program myscan
