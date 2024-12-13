#include "print.h"

#include <string.h>

int main()
{
    int color = 0;
    char *string = "Hello Dr. Jamieson";
    while (1)
    {
        for (int i = 0; i < strlen(string); i++)
        {
            printColorChar(string[i], color);
            color++;
            if (color > 0xffffff)
            {
                color = 0;
            }
        }
        reset();
    }
    return 0;
}