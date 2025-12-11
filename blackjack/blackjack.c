#include "blackjack.h"

#include "print.h"
#include "random.h"
#include "card.h"

int main()
{
  init_lfsrs();
  Card card = {.number = 11, .suit = 2};
  print_card(&card);
}