#include "chess.h"

#include "movegen.h"
#include "board.h"
#include "utils.h"
#include "print.h"
#include <stdlib.h>
#include <stdio.h>
#include <time.h>

int perft(Board *board, int depth);

int main()
{
  Board *board = createBoard();

  // printf("%d", perft(board, 4));

  return board->squares[rowColToSquare(3, 4)];
}

int perft(Board *board, int depth)
{
  MoveSet moveSet;
  generateMoves(board, &moveSet);
  if (depth == 0)
  {
    return 1;
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