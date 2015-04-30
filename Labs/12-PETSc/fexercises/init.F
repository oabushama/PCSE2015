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

      Program init
      
        implicit none
#include "finclude/petsc.h"
      
        PetscInt      n
        character*80      msg
        PetscErrorCode ierr
      
        call PetscInitialize(PETSC_NULL_CHARACTER,ierr)
        CHKERRQ(ierr)
        n = 20
        call PetscOptionsGetInt(PETSC_NULL_CHARACTER,"-n",n,
     >       PETSC_NULL_CHARACTER,ierr)
        CHKERRQ(ierr)
        write(msg,10) n
 10     format("Input parameter:",i5,"\n")
        print *,msg
        CHKERRQ(ierr)
        call PetscFinalize(ierr)
        CHKERRQ(ierr)
      
      end
