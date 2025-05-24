#include <stdio.h>
#include <stdint.h>
#include <string.h>

// Assuming haraka.h and utils.h are included in the same directory
#include "utils.h"
#include "randombytes.c"
#include "haraka.c"


// Function to log data to a file
void log_to_file(const char *filename, const unsigned char *message, 
                 const unsigned char *pk_seed, const unsigned char *sk_seed, const unsigned char *output, unsigned long long output_len) {
    FILE *file = fopen(filename, "a"); // Open file in append mode
    if (file == NULL) {
        perror("Error opening log file");
        return;
    }

    fprintf(file, "Message: %s\n", message);

    fprintf(file, "Public Key (ctx.pk_seed): ");
    for (unsigned long long i = 0; i < SPX_N; i++) {
        fprintf(file, "%02X", pk_seed[i]);
    }
    fprintf(file, "\n");

    fprintf(file, "Secret Key (ctx.sk_seed): ");
    for (unsigned long long i = 0; i < SPX_N; i++) {
        fprintf(file, "%02X", sk_seed[i]);
    }
    fprintf(file, "\n");

    fprintf(file, "Output: ");
    for (unsigned long long i = 0; i < output_len; i++) {
        fprintf(file, "%02X", output[i]);
    }
    fprintf(file, "\n\n");

    fclose(file);
}


// Test the haraka_S function
int main() {
    
    spx_ctx ctx;

    // initially assume the sk_seed , pub_seed, tweaked256_rc32 and tweaked512_rc64 are zero 
    memset(ctx.sk_seed, 0, SPX_N);
    memset(ctx.pub_seed, 0, SPX_N);
    memset(ctx.tweaked256_rc32, 0, sizeof(ctx.tweaked256_rc32));
    memset(ctx.tweaked512_rc64, 0, sizeof(ctx.tweaked512_rc64));


    //* this is how the SPHINCS+ guys define the sk_seed , pub_seed, tweaked256_rc32 and tweaked512_rc64 
    // randombytes(ctx.sk_seed, SPX_N);
    // randombytes(ctx.pub_seed, SPX_N);
    // tweak_constants(&ctx);
   
    // Input and output buffers
    unsigned char input[] = "Hello";
    unsigned long long input_len = strlen((const char *)input);
    unsigned char output[64]; // Output buffer
    unsigned long long output_len = 32; // Desired output length

    // Call haraka_S
    haraka_S(output, output_len, input, input_len, &ctx);

    log_to_file("haraka_log.txt", input, ctx.pub_seed, ctx.sk_seed, output, output_len);


    // Print the output
    printf("\nOutput: ");
    for (unsigned long long i = 0; i < output_len; i++) {
        printf("%02x", output[i]);
    }
    printf("\n");


    return 0;
}