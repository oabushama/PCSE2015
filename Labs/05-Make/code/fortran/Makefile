fooprog : foomain.o foomod.o
	gfortran -o fooprog foomain.o foomod.o
foomain.o : foomain.F90 foomod.o
	gfortran -c foomain.F90
foomod.o : foomod.F90
	gfortran -c foomod.F90
clean :
	rm -f *.o *.mod fooprog
