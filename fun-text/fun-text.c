#include "print.h"

#include <string.h>

int main()
{
    int red = 0;
    int green = 0;
    int blue = 0;
    char *string = "Hello Dr. Jamieson!";
    while (1)
    {
        printString("Simple VGA color test:", 0xffffff);
        newLine();
        for (int i = 0; i < strlen(string); i++)
        {
            printColorChar(string[i], (red << 16) | (green << 8) | blue);
            red = (red + 0x4) % 0xff;
            green = (green + 0x2) % 0xff;
            blue = (blue + 1) % 0xff;
        }
        for (int i = 0; i < 250000; i++)
        {
            // wait for a time
        }
        reset();
    }
    return 0;
}