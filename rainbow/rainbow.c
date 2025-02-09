#define DEFINE_MALLOC
#include "print.h"
// #include "tiny-malloc.c"
#include <string.h>
#include <stdlib.h>

int getColor(int x, int y, int round);

static int WIDTH = 80;
static int HEIGHT = 60;

int main()
{
  // int nums[] = {0, 1, 2, 3, 4};
  // int *memNums = malloc(5 * sizeof(int));

  // memcpy(memNums, nums, 5 * sizeof(int));

  // for (size_t i = 0; i < 5; i++)
  // {
  //   printInt(memNums[i], 0xffffff);
  // }

  int round = 0;
  while (1)
  {
    for (int row = 0; row < HEIGHT; row++)
    {
      for (int col = 0; col < WIDTH; col++)
      {
        printCharPos(0x1, row * WIDTH + col, getColor(col, row, round));
      }
    }
    round = (round + 30) % 256;
  }
}

int getColor(int x, int y, int round)
{
  float r = (float)x / WIDTH;
  float g = (float)y / HEIGHT;
  // float b = (float)round / 256;

  int ir = (int)(r * 256);
  int ig = (int)(g * 256);
  int ib = (int)(round);
  return (ir << 16) | (ig << 8) | ib;
}