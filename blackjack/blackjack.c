#include "blackjack.h"

#include "print.h"
#include "random.h"
#include "card.h"

int main()
{
  init_lfsrs();
  printString("Blackjack!", 0xffffff);
  newLine();

  Card card1 = {.number = 11, .suit = 2};
  Card card2 = {.number = 2, .suit = 0};
  print_card(&card1);
  printChar(' ');
  print_card(&card2);
}