#include "../../include/utils.h"

extern void asm_get_cpu(char *buffer);

CPUIType get_cpu_info() {
  char buffer[32];
  CPUIType info;

  asm_get_cpu(buffer);

  for (int i = 0; i < 12; i++)
    info.vendor[i] = buffer[i];
  info.vendor[12] = '\0';

  unsigned int eax = *(unsigned int *)(buffer + 12);
  unsigned int ecx = *(unsigned int *)(buffer + 16);
  unsigned int edx = *(unsigned int *)(buffer + 20);

  info.stepping = eax & 0xF;
  info.model = (eax >> 4) & 0xF;
  info.family = (eax >> 8) & 0xF;

  info.has_sse = (edx >> 25) & 1;
  info.has_sse2 = (edx >> 26) & 1;
  info.has_sse3 = (ecx >> 0) & 1;
  info.has_ssse = (ecx >> 9) & 1;
  info.has_sse4_1 = (ecx >> 19) & 1;
  info.has_aes = (ecx >> 25) & 1;
  info.has_sha = (ecx >> 29) & 1;

  return info;
};
