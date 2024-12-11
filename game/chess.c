#include "chess.h"

// #include "print.h"
#include "board.h"
#include "utils.h"

int main()
{
  // while(1) {
  //   printChar('N');
  //   printChar('a');
  //   printChar('t');
  // }
  Move e4 = createMove(rowColToSquare(4, 1), rowColToSquare(4, 3));
  Board *board = createBoard();

  makeMove(board, e4);

  printBoard(board);

  return board->squares[rowColToSquare(4, 3)];
  return 0;
}