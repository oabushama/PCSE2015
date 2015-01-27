
program hello_mpi
  use mpi
  implicit none 
  
  integer :: ierr, my_task_id, num_tasks
  logical :: on_mic

  call MPI_init(ierr)
 
  call MPI_Comm_rank(MPI_COMM_WORLD, my_task_id, ierr)
  call MPI_Comm_size(MPI_COMM_WORLD, num_tasks,  ierr)
  
  on_mic = .false.

#ifdef __MIC__
  on_mic = .true.
#endif

  if (on_mic) then
    write(*,*)"On the MIC!  I am ", my_task_id, " out of ", num_tasks
  else
    write(*,*)"On the HOST! I am ", my_task_id, " out of ", num_tasks
  end if
   

  call MPI_Finalize(ierr)

end program hello_mpi
