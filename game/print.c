#include "print.h"

// #include <stdio.h>

void printCharPos(char c, int pos, int color)
{
  int asciiVal = (int)c;
  __asm__("lui t0, 0x10000;"
          "add t0, t0, %1;"
          "mv t1, %0;"
          "mv t2, %2;"
          "slli t1, t1, 24;"
          "or t1, t1, t2;"
          "sw t1, 0(t0);"
          :
          : "r"(asciiVal), "r"(pos), "r"(color)
          :);
}

int currentPos = 0;

void printChar(char c)
{
  printColorChar(c, 0xffffff);
}

void printColorChar(char c, int color)
{
  printCharPos(c, currentPos, color);
  currentPos++;
}
void newLine()
{
  // printf("\n");
  currentPos -= (currentPos % 80);
  currentPos += 80;
}

void reset()
{
  currentPos = 0;
}