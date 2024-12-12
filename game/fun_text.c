#include "print.h"

int main()
{
    int color = 0;
    while (1)
    {
        reset();
        for (int i = 33; i < 127; i++)
        {
            printColorChar((char)(i), color);
            color++;
            if (color >= 0xffffff)
            {
                color = 0;
            }
        }
    }
    return 0;
}