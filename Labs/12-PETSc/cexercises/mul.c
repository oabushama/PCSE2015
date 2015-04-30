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
  int ntids,mytid,myfirst,mylast,localsize,i;
  Vec            x;
  Mat            A;
  PetscInt       n = 20;
  PetscErrorCode ierr;

  PetscFunctionBegin;
  ierr = PetscInitialize(&argc,&argv,0,0); CHKERRQ(ierr); 
  comm = PETSC_COMM_WORLD;
  ierr = PetscOptionsGetInt(PETSC_NULL,"-n",&n,PETSC_NULL); CHKERRQ(ierr);

  MPI_Comm_size(comm,&ntids); MPI_Comm_rank(comm,&mytid);

  ierr = VecCreate(comm,&x);CHKERRQ(ierr);
  ierr = VecSetSizes(x,PETSC_DECIDE,n); CHKERRQ(ierr);
  ierr = VecSetType(x,VECMPI); CHKERRQ(ierr);
  ierr = VecGetOwnershipRange(x,&myfirst,&mylast); CHKERRQ(ierr);
  localsize = mylast-myfirst;

  /*
    Exercise: Fill in some vector values here
  */

  ierr = VecView(x,0); CHKERRQ(ierr);
  
  ierr = MatCreate(comm,&A); CHKERRQ(ierr);
  ierr = MatSetType(A,MATMPIAIJ); CHKERRQ(ierr);
  ierr = MatSetSizes(A,localsize,localsize,
		     PETSC_DECIDE,PETSC_DECIDE); CHKERRQ(ierr);
  ierr = MatMPIAIJSetPreallocation(A, 3, NULL, 2, NULL);

  for (i=myfirst; i<mylast; i++) {
    PetscReal v=1.0*mytid;
    ierr = MatSetValues(A,1,&i,1,&i,&v,INSERT_VALUES); CHKERRQ(ierr);
    /*
      Exercise: Add off-diagonal entries to the matrix
    */
  }
  ierr = MatAssemblyBegin(A,MAT_FINAL_ASSEMBLY); CHKERRQ(ierr);
  ierr = MatAssemblyEnd(A,MAT_FINAL_ASSEMBLY); CHKERRQ(ierr);
  ierr = MatView(A,0); CHKERRQ(ierr);

  /*
    Exercise: Multipy the matrix and the vector and view the result
  */

  ierr = PetscFinalize();CHKERRQ(ierr);
  PetscFunctionReturn(0);
}

