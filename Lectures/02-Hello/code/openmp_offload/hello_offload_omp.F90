
program hello_omp
  use omp_lib
  implicit none 
  
  integer :: thread_id, num_threads
  logical :: on_mic

  on_mic = .false.

  !$omp target
    !$omp parallel private(thread_id)

#ifdef __MIC__ 
      on_mic = .true.
#endif
      
      num_threads = omp_get_num_threads()
      thread_id = omp_get_thread_num()
    
      if (on_mic) then
        write(*,*)"On the MIC!  I am ", thread_id, " out of ", num_threads
      else
        write(*,*)"On the HOST! I am ", thread_id, " out of ", num_threads
      end if 

    !$omp end parallel
  !$omp end target


  on_mic = .false.

  !$omp parallel private(thread_id)

#ifdef __MIC__ 
    on_mic = .true.
#endif
      
    num_threads = omp_get_num_threads()
    thread_id = omp_get_thread_num()
    
    if (on_mic) then
      write(*,*)"On the MIC!  I am ", thread_id, " out of ", num_threads
    else
      write(*,*)"On the HOST! I am ", thread_id, " out of ", num_threads
    end if 

  !$omp end parallel


end program hello_omp
