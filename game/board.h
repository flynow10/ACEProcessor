#ifndef board_h
#define board_h

#include <stdbool.h>
#include "types.h"
#include "move.h"
#include "gamestate.h"

typedef struct t_Board
{
  Piece squares[64];
  bool isWhiteToMove;
  GameState *currentState;
} Board;

Board *createBoard();
void initializeBoard(Board *board);

bool makeMove(Board *board, Move move);
void undoMove(Board *board, Move move);

void printBoard(Board *board, int selectedSquare);
void printPiece(Piece piece, int color);
#endif