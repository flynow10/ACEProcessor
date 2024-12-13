#ifndef movegen_h
#define movegen_h

#include "move.h"
#include "board.h"
#include <stdbool.h>

typedef struct moveset_t
{
  Move moves[256];
  int moveCount;
  bool isInCheck;
} MoveSet;

void initializeMoveSet(MoveSet *moveSet);

void generateMoves(Board *board, MoveSet *moves);

void generatePawnMoves(Board *board, MoveSet *moveSet, int square);
void generatePromotion(Board *board, MoveSet *moveSet, int start, int end);

void generateKnightMoves(Board *board, MoveSet *moveSet, int square);

void generateOrthogonalMoves(Board *board, MoveSet *moveSet, int square);
void generateDiagonalMoves(Board *board, MoveSet *moveSet, int square);
void generateSlidingMoves(Board *board, MoveSet *moveSet, int square, int dirStart, int dirEnd);

void generateKingMoves(Board *board, MoveSet *moveSet, int square);

void writeMove(Board *board, MoveSet *moveSet, Move move);
bool isInCheck(Board *board, bool white);
bool isPawnAttacking(Board *board, int square, int kingSquare);
bool isKnightAttacking(Board *board, int square, int kingSquare);
bool isSlideAttacking(Board *board, int square, int kingSquare, int dirStart, int dirEnd);
bool isKingAttacking(Board *board, int square, int kingSquare);

void printMoveSet(MoveSet *moveSet);
void printMove(Move move);
void printSquare(int square);

#endif