! -*- f90 -*-
program MandelSerial
  use Circle
  use Queue
  implicit none
  integer :: steps,iters,ierr

  call QueueInit()

  steps = 300; iters = 10000
  call GetArguments(steps,iters)
  call SetParameters(steps,iters)

  call set_image_parms(steps,iters)

  call MainLoop()

  call image_write()

end program MandelSerial
