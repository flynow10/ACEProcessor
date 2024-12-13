#include "print.h"

int main()
{
    int color = 0;
    char *string = "Hello Dr. Jamieson";
    while (1)
    {
        printString(string, color);
        reset();
        for (int i = 0; i < 0xffffff; i++)
        {
            color++;
        }
    }
    return 0;
}