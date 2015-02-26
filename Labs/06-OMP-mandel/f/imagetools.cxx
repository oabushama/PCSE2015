#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include "Image.h"

#define MAX(a,b) ( ((a)>(b)) ? (a) : (b) )

int width,height,infty;
Image *img;

#ifdef __cplusplus
extern "C" {
#endif

  void set_image_parms_( int *n,int *inf ) {
    width = *n; height = *n; infty = *inf;
    img = new Image(*n,*n,"mandelpicture");
    return;
  }

  void coordinate_to_image_( float *fx,float *fy,int *fcont ) {

    double x=*fx, y=*fy; int contribution=*fcont;

    int
      nx = (int) ( (x+2.f)*(float)img->width*.25 ),
      ny = (int) ( (y+2.f)*(float)img->height*.25 );
    int pixel = nx+ny*img->width;
    float colour[3];
    
    if (contribution==0)
      memset(colour,0,3*sizeof(float));
    else {
      float rfloat = ((float) contribution) / infty;
      colour[0] = rfloat;
      colour[1] = MAX((float)0,(float)(1-2*rfloat));
      colour[2] = MAX((float)0,(float)(2*(rfloat-.5)));
    }
    
    img->Add( pixel, colour );
    
    return;
  }
  
  void image_write_() {
    img->Write();
  }

#ifdef __cplusplus
}
#endif
