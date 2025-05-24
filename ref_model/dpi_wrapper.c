#include <svdpi.h>
#include <stdio.h>
#include <stdint.h>
#include <string.h>
#include "utils.h"
#include "haraka.c"

// unsigned char output[64]; // Output buffer
// unsigned long long output_len = 32; // Desired output length

void dpi_haraka_s(const svOpenArrayHandle input_data, long long input_len, const svOpenArrayHandle output_data, long long output_len ) {
    
    // Convert SV dynamic arrays to C pointers
    const unsigned char *input = (const unsigned char *)svGetArrayPtr(input_data);
    const unsigned char *output = (const unsigned char *)svGetArrayPtr(output_data);
    spx_ctx ctx;

    // Log input data as hex
    printf("\nInput data (hex): ");
    for (unsigned long long i = 0; i < input_len; i++) {
        printf("%02x", input[i]);
    }
    printf("\n");

    printf("\nDPI input_len: %lld, output_len: %d\n", input_len, output_len);

    memset(ctx.sk_seed, 0, SPX_N);
    memset(ctx.pub_seed, 0, SPX_N);

    memset(ctx.tweaked256_rc32, 0, sizeof(ctx.tweaked256_rc32));
    memset(ctx.tweaked512_rc64, 0, sizeof(ctx.tweaked512_rc64));
    haraka_S(output, output_len, input, input_len, &ctx);

    // // Print the output
    // printf("\nOutput: ");
    // for (unsigned long long i = 0; i < output_len; i++) {
    //     printf("%02x", output[i]);
    // }
    // printf("\n");

}
