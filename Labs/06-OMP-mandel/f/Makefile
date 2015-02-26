# -*- makefile -*-

################################################################
################################################################
####
#### This make file is part of the source of 
#### `Parallel Programing in Science and Engineering'
#### by Victor Eijkhout, copyright 2013/4
####
#### This is the makefile for the OpenMP/F90 mandelbrot set
####
################################################################
################################################################

info ::
	@echo "make mandel"
	@echo "    [OPTLEVEL=0,1,2,3 (default=${OPTLEVEL})]"
	@echo "    [MANDELVERSION=0,1,... (default=${MANDELVERSION})]"
OPTLEVEL = 2
MANDELVERSION = 0

MANDEL_OBJS = mandel_tools${MANDELVERSION}.o mandelbrot.o imagetools.o Image.o

.PHONY: .mandel
.mandel : 
	@if [ ! -f .mandel ] ; then touch .mandel ; fi
	@if [ "`cat .mandel`" != "${MANDELVERSION}" ] ; then \
	  echo ${MANDELVERSION} > .mandel ; fi
mandel: ${MANDEL_OBJS} .mandel
	${F90} ${FFLAGS} -o mandel ${MANDEL_OBJS} ${LDFLAGS}
Image.o : Image.h
Color.o : Color.h

OMPFLAGS_intel    = -g -openmp 
OMPFLAGS_gcc      = -ggdb -fopenmp
OMPFLAGS = ${OMPFLAGS_${TACC_FAMILY_COMPILER}}
CXX_intel = icpc
CXX_gcc   = g++
CXX = ${CXX_${TACC_FAMILY_COMPILER}}
CFLAGS = ${OMPFLAGS} -O${OPTLEVEL}
CXXFLAGS = ${CFLAGS}
F90_gcc   = gfortran
F90_intel = icpc
F90 = ${F90_${TACC_FAMILY_COMPILER}}
FC_gcc    = gfortran
FC_intel  = ifort
FC = ${FC_${TACC_FAMILY_COMPILER}}
FFLAGS = -g -O${OPTLEVEL} ${OMPFLAGS}
LDFLAGS_gcc   = -lstdc++ -lc
LDFLAGS_intel = -lstdc++ -lc
LDFLAGS = ${LDFLAGS_${TACC_FAMILY_COMPILER}}

%.o : %.cxx
	${CXX} ${CXXFLAGS} -c $*.cxx
%.o : %.F90
	${F90} ${FFLAGS} -c $*.F90

clean :: 
	@/bin/rm -rf *.o *~ *.gch *.mod a.out *.dSYM MULTI__* events.* \
	    idev[0-9]*.o[0-9]* ddt.o[0-9]* jobtest.o* tautrace_* \
	    mandel
