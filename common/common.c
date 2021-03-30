#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int nd_vsnprintf_s(char *buffer, size_t sizeOfBuffer, size_t count, const char *format, va_list argptr)
{
    return vsnprintf(buffer, sizeOfBuffer, format, argptr);
}

void *nd_memset(void *s, int c, size_t n)
{
    return memset(s, c, n);
}
