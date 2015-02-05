!****************************************************************
!
! This program file is part of 
! `Parallel Computing for Science and Engineering'
! by Victor Eijkhout, copyright 2012/3/4/5
!
! pi1.F90 : initial file for the lab about loop computing
!
!****************************************************************

Program PI1

  use omp_lib

  integer :: nsteps=1000000000 ! that's one billion
  double precision :: tstart,tend,elapsed, pi,quarterpi,h
  integer :: i
  double precision :: x,y
  
  tstart = omp_get_wtime()
  quarterpi = 0.; h = 1./nsteps

  do i=1,nsteps
     x = i*h; y = sqrt(1-x*x)
     quarterpi = quarterpi + h*y
  end do

  pi = 4*quarterpi
  tend = omp_get_wtime()
  elapsed = tend-tstart
  print *,"Computed pi=",pi,"in t=",elapsed
  
end Program PI1
