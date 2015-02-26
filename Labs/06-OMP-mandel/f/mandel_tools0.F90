! -*- f90 -*-
module Circle
  implicit none

  integer :: bound
  real :: step, ymin,ymax,ycur, xmin,xmax,xcur

  type,public :: coordinate
     real :: x,y
  end type coordinate

contains

  subroutine GetArguments(steps,iters)
    implicit none
    integer,intent(out) :: steps,iters
    character(32) :: argtxt,dt
    integer :: i
    steps = 10; iters = 1000
    !call iarg(0,argtxt)
    do i=1,command_argument_count()-1 !iargc()
       call get_command_argument(i,argtxt) !call getarg(i,argtxt)
       if (argtxt(1:5)=='steps') then
          call get_command_argument(i+1,argtxt) !call getarg(i+1,argtxt)
          read(argtxt,*) steps
       end if
       if (argtxt(1:5)=='iters') then
          call get_command_argument(i+1,argtxt) !call getarg(i+1,argtxt)
          read(argtxt,*) iters
       end if
    end do
    return
  end subroutine GetArguments

  subroutine SetParameters(steps_v,bound_v)
    implicit none
    integer,intent(in) :: steps_v,bound_v

    step = 2./steps_v ; bound = bound_v
    ymin = -2.; ymax = +2.; ycur = ymin
    xmax = sqrt(4-ycur*ycur); xmin = -xmax; xcur = xmin

  end subroutine SetParameters
  
  type(coordinate) function InvalidCoordinate()
    implicit none
    InvalidCoordinate%x = -5.; InvalidCoordinate%y = -5.
  end function InvalidCoordinate
  
  type(coordinate) function NextCoordinate()
    implicit none
    if (xcur<xmax-step) then
       NextCoordinate%x = xcur; NextCoordinate%y = ycur; xcur = xcur+step
    else if (ycur<ymax-step) then
       ycur = ycur+step; xmax = sqrt(4-ycur*ycur); xmin = -xmax; xcur = xmin
       NextCoordinate%x = xcur; NextCoordinate%y = ycur; xcur = xcur+step
    else
       NextCoordinate = InvalidCoordinate()
    end if
  end function NextCoordinate

  Logical function IsValidCoordinate(xy)
    type(coordinate),intent(in) :: xy
    if ( (xy%x<-3.) .and. (xy%y<-3.) ) then
       IsValidCoordinate = .FALSE.
    else
       IsValidCoordinate = .TRUE.
    end if
  end function IsValidCoordinate
  
  integer function Belongs(xy)
    type(coordinate),intent(in) :: xy
    real x,y,xx,yy
    integer :: it

    x = xy%x ; y = xy%y
    Belongs = 0
    do it=1,bound
       xx = x*x - y*y + xy%x
       yy = 2*x*y + xy%y
       x = xx; y = yy
       if (x*x+y*y>4.) then
          Belongs = it; exit
       end if
    end do
  end function Belongs

end module Circle

module Queue
  use Circle
  use omp_lib
  implicit none

  integer :: comm,ntids,mytid
! common bookkeeping for all queue variants
  integer :: TotalTasks
  double precision :: t_start,t_stop

contains

  subroutine QueueInit()
    TotalTasks = 0
  end subroutine QueueInit

  subroutine MainLoop()
    use Circle
    implicit none
    type(Coordinate) :: xy
    real :: xyv(2)
    integer :: res

    t_start = omp_get_wtime()
    do
       xy = NextCoordinate()
       if (IsValidCoordinate(xy)) then
          res = Belongs(xy)
          call coordinate_to_image(xy%x,xy%y,res)
          TotalTasks = TotalTasks+1
       else
          exit
       end if
    end do

    t_stop = omp_get_wtime()
    print *,"Performed",TotalTasks,"tasks in",t_stop-t_start
  end subroutine MainLoop

end module Queue
