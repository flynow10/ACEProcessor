#include "print.h"

int getColor(int x, int y);

static int WIDTH = 80;
static int HEIGHT = 60;

int main()
{
  for (int row = 0; row < WIDTH; row++)
  {
    for (int col = 0; col < HEIGHT; col++)
    {
      printCharPos(0x1, row * WIDTH + col, getColor(col, row));
    }
  }
  while (1)
  {
  }
}

int getColor(int x, int y)
{
  float r = (float)x / WIDTH;
  float g = (float)y / HEIGHT;
  float b = 0;

  int ir = (int)(r * 256);
  int ig = (int)(g * 256);
  int ib = (int)(b * 256);
  return (ir << 16) | (ig << 8) | ib;
}