#include <stdio.h>  // printf
#include <stdlib.h> // malloc

const char ALPHABET[] = "abcdefghijklmnopqrstuvwxyz";
const unsigned int ALPHA_SIZE = 26;
const unsigned int MAX_LEN = 64;
const unsigned int SHIFT = 3;

void block_cipher_encode(const char *input, unsigned int key);
void block_cipher_decode(const char *input, unsigned int key);
char *result;

int main()
{
    result = malloc(sizeof(char)*MAX_LEN);

    block_cipher_encode("aaaaaa", 1);
    block_cipher_decode(result, 1);
}

// input The input string.
// key   The other amount of shift by.
void block_cipher_encode(const char *input, unsigned int key)
{

    // first round of encryption
    for (int i = 0; i < MAX_LEN; i++) {
        result[i] = ALPHABET[(input[i] - 'a' + key) % MAX_LEN];
    }

    // second round of encryption
    for (int i = 0; i < MAX_LEN; i++) {
        result[i] = ALPHABET[(result[i] - 'a' + SHIFT) % MAX_LEN];
    }

    printf("Encrypted: %s\n", result);
}

void block_cipher_decode(const char *input, unsigned int key)
{
    // first round unencrypt, undo second round of encryption
    for (int i = 0; i < MAX_LEN; i++) {
        result[i] = ALPHABET[(input[i] - 'a' - SHIFT) % MAX_LEN];
    }

    // second round unencrypt, undo first round of encryption
    for (int i = 0; i < MAX_LEN; i++) {
        result[i] = ALPHABET[(input[i] - 'a' - key) % MAX_LEN];
    }

    printf("Decrypted: %s\n", result);
}

