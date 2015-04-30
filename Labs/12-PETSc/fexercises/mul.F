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
      program mul
#include "finclude/petsc.h"
      
      MPI_Comm       comm
      PetscInt :: int ntids,mytid,localsize,myfirst,mylast,i
      PetscInt,dimension(3) :: j
      PetscScalar :: vm
      PetscScalar,dimension(3) :: v
      Mat            A
      Vec            x,y
      PetscInt       :: n = 20
      PetscErrorCode ierr
      
c        PetscFunctionBegin
        call PetscInitialize(PETSC_NULL_CHARACTER,ierr)
      CHKERRQ(ierr)
        comm = PETSC_COMM_WORLD
        call PetscOptionsGetInt
     >         (PETSC_NULL_CHARACTER,"-n",n,PETSC_NULL,ierr)
      CHKERRQ(ierr)
      
        call MPI_Comm_size(comm,ntids, ierr)
      CHKERRQ(ierr)
        call MPI_Comm_rank(comm,mytid, ierr)
      CHKERRQ(ierr)
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
! Exercise: set the vector values
        call VecAssemblyBegin(x,ierr)
      CHKERRQ(ierr)
        call VecAssemblyEnd(x,ierr)
      CHKERRQ(ierr)
      
        call MatCreate(comm,A,ierr)
      CHKERRQ(ierr)
        call MatSetType(A,MATMPIAIJ,ierr)
      CHKERRQ(ierr)
        call MatSetSizes(A,localsize,localsize,
     > 		     PETSC_DECIDE,PETSC_DECIDE,ierr)
      CHKERRQ(ierr)
      call MatMPIAIJSetPreallocation(A, 2, PETSC_NULL, 2,
     >     PETSC_NULL)
      CHKERRQ(ierr)
        call MatGetOwnershipRange(A,myfirst,mylast,ierr)
      CHKERRQ(ierr)
      vm = 1.*mytid
      do i=myfirst,mylast-1
           j(1) = i-1; j(2) = i; j(3) = i+1
           v(1) = -vm-1; v(2) = 2*vm; v(3) = -vm+1
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
        call VecView(y,PETSC_NULL_INTEGER,ierr)
      CHKERRQ(ierr)
      
        call PetscFinalize(ierr)
      CHKERRQ(ierr)
c        PetscFunctionReturn(0)
      
      end
