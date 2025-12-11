#include "input.h"

bool isKeyPressed(int key)
{
  int output = 0;
  __asm__("lui t0, 0x20000;"
          "add t0, t0, %1;"
          "lw t1, 0(t0);"
          "mv %0, t1;"
          : "=r"(output)
          : "r"(key)
          :);
  return output == 0;
}

bool pressed[4] = {false, false, false, false};

void getKeysPressed(bool pressedFrame[4])
{
  for (int i = 0; i < 4; i++)
  {
    if (pressed[i] && !isKeyPressed(i))
    {
      pressed[i] = false;
    }

    if (!pressed[i] && isKeyPressed(i))
    {
      pressed[i] = true;
      pressedFrame[i] = true;
    }
  }
}