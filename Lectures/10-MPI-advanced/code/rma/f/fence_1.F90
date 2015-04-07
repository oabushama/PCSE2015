program fence
  use mpi
  implicit none
  integer i, rank, numprocs, ierr
  integer buf, my_size, displacement, intsize
  integer target_rank, target_disp, target_cnt
  integer info, win


  call MPI_INIT(ierr)
  call MPI_COMM_RANK(MPI_COMM_WORLD, rank, ierr)
  call MPI_COMM_SIZE(MPI_COMM_WORLD, numprocs, ierr)
  ! Determine the size of an integer
  call MPI_TYPE_EXTENT(MPI_INTEGER, intsize, ierr)

  if(rank == 0)then
    ! Everyone will retrieve from a buffer on root
    buf = 42; my_size = intsize; displacement = intsize
    call MPI_INFO_CREATE(info, ierr)
  else 
    ! Others only retrieve, so these windows can be size 0
    buf = 0; my_size = 0; displacement = intsize
    info = MPI_INFO_NULL
  end if

  ! Print buf before RMA calls
  do i = 0, numprocs-1
    if(rank == i)then
      write(*,*)"(Rank ",rank,"): buf: ",buf
    end if
    call MPI_BARRIER(MPI_COMM_WORLD,ierr)
  end do

  ! Create a Window for RMA calls
  call MPI_WIN_CREATE(buf,my_size,displacement,info, &
                      MPI_COMM_WORLD,win,ierr)

  ! No local operations prior to this epoch, so give an assertion
  call MPI_WIN_FENCE(MPI_MODE_NOPRECEDE,win,ierr)

  if(rank .ne. 0)then
    target_rank = 0; target_disp = 0; target_cnt = intsize
    ! Inside the fence, make RMA call to GET from rank 0
    call MPI_GET(buf,1,MPI_INTEGER, &
                 target_rank,target_disp,target_cnt, &
                 MPI_INTEGER,win,ierr)
  else
    write(*,'(/,a)',advance='no')"Using MPI_WIN_CREATE "
    write(*,'(a,i0,/)')"and MPI_GET to fill buf from ",rank
  end if

  ! Complete the epoch - this will block until MPI_GET is complete
  call MPI_WIN_FENCE(0,win,ierr) ! Using no assertions

  ! All done with the window - tell MPI there are no more epochs
  call MPI_WIN_FENCE(MPI_MODE_NOSUCCEED,win,ierr)

  ! Free up our window
  call MPI_WIN_FREE(win,ierr)

  ! Print buf after RMA calls
  do i = 0, numprocs-1
    if(rank == i)then
      write(*,*)"(Rank ",rank,"): buf: ",buf
    end if
    call MPI_BARRIER(MPI_COMM_WORLD,ierr)
  end do
  call MPI_FINALIZE(ierr)
end program fence





