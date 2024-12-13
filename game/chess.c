#include "chess.h"

#include "movegen.h"
#include "board.h"
#include "utils.h"
#include "print.h"
#include "input.h"

int perft(Board *board, int depth);

int main()
{
  // Board *board = createBoard();
  // MoveSet moveSet;
  // for (int i = 0; i < 20; i++)
  // {
  //   generateMoves(board, &moveSet);

  //   makeMove(board, moveSet.moves[2]);
  // }
  // printBoard(board);

  while (1)
  {
    reset();
    if (isKeyPressed(0))
    {
      printString("Pressed!    ", 0xffffff);
    }
    else
    {
      printString("Not pressed!", 0xffffff);
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