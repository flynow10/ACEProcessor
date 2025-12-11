#include "blackjack.h"

#include "print.h"
#include "random.h"
#include "card.h"

int main()
{
  init_lfsrs();
  printString("Blackjack!", 0xffffff);
  newLine();

  Card card = {.number = 11, .suit = 2};
  print_card(&card);
}