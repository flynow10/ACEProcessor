#include "chess.h"

#include "movegen.h"
#include "board.h"
#include "utils.h"
#include "print.h"
#include "input.h"
#include <stdbool.h>

int perft(Board *board, int depth);

int main()
{
  Board *board = createBoard();
  MoveSet moveSet;
  generateMoves(board, &moveSet);
  int selectedSquare = 0;
  printBoard(board, selectedSquare);
  bool pressed = false;

  while (1)
  {
    if (pressed && !isKeyPressed(0))
    {
      pressed = false;
    }

    if (!pressed && isKeyPressed(0))
    {
      pressed = true;
      do
      {
        selectedSquare = (selectedSquare + 1) % 64;
      } while (board->squares[selectedSquare] == None);
      printBoard(board, selectedSquare);
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