

#include <omp.h>
#include <stdio.h>

int main (int argc, char *argv[]){

  int thread_id, num_threads;
  int on_mic;

  on_mic = 0; // False

  #pragma omp target
  {
    #pragma omp parallel private(thread_id)
    {

#ifdef __MIC__
      on_mic = 1; // true
#endif

      num_threads = omp_get_num_threads();
      thread_id = omp_get_thread_num();

      if (on_mic) {  
         printf("On MIC!  I am %d of %d\n", thread_id, num_threads);
       }
       else {
         printf("On HOST! I am %d of %d\n", thread_id, num_threads);
      }
    } 
  }    

  on_mic = 0; // False

  #pragma omp parallel private(thread_id)
  {

#ifdef __MIC__
  on_mic = 1; // true
#endif

    num_threads = omp_get_num_threads();
    thread_id = omp_get_thread_num();

    if (on_mic) {  
       printf("On MIC!  I am %d of %d\n", thread_id, num_threads);
     }
     else {
       printf("On HOST! I am %d of %d\n", thread_id, num_threads);
    }
  } 
       
  return 0;

}

