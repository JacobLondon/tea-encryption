#include <stdio.h> // printf

// arbitrary prime number and seed number
const unsigned int PRIME = 0x01000193; //   16777619
const unsigned int SEED  = 0x811C9DC5; // 2166136261

unsigned int hash(const char *text);

int main()
{
    char *text = "hash this!";
    unsigned int result = hash("hash this!");
    printf("Hash of '%s' is %u\n", text, result);
}

// FNV1A (Fower-Noll-Vo) hash function
unsigned int hash(const char *text)
{
    unsigned int hash = SEED;
    while (*text)
        hash = (*text++ ^ hash) * PRIME;

    return hash;
}

