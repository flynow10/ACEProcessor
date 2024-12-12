#include "chess.h"

#include "movegen.h"
#include "board.h"
#include "utils.h"
#include "print.h"

int perft(Board *board, int depth);

int main()
{
  int color = 0;
  while (1)
  {
    reset();
    for (int i = 33; i < 127; i++)
    {
      printColorChar((char)(i), color);
      color++;
      if (color >= 0xffffff)
      {
        color = 0;
      }
    }
  }
  return 0;
}

int perft(Board *board, int depth)
{
  MoveSet moveSet;
  generateMoves(board, &moveSet);
  if (depth == 1)
  {
    return moveSet.moveCount;
  }

  int sum = 0;
  for (int i = 0; i < moveSet.moveCount; i++)
  {
    makeMove(board, moveSet.moves[i]);
    sum += perft(board, depth - 1);
    undoMove(board, moveSet.moves[i]);
  }

  return sum;
}