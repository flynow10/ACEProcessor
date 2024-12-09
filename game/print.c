#include "print.h"

void printChar(char c, int pos)
{
  int asciiVal = (int)c;
  __asm__("lui t0, 0x10000;"
          "add t0, t0, %1;"
          "mv t1, %0;"
          "lui t2, 0x00fff;"
          "slli t1, t1, 24;"
          "add t1, t1, t2;"
          "addi t1,t1, 0x7ff;"
          "addi t1,t1, 0x7ff;"
          "addi t1,t1, 1;"
          "sw t1, 0(t0);"
          :
          : "r"(asciiVal), "r"(pos)
          :);
}