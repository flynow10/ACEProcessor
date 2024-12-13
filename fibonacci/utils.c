#include "utils.h"

#include "input.h"
#include "print.h"

void printInt(int i)
{
  if (i < 0)
  {
    printChar('-');
    i = -i;
  }
  if (i / 10)
    printInt(i / 10);
  printChar(i % 10 + '0');
}

void printValue(int val)
{
  while (1)
  {
    if (!isKeyPressed(1))
    {
      break;
    }
  }
  while (1)
  {
    if (isKeyPressed(1))
    {
      printInt(val);
      return;
    }
  }
}