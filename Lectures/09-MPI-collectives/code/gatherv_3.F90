program gatherv3
  use mpi
  implicit none
  integer, parameter :: NPROCS = 4
  integer, parameter :: SOME_MAX = 13
  integer sendbuf(NPROCS), recvbuf(SOME_MAX)
  integer recvcount(NPROCS)    ! Num of elements received from each process
  integer displacement(NPROCS) ! place data from process i at recvbuf(displacement(i))
  integer i, rank, numprocs, root, ierr
  data root/3/
  recvbuf = 0
  call MPI_INIT(ierr)
  call MPI_COMM_RANK(MPI_COMM_WORLD, rank, ierr)
  call MPI_COMM_SIZE(MPI_COMM_WORLD, numprocs, ierr)
  do i = 1, NPROCS
    sendbuf(i) = (100 * rank) + rank + 1
  end do
  ! recvbuf, recvcounts, displs, recvtype are significant
  ! for the root process only.
  if(rank == root)then
    do i = 1, numprocs
      recvcount(i)    = i ! Recv i=rank elements from each process
      displacement(i) = sum(recvcount(1:i))-1 ! offset based on sum
    end do
  end if

  call MPI_GATHERV(sendbuf, rank+1, MPI_INTEGER, &
                   recvbuf, recvcount, displacement, MPI_INTEGER, &
                   root, MPI_COMM_WORLD, ierr)

  write(*,*)"(Rank ", rank ,"): recvbuf: ", recvbuf
  call MPI_FINALIZE(ierr)  
end program gatherv3
