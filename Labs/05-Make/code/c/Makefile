fooprog : foo.o bar.o
	gcc -o fooprog foo.o bar.o -lm
foo.o : foo.c
	gcc -c foo.c
bar.o : bar.c
	gcc -c bar.c
clean :
	rm -f *.o fooprog
