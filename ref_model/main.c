#include <stdio.h>
#include <stdint.h>
#include <string.h>

// Assuming haraka.h and utils.h are included in the same directory
#include "haraka.h"
#include "utils.h"

// Test the haraka_S function
int main() {
    // Example context (initialize with dummy constants)
    spx_ctx ctx;
    for (int i = 0; i < 64; i++) {
        ctx.pub_seed[i] = i; // Dummy constants
    }

    // Input and output buffers
    unsigned char input[] = "Hello, Haraka!";
    unsigned long long input_len = strlen((const char *)input);
    unsigned char output[64]; // Output buffer
    unsigned long long output_len = 32; // Desired output length

    // Call haraka_S
    haraka_S(output, output_len, input, input_len, &ctx);

    // Print the output
    printf("Output: ");
    for (unsigned long long i = 0; i < output_len; i++) {
        printf("%02X", output[i]);
    }
    printf("\n");

    return 0;
}