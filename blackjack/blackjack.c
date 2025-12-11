#include "blackjack.h"

#include "print.h"
#include "random.h"

int main()
{
  init_lfsrs();
  for (int i = 0; i < 10; i++)
  {
    int random = get_random();
    printInt(random, 0xffffff);
    newLine();
  }
}