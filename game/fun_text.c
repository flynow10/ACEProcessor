#include "print.h"

int main() {
    int color; 
    while(1) {
        for (int i = 33; i < 127; i++) {
            printColorChar((char)(i), color);
            color++;
        }
        if (color >= 16777216) {
            color = 0;
        }
    }
    return 0;
}