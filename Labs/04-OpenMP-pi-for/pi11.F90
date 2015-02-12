! -*- f90 -*-
!****************************************************************
!
! This program file is part of 
! `Parallel Computing for Science and Engineering'
! by Victor Eijkhout, copyright 2012/3/4/5
!
! pi11.F90 : pi calculation with adaptive integration
!
!****************************************************************

Program PI1

  use omp_lib
  implicit none

  integer :: nsteps=100000000 ! that's a hundred million
  double precision :: tstart,tend,elapsed, pi,quarterpi
  integer :: i,is,nsamples,samples
  double precision :: h,x,y,x2,y2,xs,ys,hs,slope
  
  tstart = omp_get_wtime()
  quarterpi = 0.; h = 1./nsteps; nsamples = 0

  do i=0,nsteps-1
     x = i*h; y = sqrt(1-x*x)
     x2 = (i+1)*h; y2 = sqrt(1-x2*x2)
     slope = (y-y2)/h; if (slope>15) slope = 15
     samples = 1+slope
     do is=1,samples
        hs = h/samples
        xs = x+is*hs; ys = sqrt(1-xs*xs)
        quarterpi  = quarterpi+hs*ys
        nsamples = nsamples+1
     end do
  end do

  pi = 4*quarterpi
  tend = omp_get_wtime()
  elapsed = tend-tstart
  write(*,'("Computed pi=",F7.4," in t=",F7.4," with ",I9," samples")') &
       pi,elapsed,nsamples
  
end Program PI1
