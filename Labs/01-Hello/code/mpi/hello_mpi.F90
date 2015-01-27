
program hello_mpi
  use mpi
  implicit none 
  
  integer :: ierr, my_task_id, num_tasks

  call MPI_init(ierr)

 
  call MPI_Comm_rank(MPI_COMM_WORLD, my_task_id, ierr)
  call MPI_Comm_size(MPI_COMM_WORLD, num_tasks,  ierr)

  write(*,*)"Hello World! I am ", my_task_id, " out of ", num_tasks

  call MPI_Finalize(ierr)

end program hello_mpi
