
program hello_omp
  use omp_lib
  implicit none 
  
  integer :: thread_id, num_threads

  !$omp parallel private(thread_id)
    
    num_threads = omp_get_num_threads()
    thread_id = omp_get_thread_num()

    write(*,*)"Hello World! I am ", thread_id, " out of ", num_threads

  !$omp end parallel

end program hello_omp
