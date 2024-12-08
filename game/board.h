#ifndef board_h
#define board_h

#include <stdbool.h>
#include "types.h"
#include "move.h"

typedef struct t_GameState GameState;

struct t_GameState
{
  int fiftyMoveCounter;
  int enPassentFile;
  int castleRights;
  Piece lastCapture;
  GameState *lastGameState;
};

typedef struct t_Board
{
  Piece squares[64];
  bool isWhiteToMove;
  GameState *currentState;
} Board;

Board *createBoard();

bool makeMove(Board *board, Move move);
void undoMove(Board *board, Move move);

#endif