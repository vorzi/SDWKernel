#include "../../include/config.h"

void int_to_str(int value, char *str) {
  char temp[12];
  int i = 0;
  int is_negative = 0;

  if (value == 0) {
    str[0] = '0';
    str[1] = '\0';
    return;
  }

  if (value < 0) {
    is_negative = 1;
    value = -value;
  }

  while (value > 0) {
    temp[i++] = (value % 10) + '0';
    value /= 10;
  }

  if (is_negative)
    temp[i++] = '-';

  int j = 0;
  while (i--)
    str[j++] = temp[i];
  str[j] = '\0';
}

unsigned int print(const char *msg, unsigned int line, void *var) {
  char *vidmem = (char *)0xb8000;
  unsigned int i = line * 80 * 2;
  char numbuf[12];

  while (*msg != 0) {
    if (*msg == '%' && *(msg + 1) == 's') {
      msg += 2;
      char *str = (char *)var;
      while (*str) {
        vidmem[i++] = *str++;
        vidmem[i++] = TEXT_BYTE;
      }
    } else if (*msg == '%' && *(msg + 1) == 'd') {
      msg += 2;
      int_to_str(*(int *)var, numbuf);
      char *str = numbuf;
      while (*str) {
        vidmem[i++] = *str++;
        vidmem[i++] = TEXT_BYTE;
      }
    } else if (*msg == '%' && *(msg + 1) == 'c') {
      msg += 2;
      char ch = *(char *)var;
      vidmem[i++] = ch;
      vidmem[i++] = TEXT_BYTE;
    } else if (*msg == '\n') {
      line++;
      i = line * 80 * 2;
      msg++;
    } else {
      vidmem[i++] = *msg++;
      vidmem[i++] = TEXT_BYTE;
    }
  }

  return 1;
}
