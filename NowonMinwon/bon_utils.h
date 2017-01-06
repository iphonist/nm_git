#include <unistd.h>

#ifndef BON_UTILS_H__
#define BON_UTILS_H__

#define BON_UMIN(a, b)    ((a) < (b) ? (a) : (b))
#define BON_UMAX(a, b)    ((a) > (b) ? (a) : (b))

#define BON_SAFE_MEM  5

typedef char  T_OCTET;
typedef long  T_KEY;

void *bon_calloc(size_t nmem, size_t size);
void bon_free(void *aa);

#define BON_CREATE(result, type, number) do {\
	if (!((result) = (type *) bon_calloc ((number), sizeof(type))))\
	{ perror("calloc failure : KIKU"); abort(); } } while(0)
#define BON_FREE(n)		bon_free(n)

#ifdef DEV_ANDROID
#include "./../log.h"
#else
void  bon_debug_out(const char *fmt, ...);
#endif

#endif
