/****************************************************************
 *
 * This program file is part of 
 * `Parallel Computing for Science and Engineering'
 * by Victor Eijkhout, copyright 2012/3/4/5
 *
 * pi1.c : initial file for the lab about loop computing
 *
 ****************************************************************/

#include <stdlib.h>
#include <stdio.h>
#include <math.h>
#include <omp.h>

int main(int argc,char **arg) {

  int nsteps=1000000000; // that's one billion
  double tstart,tend,elapsed, pi,quarterpi,h;
  int i;
  
  tstart = omp_get_wtime(); //gettime();
  quarterpi = 0.; h = 1./nsteps;
  for (i=0; i<nsteps; i++) {
    double
      x = i*h,
      y = sqrt(1-x*x);
    quarterpi += h*y;
  }
  pi = 4*quarterpi;
  tend = omp_get_wtime(); //gettime();
  elapsed = tend-tstart;
  printf("Computed pi=%e in %6.3f seconds\n",pi,elapsed);
  
  return 0;
}
