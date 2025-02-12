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
    round++;
    if (round >= 256)
      round = -256;
  }
}

int getColor(int x, int y, int round)
{
  int ir = (int)((x * 256) / WIDTH);
  int ig = (int)((y * 256) / HEIGHT);
  int ib = round >= 0 ? round : -round;
  return (ir << 16) | (ig << 8) | (ib & 0xff);
}