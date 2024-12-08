#ifndef movegen_h
#define movegen_h

#include "move.h"
#include "board.h"

typedef struct moveset_t
{
  Move moves[256];
  int moveCount;
} MoveSet;

void initializeMoveSet(MoveSet *moveset);

void generateMoves(Board *board, MoveSet *moves);

#endif