#include "card.h"

#include "random.h"
#include "print.h"

int hand_value(Card *hand, int handSize)
{
  int sum = 0;
  for (int i = 0; i < handSize; i++)
  {
    sum += hand[i].number;
  }
  return sum;
}

void shuffle_deck(Card *deck, int deckSize)
{
  int iter = 3000;
  for (int i = 0; i < iter; i++)
  {
    int newIndex = get_random() % deckSize;
    Card zero = deck[0];
    deck[0] = deck[newIndex];
    deck[newIndex] = zero;
  }
}

void initialize_deck(Card *deck, int deckSize)
{
  for (Suit suit = 0; suit < 4; suit++)
  {
    for (int rank = 1; rank <= 13; rank++)
    {
      int i = suit * 13 + rank - 1;
      if (i >= deckSize)
      {
        break;
      }
      deck[i].suit = suit;
      deck[i].number = rank;
    }
  }
}

/*
+=======+
|1      |
|
|
|
|

*/

int print_card_number(int number)
{
  switch (number)
  {
  case 1:
    printString("A", 0xffffff);
    return 1;
  case 2:
    printString("2", 0xffffff);
    return 1;
  case 3:
    printString("3", 0xffffff);
    return 1;
  case 4:
    printString("4", 0xffffff);
    return 1;
  case 5:
    printString("5", 0xffffff);
    return 1;
  case 6:
    printString("6", 0xffffff);
    return 1;
  case 7:
    printString("7", 0xffffff);
    return 1;
  case 8:
    printString("8", 0xffffff);
    return 1;
  case 9:
    printString("9", 0xffffff);
    return 1;
  case 10:
    printString("10", 0xffffff);
    return 2;
  case 11:
    printString("J", 0xffffff);
    return 1;
  case 12:
    printString("Q", 0xffffff);
    return 1;
  case 13:
    printString("K", 0xffffff);
    return 1;
  }
  return 0;
}
void print_card(Card *card)
{
  int lineStart = getCurrentPos() / 80;
  int linePosStart = getCurrentPos() % 80;
  int line = 0;
  printString("+=====+", 0xffffff);
  setCurrentPos(lineStart * 80 + linePosStart + 80 * line++);
  printChar('|');
  int numChars = print_card_number(card->number);
  if (numChars == 1)
  {
    printString("    |", 0xffffff);
  }
  else
  {
    printString("   |", 0xffffff);
  }
  setCurrentPos(lineStart * 80 + linePosStart + 80 * line++);
  printString("|     |", 0xffffff);
  setCurrentPos(lineStart * 80 + linePosStart + 80 * line++);
  printString("|     |", 0xffffff);
  setCurrentPos(lineStart * 80 + linePosStart + 80 * line++);
  printString("|  ", 0xffffff);
  switch (card->suit)
  {
  case 0:
    printChar('H');
    break;
  case 1:
    printChar('C');
    break;
  case 2:
    printChar('D');
    break;
  case 3:
    printChar('S');
    break;
  }
  printString("  |", 0xffffff);
  setCurrentPos(lineStart * 80 + linePosStart + 80 * line++);
  ;
  printString("|     |", 0xffffff);
  setCurrentPos(lineStart * 80 + linePosStart + 80 * line++);
  ;
  printString("|     |", 0xffffff);
  setCurrentPos(lineStart * 80 + linePosStart + 80 * line++);
  ;
  if (numChars == 1)
  {
    printString("|    ", 0xffffff);
  }
  else
  {
    printString("|   ", 0xffffff);
  }
  print_card_number(card->number);
  printChar('|');
  setCurrentPos(lineStart * 80 + linePosStart + 80 * line++);
  printString("+=====+", 0xffffff);
  setCurrentPos((linePosStart / 80) + (getCurrentPos() % 80));
}