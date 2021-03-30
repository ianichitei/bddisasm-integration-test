#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#if !defined(BDDISASM_HAS_VSNPRINTF)
int nd_vsnprintf_s(char *buffer, size_t sizeOfBuffer, size_t count, const char *format, va_list argptr)
{
    return vsnprintf(buffer, sizeOfBuffer, format, argptr);
}
#endif // !defined(BDDISASM_HAS_VSNPRINTF)

#if !defined(BDDISASM_HAS_MEMSET)
void *nd_memset(void *s, int c, size_t n)
{
    return memset(s, c, n);
}
#endif // !!defined(BDDISASM_HAS_MEMSET)
