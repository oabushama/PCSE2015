

#include <omp.h>
#include <stdio.h>

int main (int argc, char *argv[]){

  int thread_id, num_threads;

  #pragma omp parallel private(thread_id)
  {
    num_threads = omp_get_num_threads();
    thread_id = omp_get_thread_num();

    printf("Hello World! I am %d of %d\n", thread_id, num_threads);
  }

  return 0;

}

