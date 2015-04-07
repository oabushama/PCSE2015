! Default way of sending contiguous one col of 2D array
program datatype
  use mpi
  implicit none
  integer, parameter :: NROWS = 3
  integer, parameter :: NCOLS = 4
  integer numprocs, rank, ierr
  integer i,j,k,dest,src,tag1,col
  double precision, dimension(NROWS,NCOLS) :: matrix
  integer stat(MPI_STATUS_SIZE)

  matrix = 0.0

  call MPI_INIT(ierr)
  call MPI_COMM_RANK(MPI_COMM_WORLD, rank, ierr)
  call MPI_COMM_SIZE(MPI_COMM_WORLD, numprocs, ierr)
   
  ! Initialize matrix on process 0 only
  if(rank == 0)then
    do i = 1, NROWS
      do j = 1, NCOLS
        matrix(i,j) = NROWS * (i-1) + (i-1) + (j-1)
      end do
    end do
  end if

  ! Print matrix before Send/Recv
  do k = 0, numprocs-1
    if(rank == k)then
      write(*,'(a,i0,a)')"(Rank ",rank,"): Matrix:"
      do i = 1, NROWS
        do j = 1, NCOLS
          write(*,'(x,f3.0)',advance='no')matrix(i,j)
        end do
        write(*,*)
      end do
    end if
    call MPI_BARRIER(MPI_COMM_WORLD,ierr)
  end do
  ! Send/Recv
  tag1 = 1; dest = 1; src = 0; col = 2
  if(rank == 0)then
    write(*,'(/,3(a,i0),a,/)')"Completing Send/Recv from ", &
          src," to ",dest," from col ",col,"..."
  end if
  if (rank == 0) then
    call MPI_SEND(matrix(1,col),NROWS,MPI_DOUBLE_PRECISION,dest, &
    &             tag1,MPI_COMM_WORLD,ierr)
  end if
  if (rank == 1) then
    call MPI_RECV(matrix(1,col),NROWS,MPI_DOUBLE_PRECISION,src, &
    &             tag1,MPI_COMM_WORLD,stat,ierr)
  end if
  ! Print matrix after Send/Recv
  do k = 0, numprocs-1
    if(rank == k)then
      write(*,'(a,i0,a)')"(Rank ",rank,"): Matrix:"
      do i = 1, NROWS
        do j = 1, NCOLS
          write(*,'(x,f3.0)',advance='no')matrix(i,j)
        end do
        write(*,*)
      end do
    end if
    call MPI_BARRIER(MPI_COMM_WORLD,ierr)
  end do
  call MPI_FINALIZE(ierr)
end program datatype
