#include "print.h"

int getColor(int x, int y, int round);

static int WIDTH = 80;
static int HEIGHT = 60;

int main()
{
  for (int round = 0; round < 255; round++)
  {
    for (int row = 0; row < HEIGHT; row++)
    {
      for (int col = 0; col < WIDTH; col++)
      {
        printCharPos(0x1, row * WIDTH + col, getColor(col, row, round));
      }
    }
  }

  while (1)
  {
  }
}

int getColor(int x, int y, int round)
{
  float r = (float)x / WIDTH;
  float g = (float)y / HEIGHT;
  float b = (float)round / 256;

  int ir = (int)(r * 256);
  int ig = (int)(g * 256);
  int ib = (int)(b * 256);
  return (ir << 16) | (ig << 8) | ib;
}