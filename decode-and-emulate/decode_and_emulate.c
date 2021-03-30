#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "disasmtypes.h"
#include "bddisasm.h"
#include "bdshemu.h"

void ShemuLog(char *data)
{
    printf("%s", data);
}

int decode()
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

void run_shemu(uint8_t *Data, size_t Size, uint8_t Def)
{
    SHEMU_CONTEXT ctx = { 0 };
    SHEMU_STATUS shs;

    ctx.Shellcode = Data;

    ctx.Stack = calloc(1, 0x2000);
    if (ctx.Stack == NULL)
    {
        printf("Failed to allocate Stack!\n");
        abort();
    }

    ctx.Intbuf = calloc(1, Size + 0x2000);
    if (ctx.Stack == NULL)
    {
        printf("Failed to allocate Intbuf!\n");
        abort();
    }

    ctx.ShellcodeBase = 0x200000;
    ctx.ShellcodeSize = (uint32_t)Size;
    ctx.StackBase = 0x100000;
    ctx.StackSize = 0x2000;
    ctx.Registers.RegRsp = 0x101000;
    ctx.IntbufSize = (uint32_t)Size + 0x2000;

    ctx.Registers.RegFlags = NDR_RFLAG_IF | 2;
    ctx.Registers.RegRip = ctx.ShellcodeBase;

    ctx.Segments.Cs.Selector = 0x10;
    ctx.Segments.Ds.Selector = 0x28;
    ctx.Segments.Es.Selector = 0x28;
    ctx.Segments.Ss.Selector = 0x28;
    ctx.Segments.Fs.Selector = 0x30;
    ctx.Segments.Fs.Base = 0x7FFF0000;
    ctx.Segments.Gs.Selector = 0x30;
    ctx.Segments.Gs.Base = 0x7FFF0000;

    ctx.Mode = Def;
    ctx.Ring = 3;
    ctx.TibBase = ctx.Mode == ND_CODE_32 ? ctx.Segments.Fs.Base : ctx.Segments.Gs.Base;
    ctx.MaxInstructionsCount = 4096;
    ctx.Log = &ShemuLog;
    ctx.Flags = 0;
    ctx.Options = SHEMU_OPT_TRACE_EMULATION;

    shs = ShemuEmulate(&ctx);
    printf("Shemu returned: 0x%08x\n", shs);

    free(ctx.Intbuf);
    free(ctx.Stack);
}

int emulate()
{
    uint8_t code[] = { 0x48, 0x8B, 0x48, 0x28 };

    run_shemu(code, sizeof(code), ND_CODE_64);

    return 0;
}

int main()
{
    decode();
    emulate();
    return 0;
}
