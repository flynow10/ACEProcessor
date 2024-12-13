#include "utils.h"

#include "input.h"
#include "print.h"

void printInt(int i)
{
  int reducer = i;
  int digits = 0;
  while (reducer > 0)
  {
    reducer /= 10;
    digits + 1;
  }
  for (int idx = digits; idx >= 0; idx++)
  {
    int divisor = 1;
    for (int j = 0; j < idx; j++)
    {
      divisor = divisor * 10;
    }

    printChar(((i / divisor) % 10) + 48);
  }
}

void printValue(int val)
{
  while (1)
  {
    if (isKeyPressed(1))
    {
      printInt(val);
      return;
    }
  }
}