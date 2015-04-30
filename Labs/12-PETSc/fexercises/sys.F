!   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
!   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
!   %%%%
!   %%%% This program file is part of the textbook and course
!   %%%% `Introduction to High-Performance Scientific Computing'
!   %%%% by Victor Eijkhout, copyright 2012/3/4/5
!   %%%%
!   %%%% This book is distributed under a Creative Commons Attribution 3.0
!   %%%% Unported (CC BY 3.0) license and made possible by funding from
!   %%%% The Saylor Foundation \url{http://www.saylor.org}.
!   %%%%
!   %%%%
!   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
!   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

      program mat
#include "finclude/petsc.h"
      
        MPI_Comm       :: comm
        KSP            :: solver
        KSPConvergedReason :: reason
        character*80   msg
        Mat            :: A
        Vec            :: x,y
        PetscInt       :: j(3)
        PetscInt       :: ntids,mytid,localsize,myfirst,mylast,i
        PetscScalar    :: v(3)
        PetscScalar    :: mv
        PetscInt       :: n = 20
        PetscErrorCode :: ierr
      
        call PetscInitialize(PETSC_NULL_CHARACTER,ierr)
        CHKERRQ(ierr)
        comm = PETSC_COMM_WORLD
        call PetscOptionsGetInt
     >       (PETSC_NULL_CHARACTER,"-n",n,PETSC_NULL_CHARACTER,ierr)
        CHKERRQ(ierr)
      
        call MPI_Comm_size(comm,ntids,ierr)
        call MPI_Comm_rank(comm,mytid,ierr)
        localsize = PETSC_DECIDE
        call PetscSplitOwnership(comm,localsize,n,ierr)
        CHKERRQ(ierr)
      
        call VecCreate(comm,x,ierr)
        CHKERRQ(ierr)
        call VecSetSizes(x,localsize,PETSC_DECIDE,ierr)
        CHKERRQ(ierr)
        call VecSetType(x,VECMPI,ierr)
        CHKERRQ(ierr)
        call VecGetOwnershipRange(x,myfirst,mylast,ierr)
        CHKERRQ(ierr)
      
        call MatCreate(comm,A,ierr)
        CHKERRQ(ierr)
        call MatSetType(A,MATMPIAIJ,ierr)
        CHKERRQ(ierr)
        call MatSetSizes(A,localsize,localsize,
     >       PETSC_DECIDE,PETSC_DECIDE,ierr)
        CHKERRQ(ierr)
       call MatMPIAIJSetPreallocation( A,
     >      3,PETSC_NULL_INTEGER,2,PETSC_NULL_INTEGER,ierr)

       mv = 1.+mytid
       do i=myfirst,mylast-1
          call VecSetValue(x,i,mv,INSERT_VALUES,ierr)
       CHKERRQ(ierr)
       end do
        call VecAssemblyBegin(x,ierr)
       CHKERRQ(ierr)
        call VecAssemblyEnd(x,ierr)
       CHKERRQ(ierr)
      

       mv = 1.+mytid
       do i=myfirst,mylast-1
          j(1) = i-1; j(2) = i; j(3) = i+1
          v(1) = -mv-1; v(2) = 2*mv; v(3) = -mv+1
          if (i>0 .and. i<n-1) then
            call MatSetValues(A,1,i,3,j,v,INSERT_VALUES,ierr)
       CHKERRQ(ierr)
          else if (i==0) then
            call MatSetValues(A,1,i,2,j(2),v(2),INSERT_VALUES,ierr)
       CHKERRQ(ierr)
          else
            call MatSetValues(A,1,i,2,j,v,INSERT_VALUES,ierr)
       CHKERRQ(ierr)
          end if
        end do
        call MatAssemblyBegin(A,MAT_FINAL_ASSEMBLY,ierr)
       CHKERRQ(ierr)
        call MatAssemblyEnd(A,MAT_FINAL_ASSEMBLY,ierr)
       CHKERRQ(ierr)
      
       call VecDuplicate(x,y,ierr)
       CHKERRQ(ierr)
       call MatMult(A,x,y,ierr)
       CHKERRQ(ierr)
      
       call KSPCreate(comm,solver,ierr)
       CHKERRQ(ierr)
       call KSPSetOperators(solver,A,A,ierr)
       CHKERRQ(ierr)
       call KSPSetFromOptions(solver,ierr)
       CHKERRQ(ierr)
       call KSPSolve(solver,y,x,ierr)
       CHKERRQ(ierr)

!
!     Exercise: find out why the solver stopped
!     Exercise: construct the residual and print its norm
!

       call VecView(x,PETSC_NULL_INTEGER,ierr)
       CHKERRQ(ierr)
      
        call KSPDestroy(solver,ierr)
       CHKERRQ(ierr)
        call MatDestroy(A,ierr)
       CHKERRQ(ierr)
        call VecDestroy(x,ierr)
       CHKERRQ(ierr)
        call VecDestroy(y,ierr)
       CHKERRQ(ierr)
        call PetscFinalize(ierr)
       CHKERRQ(ierr)
      
      end program
      
