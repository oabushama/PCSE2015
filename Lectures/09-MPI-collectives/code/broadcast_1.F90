program broadcast
  use mpi
  implicit none
  character(13) message 
  integer rank, root, ierr
  data root/0/ 

  call MPI_INIT(ierr)
  call MPI_COMM_RANK(MPI_COMM_WORLD, rank, ierr) 
  if (rank .eq. root) then ! root can be any valid process
      message = "Hello, World!" ! len 13
  endif 
  call MPI_BCAST(message, 13, MPI_CHARACTER, root, &
           MPI_COMM_WORLD, ierr) 
  write(*,*)"(Rank ", rank, "): Message received: ", message 
  call MPI_FINALIZE(ierr)
end program broadcast
