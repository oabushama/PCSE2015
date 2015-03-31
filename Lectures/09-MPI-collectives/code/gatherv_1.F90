program gatherv1
  use mpi
  implicit none
  integer, parameter :: NPROCS = 4
  integer, parameter :: SOME_MAX = 8
  integer sendbuf(2), recvbuf(SOME_MAX)
  integer recvcount(NPROCS)    ! Num of elements received from each process
  integer displacement(NPROCS) ! place data from process i at recvbuf(displacement(i))
  integer i, rank, numprocs, root, ierr
  data root/3/
  recvbuf = 0
  call MPI_INIT(ierr)
  call MPI_COMM_RANK(MPI_COMM_WORLD, rank, ierr)
  call MPI_COMM_SIZE(MPI_COMM_WORLD, numprocs, ierr)
  do i = 1, 2 
    sendbuf(i) = (100 * rank) + rank + 1
  end do
  ! recvbuf, recvcounts, displacement, recvtype are
  ! significant for the root process only.
  if(rank == root)then
    do i = 1, numprocs
      recvcount(i)    = 2 ! Recv 2 elements from each process
      displacement(i) = 2 * (i-1) ! Skip 2 elements
    end do
  end if

  call MPI_GATHERV(sendbuf, 2, MPI_INTEGER, &
                   recvbuf, recvcount, displacement, MPI_INTEGER, &
                   root, MPI_COMM_WORLD, ierr)

  write(*,*)"(Rank ", rank ,"): recvbuf: ", recvbuf
  call MPI_FINALIZE(ierr)  
end program gatherv1
