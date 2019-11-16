/* https://en.wikipedia.org/wiki/XTEA */

#include <stdint.h>
#include <stdio.h>

/* take 64 bits of data in v[0] and v[1] and 128 bits of key[0] - key[3] */

static void encipher(unsigned int num_rounds, uint32_t v[2], uint32_t const key[4]) {
    unsigned int i;
    uint32_t v0=v[0], v1=v[1], sum=0, delta=0x9E3779B9;
    for (i=0; i < num_rounds; i++) {
        //     ---------tmp1---------------    ---------tmp2--------
        v0 += (((v1 << 4) ^ (v1 >> 5)) + v1) ^ (sum + key[sum & 3]);
        sum += delta;
        //    ----------tmp3----------------    --------tmp4------------
        v1 += (((v0 << 4) ^ (v0 >> 5)) + v0) ^ (sum + key[(sum>>11) & 3]);
    }
    v[0]=v0; v[1]=v1;
}

static void decipher(unsigned int num_rounds, uint32_t v[2], uint32_t const key[4]) {
    unsigned int i;
    uint32_t v0=v[0], v1=v[1], delta=0x9E3779B9, sum=delta*num_rounds;
    for (i=0; i < num_rounds; i++) {
        v1 -= (((v0 << 4) ^ (v0 >> 5)) + v0) ^ (sum + key[(sum>>11) & 3]);
        sum -= delta;
        v0 -= (((v1 << 4) ^ (v1 >> 5)) + v1) ^ (sum + key[sum & 3]);
    }
    v[0]=v0; v[1]=v1;
}

/* ascii must be specified words wide, data is clear */

static void from_ascii(char *ascii, uint32_t *data, unsigned int words)
{
    unsigned int i;
    for(i=0; i < words; i++) {
        data[i] |= ascii[i];
        data[i] <<= 24;
        data[i] |= ascii[i + 1];
        data[i] <<= 16;
        data[i] |= ascii[i + 2];
        data[i] <<= 8;
        data[i] |= ascii[i + 3];
    }
}

int main()
{
    unsigned int i;

    //char *plaintext = "abcdefgh";
    //char *keytext = "1234567812345678";

    unsigned int rounds = 64;
    uint32_t v[2] = { 0xDEADBEEF, 0xFEEBDAED };
    uint32_t key[4] = { 0xFEEDBEEF, 0x00C0FFEE, 0xF0000011, 0x0FACADE0 };

    //from_ascii(plaintext, v, 2);
    //from_ascii(keytext, key, 4);
    encipher(rounds, v, key);

    printf("Enciphered:\n");
    for (i=0; i < 2; i++) {
        printf("%x", v[i]);
    }

    decipher(rounds, v, key);

    printf("\nDeciphered:\n");
    for (i=0; i < 2; i++) {
        printf("%x", v[i]);
    }

    printf("\n");
}
