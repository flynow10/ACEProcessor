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
            color += 0x421;
            if (color > 0xffffff)
            {
                color = color % 0xffffff;
            }
        }
        reset();
    }
    return 0;
}