#include <stdlib.h>
#include "unistd.h"

#include "tools.h"
#include "mandel.h"

/**
   Read the commandline arguments for this program.
   This uses the general commandline_argument routine;
   the commandline is only inspected on processors zero,
   all others get their values by broadcast.
*/
int parameters_from_commandline
(int argc,char** argv,int *steps,int *iters)
{
  int mytid,ntids, err;
  if ( argc==0 ||
       ( argc>1 && (!strcmp(argv[1],"-h") || !strcmp(argv[1],"h")) ) )
    return error(0,"\nUsage: mandel steps 123 iters 456\n");
  *steps = commandline_argument(argc,argv,"steps",10);
  *iters = commandline_argument(argc,argv,"iters",100000);
  return 0;
}

/* Compute how many iterations it takes for the Mandelbrot
   iteration to escape the circle, return 0 otherwise
*/
int belongs(struct coordinate xy,int itbound) {
  double x=xy.x, y=xy.y; int it;
  for (it=0; it<itbound; it++) {
    double xx,yy;
    xx = x*x - y*y + xy.x;
    yy = 2*x*y + xy.y;
    x = xx; y = yy;
    if (x*x+y*y>4.) {
      return it;
    }
  }
  return 0;
}

/** The main computational loop
 */
void queue::main_loop(circle *workcircle) {

  this->set_image
    ( new Image(workcircle->pixels,workcircle->pixels,"mandelpicture") );
  for (;;) {
    struct coordinate xy; int res;
    workcircle->next_coordinate(xy);
    if (workcircle->is_valid_coordinate(xy)) {
      this->total_tasks += 1;
      res = belongs(xy,workcircle->infty);
      coordinate_to_image(xy,res);
    }
    else break;
  }
  image->Write();
}

