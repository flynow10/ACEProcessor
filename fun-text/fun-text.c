#include "print.h"

#include <string.h>

int main()
{
    int color = 0;
    char *string = "Hello Dr. Jamieson!";
    while (1)
    {
        for (int i = 0; i < strlen(string); i++)
        {
            printColorChar(string[i], color);
            color += 0x40201;
            if (color > 0xffffff)
            {
                color = color % 0xffffff;
            }
        }
        for (int i = 0; i < 2500000; i++)
        {
            // wait for a time
        }
        reset();
    }
    return 0;
}