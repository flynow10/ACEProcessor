#include "utils.h"

#include "input.h"
#include "print.h"

char *intToString(int i)
{
  char *str = "000000000000000";
  int idx = 0;
  while (i > 0)
  {
    str[idx++] = (char)((i % 10) + 48);
    i /= 10;
  }
  char reversedStr[idx];
  for (int k = 0; k < idx; k++)
  {
    reversedStr[k] = str[idx - k];
  }
  return reversedStr;
}

void printValue(int val)
{
  while (1)
  {
    if (isKeyPressed(1))
    {
      printString(intToString(val), 0xffffff);
      return;
    }
  }
}