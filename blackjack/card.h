#ifndef card_h
#define card_h

typedef int Suit;

/*
Suits
0 = hearts
1 = clubs
2 = diamonds
3 = spades
*/
/*
1 = ace
2 - 10 = numbers
11 = jack
12 = queen
13 = king
*/
typedef struct t_Card
{
  Suit suit;
  int number;
} Card;

int hand_value(Card *hand, int handSize);

void shuffle_deck(Card *deck, int deckSize);

void print_card(Card *card);

void initialize_deck(Card *deck, int deckSize);

#endif