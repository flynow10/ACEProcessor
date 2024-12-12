#include "move.h"

Move createMove(int start, int end)
{
  Move move = {.startSquare = start, .endSquare = end, .promotion = Empty};
  return move;
}

Move createPromotion(int start, int end, PieceType promotion)
{
  Move move = {.startSquare = start, .endSquare = end, .promotion = promotion};
  return move;
}