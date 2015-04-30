/* %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   %%%%
   %%%% This program file is part of the textbook and course
   %%%% `Introduction to High-Performance Scientific Computing'
   %%%% by Victor Eijkhout, copyright 2012/3/4/5
   %%%%
   %%%% This book is distributed under a Creative Commons Attribution 3.0
   %%%% Unported (CC BY 3.0) license and made possible by funding from
   %%%% The Saylor Foundation \url{http://www.saylor.org}.
   %%%%
   %%%%
   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
*/
#include "petsc.h"

#undef __FUNCT__
#define __FUNCT__ "main"
int main(int argc,char **argv)
{
  MPI_Comm       comm;
  PetscInt       n = 20;
  PetscErrorCode ierr;

  PetscFunctionBegin;
  ierr = PetscInitialize(&argc,&argv,0,0); CHKERRQ(ierr); 
  comm = PETSC_COMM_WORLD;
  ierr = PetscOptionsGetInt(PETSC_NULL,"-n",&n,PETSC_NULL); CHKERRQ(ierr);
  printf("n=%d\n",n);

  ierr = PetscFinalize();CHKERRQ(ierr);
  PetscFunctionReturn(0);
}

