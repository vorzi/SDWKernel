#include "../../include/utils.h"

void sh(int line, char buffer[]) {
  while (1) {
    print("# ", line, "");
    input(buffer, 256, line, 2);

    print(buffer, ++line, "");
    line++;
  }
};
