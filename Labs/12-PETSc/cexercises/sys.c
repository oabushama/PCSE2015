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
  int ntids,mytid,localsize,myfirst,mylast,i;
  Mat            A;
  Vec            x,y;
  KSP            solver;
  PetscInt       n = 20;
  PetscErrorCode ierr;

  PetscFunctionBegin;
  ierr = PetscInitialize(&argc,&argv,0,0); CHKERRQ(ierr); 
  comm = PETSC_COMM_WORLD;
  ierr = PetscOptionsGetInt(PETSC_NULL,"-n",&n,PETSC_NULL); CHKERRQ(ierr);

  MPI_Comm_size(comm,&ntids); MPI_Comm_rank(comm,&mytid);
  localsize = PETSC_DECIDE;
  ierr = PetscSplitOwnership(comm,&localsize,&n); CHKERRQ(ierr);

  ierr = VecCreate(comm,&x);CHKERRQ(ierr);
  ierr = VecSetSizes(x,localsize,PETSC_DECIDE); CHKERRQ(ierr);
  ierr = VecSetType(x,VECMPI); CHKERRQ(ierr);

  ierr = VecGetOwnershipRange(x,&myfirst,&mylast); CHKERRQ(ierr);
  for (i=myfirst; i<mylast; i++) {
    ierr = VecSetValue(x,i,1.0+mytid,INSERT_VALUES); CHKERRQ(ierr);
  }
  ierr = VecAssemblyBegin(x); CHKERRQ(ierr);
  ierr = VecAssemblyEnd(x); CHKERRQ(ierr);

  ierr = MatCreate(comm,&A); CHKERRQ(ierr);
  ierr = MatSetType(A,MATMPIAIJ); CHKERRQ(ierr);
  ierr = MatSetSizes(A,localsize,localsize,
		     PETSC_DECIDE,PETSC_DECIDE); CHKERRQ(ierr);
  ierr = MatMPIAIJSetPreallocation(A, 3, NULL, 2, NULL);
  ierr = MatGetOwnershipRange(A,&myfirst,&mylast); CHKERRQ(ierr);

  for (i=myfirst; i<mylast; i++) {
    PetscInt j[3]; PetscReal v[3];
    j[0] = i-1; j[1] = i; j[2] = i+1;
    v[0] = -1; v[1] = 1.0+mytid; v[2] = +1;
    if (i>0 && i<n-1) {
      ierr = MatSetValues(A,1,&i,3,j,v,INSERT_VALUES); CHKERRQ(ierr);
    } else if (i==0) {
      ierr = MatSetValues(A,1,&i,2,j+1,v+1,INSERT_VALUES); CHKERRQ(ierr);
    } else if (i==n-1) {
      ierr = MatSetValues(A,1,&i,2,j,v,INSERT_VALUES); CHKERRQ(ierr);
    }
  }
  ierr = MatAssemblyBegin(A,MAT_FINAL_ASSEMBLY); CHKERRQ(ierr);
  ierr = MatAssemblyEnd(A,MAT_FINAL_ASSEMBLY); CHKERRQ(ierr);

  /* generate a right hand side */
  ierr = VecDuplicate(x,&y); CHKERRQ(ierr);
  ierr = MatMult(A,x,y); CHKERRQ(ierr);

  ierr = KSPCreate(comm,&solver); CHKERRQ(ierr);
  ierr = KSPSetOperators(solver,A,A); CHKERRQ(ierr);
  ierr = KSPSetFromOptions(solver); CHKERRQ(ierr);
  ierr = KSPSolve(solver,y,x); CHKERRQ(ierr);

  /*
    Exercise: print out the reason the solver stopped
    Exercise: compute the residual and print its norm
  */

  ierr = KSPDestroy(&solver); CHKERRQ(ierr);
  ierr = MatDestroy(&A); CHKERRQ(ierr);
  ierr = VecDestroy(&x); CHKERRQ(ierr);
  ierr = VecDestroy(&y); CHKERRQ(ierr);
  ierr = PetscFinalize();CHKERRQ(ierr);
  PetscFunctionReturn(0);
}

