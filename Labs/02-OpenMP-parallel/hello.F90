Program Hello

  use omp_lib
  
!$omp parallel
  print *,"Hello world!"
!$omp end parallel

end Program Hello
