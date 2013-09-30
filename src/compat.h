/*
 * compat.h: declarations traditionally provided by the system.
 */

#ifndef	COMPAT_H
#define	COMPAT_H

#define	MILLISEC	1000

//#define	PATH_MAX	1024

#define	EXIT_SUCCESS	0
#define	EXIT_FAILURE	1
#define	EXIT_USAGE	2

#ifndef __sun
typedef enum { B_FALSE, B_TRUE } boolean_t;
#endif

#ifndef __sun
//#define GETOPT_RESET()	(optreset = 1)
#define	GETOPT_RESET()	
#else
#define	GETOPT_RESET()	
#endif

#endif
