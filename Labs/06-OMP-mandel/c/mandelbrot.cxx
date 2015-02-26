#include <stdlib.h>
#include <stdio.h>

#include "mandel.h"
#include "Image.h"

int main(int argc,char **argv) {
  int steps,iters,ierr;

  ierr = parameters_from_commandline(argc,argv,&steps,&iters);
  if (ierr) return 1;

  circle *workcircle = new circle(steps,iters);
  queue *taskqueue = new queue(workcircle);
  taskqueue->main_loop(workcircle);
  printf("done %d tasks\n",taskqueue->total_tasks);

  return 0;
}
