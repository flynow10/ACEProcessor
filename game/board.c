#include "board.h"

#include <stdlib.h>

Board *createBoard()
{
  Board *board = malloc(sizeof(Board));
  board->isWhiteToMove = true;

  GameState *initialState = malloc(sizeof(GameState));
  initialState->castleRights = 0;
  initialState->enPassentFile = -1;
  initialState->fiftyMoveCounter = 0;
  initialState->lastCapture = None;

  board->currentState = initialState;

  for (int i = 0; i < 64; i++)
  {
    board->squares[i] = None;
  }

  return board;
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