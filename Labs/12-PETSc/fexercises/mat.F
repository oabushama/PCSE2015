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

        implicit none

#include "finclude/petsc.h"
      
        MPI_Comm :: comm
        PetscInt :: ntids,mytid,i
        PetscInt :: localsize,myfirst,mylast
        Mat            :: A
        PetscInt :: j(3)
        PetscReal :: v(3)
        PetscReal :: mv
        PetscInt  :: n = 20
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
      
        call MatCreate(comm,A,ierr)
       CHKERRQ(ierr)
        call MatSetType(A,MATMPIAIJ,ierr)
       CHKERRQ(ierr)
        call MatSetSizes(A,localsize,localsize,
     >      PETSC_DECIDE,PETSC_DECIDE,ierr)
       CHKERRQ(ierr)
       call MatMPIAIJSetPreallocation( A,
     >      3,PETSC_NULL_INTEGER,2,PETSC_NULL_INTEGER,ierr)

        call MatGetOwnershipRange(A,myfirst,mylast,ierr)
       CHKERRQ(ierr)
       mv = 1.*mytid
       do i=myfirst,mylast-1
          call MatSetValues(A,1,i,1,i,mv,INSERT_VALUES,ierr)
!
! Exercise: fill in some matrix elements
!
       end do
        call MatAssemblyBegin(A,MAT_FINAL_ASSEMBLY,ierr)
       CHKERRQ(ierr)
        call MatAssemblyEnd(A,MAT_FINAL_ASSEMBLY,ierr)
       CHKERRQ(ierr)
        call MatView(A,0,ierr)
       CHKERRQ(ierr)
      
        call MatDestroy(A,ierr)
       CHKERRQ(ierr)
        call PetscFinalize(ierr)
       CHKERRQ(ierr)
      
      end
