#include "chess.h"

#include "print.h"
// #include "board.h"
// #include "utils.h"

int main()
{
  printChar('G', 0);
  printChar('a', 1);
  printChar('b', 2);
  printChar('e', 3);
  return 0;
  // Board *board = createBoard();
  // board->squares[rowColToSquare(4, 1)] = WhitePawn;
  // Move e4 = createMove(rowColToSquare(4, 1), rowColToSquare(4, 3));

  // makeMove(board, e4);

  // return board->squares[rowColToSquare(4, 3)];
}