#include "../../include/config.h"
#include "../../include/utils.h"

char scancodes_ascii[128] = {
    0,   27,   '1',  '2', '3',  '4', '5', '6', '7', '8', '9', '0', '-',
    '=', '\b', '\t', 'q', 'w',  'e', 'r', 't', 'y', 'u', 'i', 'o', 'p',
    '[', ']',  '\n', 0,   'a',  's', 'd', 'f', 'g', 'h', 'j', 'k', 'l',
    ';', '\'', '`',  0,   '\\', 'z', 'x', 'c', 'v', 'b', 'n', 'm', ',',
    '.', '/',  0,    '*', 0,    ' ', 0,   0,   0,   0,   0,   0,   0,
    0,   0,    0,    0,   0,    0,   0,   0,   0,   0,   0,   0,   0,
    0,   0,    0,    0,   0,    0,   0,   0}; // Adicione mais se quiser

unsigned char getScancode() {
  unsigned char scancode;
  asm volatile("1:\n\t"
               "inb $0x64, %%al\n\t"
               "test $1, %%al\n\t"
               "jz 1b \n\t"
               "inb $0x60, %0"
               : "=a"(scancode)
               :
               : "memory");

  return scancode;
};

int input(char *buffer, int max_length, int line, int col_start) {
  int i = 0;
  int col = col_start;

  char *vidmem = (char *)0xb8000;

  while (1) {
    unsigned char sc = getScancode();

    if (sc & 0x80)
      continue;

    char c = scancodes_ascii[sc];

    if (!c)
      continue;

    if (c == '\n') {
      buffer[i] = '\0';
      break;
    } else if (c == '\b') {
      if (i > 0) {
        i--;
        col--;

        if (col < 0)
          col = 0;

        int pos = (line * 80 + col) * 2;
        vidmem[pos] = ' ';
        vidmem[pos + 1] = TEXT_BYTE;
      };
    } else if (i < max_length - 1 && col < 80) {
      buffer[i++] = c;

      int pos = (line * 80 + col++) * 2;
      vidmem[pos] = c;
      vidmem[pos + 1] = TEXT_BYTE;
    };
  };

  return i;
};
