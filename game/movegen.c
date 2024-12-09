#include "movegen.h"

#include "board.h"

void initializeMoveSet(MoveSet *moveset)
{
  moveset->moveCount = 0;
}

void generateMoves(Board *board, MoveSet *moveset)
{
  for (int i = 0; i < 64; i++)
  {
    Piece piece = board->squares[i];
    if ((piece & 0xf) == Pawn && (piece & 0x10) == White)
    {
      Move move = createMove(i, i + 8);
      moveset->moves[moveset->moveCount++] = move;
    }
  }
}