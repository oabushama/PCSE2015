#if defined(TOOLS_H)
#else
#define TOOLS_H 1

int error(int id,const char *fmt,...);
int commandline_argument(int argc,char **argv,const char *keyword,int val);

#endif
