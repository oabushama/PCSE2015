#ifndef MANDEL_H
#define MANDEL_H 1

#include <string.h>
#include <math.h>
#include "unistd.h"

#include "Image.h"
#include "tools.h"

#define MAX(a,b) ( ((a)>(b)) ? (a) : (b) )
#define CHK(x) if (x) {							\
    char errtxt[200]; int len=200, mytid;				\
    printf("p=%d, line=%d, err=%d, %s\n",mytid,__LINE__,x,errtxt);	\
  return x;}

int parameters_from_commandline(int argc,char** argv,int *rsteps,int *riter);

struct coordinate { double x,y; } ;
int belongs(struct coordinate xy,int itbound);

class circle {
private:
  void next_coordinate_internal(struct coordinate& xy);
public:
  double step; int infty,pixels;
private:
  double xmin,xmax,ymin,ymax, x,y;
 public :
  /**
     Create a circle:
     Set the bounds on the x and y range for circle points:
     x from -2 to 2, y bounds will be depending on x.
  */
  circle(int pxls,int bound) {
    infty = bound; pixels = pxls;
    xmin=-2.; xmax=+2.; step=2./pixels; x = xmin;
    ymax = sqrt(4-x*x); ymin = -ymax; y = ymin;
  };
  /** 
      Generate new coordinate.
  */
  void next_coordinate(struct coordinate& xy) {
    if (y<ymax-step) {
      xy.y = y; xy.x = x; y += step;
    } else if (x<xmax-step) {
      x += step; 
      ymax = sqrt(4-x*x); ymin = -ymax; y = ymin;
      xy.y = y; xy.x = x; y += step;
    } else {
      invalid_coordinate(xy); //.y = -5.; xy.x = -5;
    }
  };
  int is_valid_coordinate(struct coordinate xy) {
    return xy.x>-3. && xy.y > -3.;
  };
  void invalid_coordinate(struct coordinate& xy) {
    xy.x = -5.; xy.y = -5.;
  };
};

class queue {
protected:
  int ntids,mytid;
  double t_start,t_stop;
  circle *workcircle;
  Image *image;
  double area;
public: // data
  int total_tasks;
public: // methods
  queue(circle *disccircle) {
    workcircle = disccircle;
    total_tasks = 0;
    area = 0.;
  };
  void main_loop(circle *workcircle);
  void set_image(Image *theimage) { image = theimage; };
  void coordinate_to_image(struct coordinate xy,int iteration) {
    int nx = (int) ( (xy.x+2.f)*(float)image->width*.25 ), 
      ny = (int) ( (xy.y+2.f)*(float)image->height*.25 );
    int pixel = ny+nx*image->width;
    float colour[3];
    if (iteration==0)
      memset(colour,0,3*sizeof(float));
    else {
      float rfloat = ((float) iteration) / workcircle->infty;
      colour[0] = rfloat;
      colour[1] = MAX((float)0,(float)(1-2*rfloat));
      colour[2] = MAX((float)0,(float)(2*(rfloat-.5)));
    }
    image->Add( pixel, colour );
  };
};

void scan_circle(queue *taskqueue);

#endif
