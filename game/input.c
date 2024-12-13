#include "input.h"

bool isKeyPressed(int key)
{
  int output = 0;
  __asm__("lui t0, 0x20000;"
          "add t0, t0, %1;"
          "lw %0, 0(t0);"
          : "=r"(output)
          : "r"(key)
          :);
  return output == 1;
}