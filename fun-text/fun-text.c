#include "print.h"

int main()
{
    int color = 0;
    char *string = "Hello Dr. Jamieson";
    while (1)
    {
        printString(string, color);
        reset();
        color++;
        if (color > 0xffffff)
        {
            color = 0;
        }
    }
    return 0;
}