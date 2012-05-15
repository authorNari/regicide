#include <stdio.h>
#include <errno.h>
#include "sys.h"

unsigned long
int2ulong(int v)
{
    volatile unsigned int d = (unsigned int)v;
    return (unsigned long)d;
}

unsigned long
long2ulong(long v)
{
    volatile unsigned long d = (long)v;
    return d;
}

int
get_errno(void)
{
    return errno;
}
