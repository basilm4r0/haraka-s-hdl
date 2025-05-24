#include <stdio.h>
#include <stdint.h>
#include <string.h>
#include <assert.h>

// Functions to be tested
static inline uint32_t br_dec32le(const unsigned char *src)
{
    
    return (uint32_t)src[0]
           | ((uint32_t)src[1] << 8)
           | ((uint32_t)src[2] << 16)
           | ((uint32_t)src[3] << 24);
}

static void br_range_dec32le(uint32_t *v, size_t num, const unsigned char *src)
{
    while (num-- > 0) {
        *v++ = br_dec32le(src);
        src += 4;
    }
}

// Test helper
void test_br_dec32le()
{
    unsigned char data[4] = {0x78, 0x56, 0x34, 0x12}; // should produce 0x12345678
    uint32_t result = br_dec32le(data);
    assert(result == 0x12345678);
    printf("br_dec32le passed!\n");
}

void test_br_range_dec32le()
{
    unsigned char data[8] = {
        0x01, 0x00, 0x00, 0x00,   // 0x00000001
        0xEF, 0xBE, 0xAD, 0xDE    // 0xDEADBEEF
    };
    uint32_t expected[2] = {0x00000001, 0xDEADBEEF};
    uint32_t output[2] = {0};

    br_range_dec32le(output, 2, data);

    assert(memcmp(output, expected, sizeof(expected)) == 0);
    printf("br_range_dec32le passed!\n");
}

int main()
{
    test_br_dec32le();
    test_br_range_dec32le();
    printf("All tests passed.\n");
    return 0;
}
