#include "card.h"

int handValue(Card *hand, int handSize)
{
  int sum = 0;
  for (int i = 0; i < handSize; i++)
  {
    sum += hand[i].number;
  }
  return sum;
}

void shuffleDeck(Card *deck, int deckSize)
{
}