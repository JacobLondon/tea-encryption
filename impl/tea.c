#include <stdint.h>
#include <stdio.h>

static void encipher (unsigned int rounds, uint32_t v[2], uint32_t k[4]) {
    uint32_t delta=0x9E3779B9;                     /* a key schedule constant */
    uint32_t v0=v[0], v1=v[1], sum=0, i;           /* set up */
    uint32_t k0=k[0], k1=k[1], k2=k[2], k3=k[3];   /* cache key */
    //printf("%x\t%x\n", v0, v1);
    for (i=0; i<rounds; i++) {                         /* basic cycle start */
        sum += delta;
        v0 += ((v1<<4) + k0) ^ (v1 + sum) ^ ((v1>>5) + k1);
        v1 += ((v0<<4) + k2) ^ (v0 + sum) ^ ((v0>>5) + k3);
        //printf("%x\t%x\n", v0, v1);
    }                                              /* end cycle */
    v[0]=v0; v[1]=v1;
}

static void decipher (unsigned int rounds, uint32_t v[2], uint32_t k[4]) {
    uint32_t delta=0x9E3779B9;                     /* a key schedule constant */
    uint32_t v0=v[0], v1=v[1], sum=delta*rounds, i;  /* set up; sum is 32*delta */
    uint32_t k0=k[0], k1=k[1], k2=k[2], k3=k[3];   /* cache key */
    for (i=0; i<rounds; i++) {                         /* basic cycle start */
        v1 -= ((v0<<4) + k2) ^ (v0 + sum) ^ ((v0>>5) + k3);
        v0 -= ((v1<<4) + k0) ^ (v1 + sum) ^ ((v1>>5) + k1);
        sum -= delta;
    }                                              /* end cycle */
    v[0]=v0; v[1]=v1;
}

int main()
{
    unsigned int rounds = 64;
    uint32_t v[2] = { 0xDEADBEEF, 0xFEEBDAED };
    uint32_t key[4] = { 0xFEEDBEEF, 0x00C0FFEE, 0xF0000011, 0x0FACADE0 };

    encipher(rounds, v, key);

    printf("Enciphered:\n");
    for (int i=0; i < 2; i++) {
        printf("%x", v[i]);
    }

    decipher(rounds, v, key);

    printf("\nDeciphered:\n");
    for (int i=0; i < 2; i++) {
        printf("%x", v[i]);
    }

    printf("\n");

    return 0;
}
