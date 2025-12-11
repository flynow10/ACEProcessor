#ifndef card_h
#define card_h

typedef int Suit;

typedef struct t_Card
{
  Suit suit;
  int number;
} Card;

int handValue(Card *hand, int handSize);

void shuffleDeck(Card *deck, int deckSize);

void printCard(Card *card);

#endif