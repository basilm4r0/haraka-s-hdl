#ifndef _GNU_SOURCE
#define _GNU_SOURCE
#endif
#include <stdio.h>
#include <dlfcn.h>
#include "svdpi.h"

#ifdef __cplusplus
extern "C" {
#endif

/* VCS error reporting routine */
extern void vcsMsgReport1(const char *, const char *, int, void *, void*, const char *);

#ifndef _VC_TYPES_
#define _VC_TYPES_
/* common definitions shared with DirectC.h */

typedef unsigned int U;
typedef unsigned char UB;
typedef unsigned char scalar;
typedef struct { U c; U d;} vec32;

#define scalar_0 0
#define scalar_1 1
#define scalar_z 2
#define scalar_x 3

extern long long int ConvUP2LLI(U* a);
extern void ConvLLI2UP(long long int a1, U* a2);
extern long long int GetLLIresult();
extern void StoreLLIresult(const unsigned int* data);
typedef struct VeriC_Descriptor *vc_handle;

#ifndef SV_3_COMPATIBILITY
#define SV_STRING const char*
#else
#define SV_STRING char*
#endif

#endif /* _VC_TYPES_ */

#ifndef __VCS_IMPORT_DPI_STUB_dpi_haraka_s
#define __VCS_IMPORT_DPI_STUB_dpi_haraka_s
__attribute__((weak)) void dpi_haraka_s(const /* INPUT */svOpenArrayHandle A_1, /* INPUT */long long A_2, const /* OUTPUT */svOpenArrayHandle A_3, /* INPUT */long long A_4)
{
    static int _vcs_dpi_stub_initialized_ = 0;
    static void (*_vcs_dpi_fp_)(const /* INPUT */svOpenArrayHandle A_1, /* INPUT */long long A_2, const /* OUTPUT */svOpenArrayHandle A_3, /* INPUT */long long A_4) = NULL;
    if (!_vcs_dpi_stub_initialized_) {
        _vcs_dpi_fp_ = (void (*)(const svOpenArrayHandle A_1, long long A_2, const svOpenArrayHandle A_3, long long A_4)) dlsym(RTLD_NEXT, "dpi_haraka_s");
        _vcs_dpi_stub_initialized_ = 1;
    }
    if (_vcs_dpi_fp_) {
        _vcs_dpi_fp_(A_1, A_2, A_3, A_4);
    } else {
        const char *fileName;
        int lineNumber;
        svGetCallerInfo(&fileName, &lineNumber);
        vcsMsgReport1("DPI-DIFNF", fileName, lineNumber, 0, 0, "dpi_haraka_s");
    }
}
#endif /* __VCS_IMPORT_DPI_STUB_dpi_haraka_s */


#ifdef __cplusplus
}
#endif

