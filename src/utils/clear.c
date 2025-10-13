#include "../../include/config.h"

void clear() {
  char *vidmem = (char *)0xb8000;
  unsigned int i = 0;

  while (i < (80 * 25 * 2)) {
    vidmem[i] = ' ';
    i++;
    vidmem[i] = TEXT_BYTE;
    i++;
  };
};
