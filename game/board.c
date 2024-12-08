#include "board.h"

#include <stdlib.h>

Board *createBoard()
{
  Board *board = malloc(sizeof(Board));
  board->isWhiteToMove = true;

    board->currentState = createState();

  for (int i = 0; i < 64; i++)
  {
    board->squares[i] = None;
  }

  return board;
}

void initializeBoard(Board *board)
{
  board->isWhiteToMove = true;
  for (int i = 0; i < 64; i++)
  {
    board->squares[i] = None;
  }

  deleteStateStack(board->currentState);
  board->currentState = createState();

  board->squares[0] = WhiteRook;
  board->squares[1] = WhiteKnight;
  board->squares[2] = WhtieBishop;
  board->squares[3] = WhiteQueen;
  board->squares[4] = WhiteKing;
  board->squares[5] = WhtieBishop;
  board->squares[6] = WhiteKnight;
  board->squares[7] = WhiteRook;
  board->squares[8] = WhitePawn;
  board->squares[9] = WhitePawn;
  board->squares[10] = WhitePawn;
  board->squares[11] = WhitePawn;
  board->squares[12] = WhitePawn;
  board->squares[13] = WhitePawn;
  board->squares[14] = WhitePawn;
  board->squares[15] = WhitePawn;

  board->squares[48] = BlackPawn;
  board->squares[49] = BlackPawn;
  board->squares[50] = BlackPawn;
  board->squares[51] = BlackPawn;
  board->squares[52] = BlackPawn;
  board->squares[53] = BlackPawn;
  board->squares[54] = BlackPawn;
  board->squares[55] = BlackPawn;
  board->squares[56] = BlackRook;
  board->squares[57] = BlackKnight;
  board->squares[58] = BlackBishop;
  board->squares[59] = BlackQueen;
  board->squares[60] = BlackKing;
  board->squares[61] = BlackBishop;
  board->squares[62] = BlackKnight;
  board->squares[63] = BlackRook;
}

bool makeMove(Board *board, Move move)
{
  Piece pieceToMove = board->squares[move.startSquare];
  if (pieceToMove == None || ((pieceToMove & 0x10) == White) != board->isWhiteToMove)
  {
    return false;
  }

  Piece captured = board->squares[move.endSquare];

  GameState gameState = *board->currentState;
  gameState.lastCapture = captured;
  gameState.lastGameState = board->currentState;
  if (captured == None && (pieceToMove & 0xF) != Pawn)
  {
    gameState.fiftyMoveCounter++;
  }

  if (move.promotion != Empty)
  {
    board->squares[move.endSquare] = move.promotion | (board->isWhiteToMove ? White : Black);
  }
  else
  {
    board->squares[move.endSquare] = pieceToMove;
  }

  board->squares[move.startSquare] = None;

  board->isWhiteToMove = !board->isWhiteToMove;
  return true;
}

void undoMove(Board *board, Move move)
{
  Piece movedPiece = board->squares[move.endSquare];

  board->squares[move.startSquare] = movedPiece;

  GameState *currentState = board->currentState;
  board->currentState = currentState->lastGameState;

  board->squares[move.endSquare] = currentState->lastCapture;

  board->isWhiteToMove = !board->isWhiteToMove;

  free(currentState);
}