#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#ifdef USE_SUBDIR
#include "disasmtypes.h"
#include "bddisasm.h"
#else
#include <bddisasm/disasmtypes.h>
#include <bddisasm/bddisasm.h>
#endif // USE_SUBDIR

int nd_vsnprintf_s(char *buffer, size_t sizeOfBuffer, size_t count, const char *format, va_list argptr)
{
    return vsnprintf(buffer, sizeOfBuffer, format, argptr);
}

void *nd_memset(void *s, int c, size_t n)
{
    return memset(s, c, n);
}

int main()
{
    INSTRUX ix;
    uint8_t code[] = { 0x48, 0x8B, 0x48, 0x28 };
    char text[ND_MIN_BUF_SIZE] = { 0 };
    NDSTATUS status;
    uint32_t major, minor, revision;
    char *date, *time;

    NdGetVersion(&major, &minor, &revision, &date, &time);
    printf("Got disasm %u.%u.%u built at %s %s\n", major, minor, revision, date, time);
    
    status = NdDecodeEx(&ix, code, sizeof(code), ND_CODE_64, ND_DATA_64);
    if (!ND_SUCCESS(status))
    {
        printf("Decode failed with error 0x%08x!\n", status);
        return 1;
    }

    NdToText(&ix, 0, sizeof(text), text);
    printf("Instruction: %s\n", text);

    return 0;
}
