/****************************************************************
 *
 * This program file is part of 
 * `Parallel Computing for Science and Engineering'
 * by Victor Eijkhout, copyright 2012/3/4/5
 *
 * pi11.c : pi calculation with adaptive integration
 *
 ****************************************************************/

#include <stdlib.h>
#include <stdio.h>
#include <math.h>
#include <omp.h>

int main(int argc,char **arg) {

  int nsteps=100000000; // that's a million
  double tstart,tend,elapsed, pi,quarterpi,h;
  int i,nsamples=0;
  
  tstart = omp_get_wtime(); //gettime();
  quarterpi = 0.; h = 1./nsteps;
  for (i=0; i<nsteps; i++) {
    double
      x = i*h,x2 = (i+1)*h,
      y = sqrt(1-x*x),y2 = sqrt(1-x2*x2),
      slope = (y-y2)/h;
    if (slope>15) slope = 15;
    int
      samples = 1+(int)slope,
      is;
    for (is=0; is<samples; is++) {
      double
	hs = h/samples,
	xs = x+ is*hs,
	ys = sqrt(1-xs*xs);
      quarterpi += hs*ys;
      nsamples++;
    }
  }
  pi = 4*quarterpi;
  tend = omp_get_wtime(); //gettime();
  elapsed = tend-tstart;
  printf("Computed pi=%e in %6.3f seconds with %d samples\n",pi,elapsed,nsamples);
  
  return 0;
}
