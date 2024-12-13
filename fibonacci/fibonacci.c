#include "print.h"
#include "input.h"
#include <stdio.h>

char *intToString(int i);
void printValue(int val);

int main()
{
    int val1 = 0;
    int val2 = 1;
    int val3 = 0;

    while (1)
    {
        for (int i = 0; i < 10; i++)
        {
            val3 = val1 + val2;
            printValue(val3);
            newLine();
            val1 = val2 + val3;
            printValue(val1);
            newLine();
            val2 = val1 + val3;
            printValue(val2);
            newLine();
        }
        reset();
    }
}

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
