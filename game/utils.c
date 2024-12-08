#include "utils.h"

int rowColToSquare(int row, int col)
{
  return (row * 8) + col;
}

int squareToRow(int square)
{
  return square / 8;
}

int squareToCol(int square)
{
  return square % 8;
}