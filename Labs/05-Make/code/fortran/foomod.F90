module testmod

contains

  subroutine dummy(a,b)
    implicit none
    integer a,b
    write(*,*)a,b
  end subroutine dummy

end module
