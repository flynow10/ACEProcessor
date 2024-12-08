#include "move.h"

Move createMove(int start, int end)
{
  Move move = {.startSquare = start, .endSquare = end, .promotion = Empty};
  return move;
}