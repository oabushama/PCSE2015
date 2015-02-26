# -*- makefile -*-

#
# Mandelbrot
#
info ::
	@echo "make mandel"
	@echo "    [OPTLEVEL=0,1,2,3 (default=${OPTLEVEL})]"
	@echo "    [MANDELVERSION=0,1,... (default=${MANDELVERSION})]"
OPTLEVEL = 2
MANDELVERSION = 0

MANDEL_OBJS = mandel_tools${MANDELVERSION}.o mandelbrot.o tools.o Image.o 
.PHONY: .mandel
.mandel : 
	@if [ ! -f .mandel ] ; then touch .mandel ; fi
	@if [ "`cat .mandel`" != "${MANDELVERSION}" ] ; then \
	  echo ${MANDELVERSION} > .mandel ; fi
mandel: ${MANDEL_OBJS} .mandel
	${CXX} ${CXXFLAGS} -o mandel ${MANDEL_OBJS}
OMPFLAGS_intel    = -g -openmp 
OMPFLAGS_gcc      = -ggdb -fopenmp
OMPFLAGS = ${OMPFLAGS_${TACC_FAMILY_COMPILER}}
CXX_intel = icpc
CXX_gcc   = g++
CXX = ${CXX_${TACC_FAMILY_COMPILER}}
CFLAGS = ${OMPFLAGS} -O${OPTLEVEL}
CXXFLAGS = ${CFLAGS}
%.o : %.cxx
	${CXX} ${CXXFLAGS} -c $*.cxx

mandelbrot.o mandel_tools${MANDELVERSION}.o : mandel.h
mandelbrot.o Image.o : Image.h

clean :: 
	@/bin/rm -rf *.o *~ *.gch *.mod a.out *.dSYM MULTI__* events.* \
	    idev[0-9]*.o[0-9]* ddt.o[0-9]* jobtest.o* tautrace_* \
	    mandel
