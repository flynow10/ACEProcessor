#include "chess.h"

#include "board.h"
#include "utils.h"

int main()
{
  Board *board = createBoard();
  board->squares[rowColToSquare(4, 1)] = WhitePawn;
  Move e4 = createMove(rowColToSquare(4, 1), rowColToSquare(4, 3));

  makeMove(board, e4);

  return board->squares[rowColToSquare(4, 3)];
}