#include "../../include/config.h"

unsigned int print(char *message, unsigned int line) {
  char *vidmem = (char *)0xb8000;
  unsigned int i = 0;

  i = (line * 80 * 2);

  while (*message != 0) {
    if (*message == '\n') {
      line++;
      i = (line * 80 * 2);
      message++;
    } else {
      vidmem[i] = *message;
      message++;
      i++;
      vidmem[i] = WHITE_TEXT;
      i++;
    };
  }

  return (1);
};
