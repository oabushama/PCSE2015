program scatter
  use mpi
  implicit none
  integer, parameter :: SOME_MAX=8
  integer sendbuf(SOME_MAX), recvbuf(2)
  integer i, rank, numprocs, root, ierr
  data root/0/

  call MPI_INIT(ierr)
  call MPI_COMM_RANK(MPI_COMM_WORLD, rank, ierr)
  call MPI_COMM_SIZE(MPI_COMM_WORLD, numprocs, ierr)

  if(rank .eq. root) then
    do i = 1, SOME_MAX 
       sendbuf(i) = i-1
    end do
  endif

  ! All processes call MPI_SCATTER
  call MPI_SCATTER(sendbuf, 2, MPI_INTEGER, &
                   recvbuf, 2, MPI_INTEGER, &
                   root, MPI_COMM_WORLD, ierr)

  print *, "(Rank ", rank ,"): recvbuf: ", recvbuf

  call MPI_FINALIZE(ierr)  
end program scatter
