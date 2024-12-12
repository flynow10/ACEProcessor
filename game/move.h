#ifndef move_h
#define move_h

#include "types.h"
#include <stdbool.h>

typedef struct t_Move
{
  int startSquare;
  int endSquare;
  PieceType promotion;
} Move;

Move createMove(int start, int end);
Move createPromotion(int start, int end, PieceType promotion);

#endif