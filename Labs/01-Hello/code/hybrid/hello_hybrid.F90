

program hello_hybrid
  use mpi
  use omp_lib
  implicit none

  integer :: ierr, my_task_id, num_mpi_tasks
  integer :: thread_id, num_omp_threads

  call mpi_init(ierr)

  call mpi_comm_rank(MPI_COMM_WORLD, my_task_id, ierr)
  call mpi_comm_size(MPI_COMM_WORLD, num_mpi_tasks,  ierr)

  !$omp parallel private(thread_id)

    num_omp_threads = omp_get_num_threads()
    thread_id = omp_get_thread_num()
   
    write(*,"(4(a,i3),a)") &
              "Thread ", thread_id, &
              " out of ", num_omp_threads, &
              " OpenMP threads; MPI task ", my_task_id, &
              " out of ", num_mpi_tasks, " MPI tasks."

  !$omp end parallel

  call mpi_finalize(ierr)

end program hello_hybrid
