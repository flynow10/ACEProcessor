#include "movegen.h"

#include <stdbool.h>
#include <stdio.h>
#include "print.h"
#include "board.h"
#include "utils.h"

void initializeMoveSet(MoveSet *moveset)
{
  moveset->moveCount = 0;
}

void writeMove(Board *board, MoveSet *moveSet, Move move)
{
  bool isWhite = board->isWhiteToMove;
  makeMove(board, move);

  if (!isInCheck(board, isWhite))
  {
    moveSet->moves[moveSet->moveCount++] = move;
  }

  undoMove(board, move);
}

bool isInCheck(Board *board, bool white)
{
  int kingSquare = 0;
  for (int i = 0; i < 64; i++)
  {
    Piece piece = board->squares[i];
    if (((piece & 0x10) == White) == white && (piece & 0xf) == King)
    {
      kingSquare = i;
      break;
    }
  }

  for (int i = 0; i < 64; i++)
  {
    Piece piece = board->squares[i];
    if (((piece & 0x10) == White) != white)
    {
      switch (piece & 0xf)
      {
      case Pawn:
        if (isPawnAttacking(board, i, kingSquare))
        {
          return true;
        }
        break;
      case Knight:
        if (isKnightAttacking(board, i, kingSquare))
        {
          return true;
        }
        break;
      case Rook:
        if (isSlideAttacking(board, i, kingSquare, 0, 4))
        {
          return true;
        }
        break;
      case Bishop:
        if (isSlideAttacking(board, i, kingSquare, 4, 8))
        {
          return true;
        }
        break;
      case Queen:
        if (isSlideAttacking(board, i, kingSquare, 0, 8))
        {
          return true;
        }
        break;
      case King:
        if (isKingAttacking(board, i, kingSquare))
        {
          return true;
        }
        break;
      }
    }
  }
  return false;
}

bool isPawnAttacking(Board *board, int square, int kingSquare)
{
  Piece piece = board->squares[square];
  bool isWhite = (piece & 0x10) == White;
  int col = squareToCol(square);

  if (isWhite)
  {
    if (col != 0 && square + 7 == kingSquare)
    {
      return true;
    }
    if (col != 7 && square + 9 == kingSquare)
    {
      return true;
    }
  }
  else
  {
    if (col != 7 && square - 7 == kingSquare)
    {
      return true;
    }
    if (col != 0 && square - 9 == kingSquare)
    {
      return true;
    }
  }
  return false;
}

bool isKnightAttacking(Board *board, int square, int kingSquare)
{
  int row = squareToRow(square);
  int col = squareToCol(square);

  int rowOffsets[8] = {2, 2, 1, -1, -2, -2, -1, 1};
  int colOffsets[8] = {-1, 1, 2, 2, 1, -1, -2, -2};

  for (int i = 0; i < 8; i++)
  {
    int endRow = row + rowOffsets[i];
    int endCol = col + colOffsets[i];
    int endSquare = rowColToSquare(endRow, endCol);
    if (endRow > 7 || endRow < 0 || endCol > 7 || endCol < 0)
    {
      continue;
    }

    if (endSquare == kingSquare)
    {
      return true;
    }
  }
  return false;
}

bool isSlideAttacking(Board *board, int square, int kingSquare, int dirStart, int dirEnd)
{
  int row = squareToRow(square);
  int col = squareToCol(square);

  int rowOffsets[8] = {1, 0, -1, 0, 1, 1, -1, -1};
  int colOffsets[8] = {0, 1, 0, -1, 1, -1, 1, -1};

  for (int i = dirStart; i < dirEnd; i++)
  {
    for (int j = 1; j < 8; j++)
    {
      int endRow = row + rowOffsets[i] * j;
      int endCol = col + colOffsets[i] * j;
      int endSquare = rowColToSquare(endRow, endCol);

      if (endRow > 7 || endRow < 0 || endCol > 7 || endCol < 0)
      {
        break;
      }

      Piece targetPiece = board->squares[endSquare];
      if (targetPiece != None)
      {
        if (endSquare == kingSquare)
        {
          return true;
        }
        break;
      }
    }
  }
  return false;
}

bool isKingAttacking(Board *board, int square, int kingSquare)
{
  int row = squareToRow(square);
  int col = squareToCol(square);

  int rowOffsets[8] = {1, 0, -1, 0, 1, 1, -1, -1};
  int colOffsets[8] = {0, 1, 0, -1, 1, -1, 1, -1};

  for (int i = 0; i < 8; i++)
  {
    int endRow = row + rowOffsets[i];
    int endCol = col + colOffsets[i];
    int endSquare = rowColToSquare(endRow, endCol);

    if (endRow > 7 || endRow < 0 || endCol > 7 || endCol < 0)
    {
      break;
    }

    Piece targetPiece = board->squares[endSquare];
    if (targetPiece != None)
    {
      if (endSquare == kingSquare)
      {
        return true;
      }
    }
  }
  return false;
}

void generateMoves(Board *board, MoveSet *moveSet)
{
  moveSet->moveCount = 0;
  for (int i = 0; i < 64; i++)
  {
    Piece piece = board->squares[i];
    if (((piece & 0x10) == White) == board->isWhiteToMove)
    {
      switch (piece & 0xf)
      {
      case Pawn:
        generatePawnMoves(board, moveSet, i);
        break;
      case Knight:
        generateKnightMoves(board, moveSet, i);
        break;
      case Rook:
        generateOrthogonalMoves(board, moveSet, i);
        break;
      case Bishop:
        generateDiagonalMoves(board, moveSet, i);
        break;
      case Queen:
        generateOrthogonalMoves(board, moveSet, i);
        generateDiagonalMoves(board, moveSet, i);
        break;
      case King:
        generateKingMoves(board, moveSet, i);
        break;
      }
    }
  }

  moveSet->isInCheck = isInCheck(board, board->isWhiteToMove);
}

// Pawns

void generatePawnMoves(Board *board, MoveSet *moveSet, int square)
{
  bool isWhite = board->isWhiteToMove;
  int offset = (isWhite ? 8 : -8);
  int endSquare = square + offset;
  if (board->squares[endSquare] == None)
  {
    if (squareToRow(endSquare) == 0 || squareToRow(endSquare) == 7)
    {
      generatePromotion(board, moveSet, square, endSquare);
    }
    else
    {
      writeMove(board, moveSet, createMove(square, endSquare));
    }

    if ((isWhite && squareToRow(square) == 1) || (!isWhite && squareToRow(square) == 6))
    {
      if (board->squares[square + offset * 2] == None)
      {
        writeMove(board, moveSet, createMove(square, square + offset * 2));
      }
    }
  }

  int leftCaptureSquare = square + offset - 1;
  Piece leftCapture = board->squares[leftCaptureSquare];
  if (squareToCol(square) != 0 && leftCapture != None && ((leftCapture & 0x10) == White) != isWhite)
  {
    if (squareToRow(leftCaptureSquare) == 0 || squareToRow(leftCaptureSquare) == 7)
    {
      generatePromotion(board, moveSet, square, leftCaptureSquare);
    }
    else
    {
      writeMove(board, moveSet, createMove(square, leftCaptureSquare));
    }
  }

  int rightCaptureSquare = square + offset + 1;
  Piece rightCapture = board->squares[rightCaptureSquare];
  if (squareToCol(square) != 7 && rightCapture != None && ((rightCapture & 0x10) == White) != isWhite)
  {
    if (squareToRow(rightCaptureSquare) == 0 || squareToRow(rightCaptureSquare) == 7)
    {
      generatePromotion(board, moveSet, square, rightCaptureSquare);
    }
    else
    {
      writeMove(board, moveSet, createMove(square, rightCaptureSquare));
    }
  }
}

void generatePromotion(Board *board, MoveSet *moveSet, int start, int end)
{
  writeMove(board, moveSet, createPromotion(start, end, Queen));
  writeMove(board, moveSet, createPromotion(start, end, Rook));
  writeMove(board, moveSet, createPromotion(start, end, Knight));
  writeMove(board, moveSet, createPromotion(start, end, Bishop));
}

// Knights

void generateKnightMoves(Board *board, MoveSet *moveSet, int square)
{
  int row = squareToRow(square);
  int col = squareToCol(square);

  int rowOffsets[8] = {2, 2, 1, -1, -2, -2, -1, 1};
  int colOffsets[8] = {-1, 1, 2, 2, 1, -1, -2, -2};

  for (int i = 0; i < 8; i++)
  {
    int endRow = row + rowOffsets[i];
    int endCol = col + colOffsets[i];
    int endSquare = rowColToSquare(endRow, endCol);
    if (endRow > 7 || endRow < 0 || endCol > 7 || endCol < 0)
    {
      continue;
    }

    Piece endPiece = board->squares[endSquare];
    if (endPiece != None && ((endPiece & 0x10) == White) == board->isWhiteToMove)
    {
      continue;
    }

    writeMove(board, moveSet, createMove(square, endSquare));
  }
}

void generateOrthogonalMoves(Board *board, MoveSet *moveSet, int square)
{
  generateSlidingMoves(board, moveSet, square, 0, 4);
}

void generateDiagonalMoves(Board *board, MoveSet *moveSet, int square)
{
  generateSlidingMoves(board, moveSet, square, 4, 8);
}

void generateSlidingMoves(Board *board, MoveSet *moveSet, int square, int dirStart, int dirEnd)
{
  int row = squareToRow(square);
  int col = squareToCol(square);

  int rowOffsets[8] = {1, 0, -1, 0, 1, 1, -1, -1};
  int colOffsets[8] = {0, 1, 0, -1, 1, -1, 1, -1};

  for (int i = dirStart; i < dirEnd; i++)
  {
    for (int j = 1; j < 8; j++)
    {
      int endRow = row + rowOffsets[i] * j;
      int endCol = col + colOffsets[i] * j;
      int endSquare = rowColToSquare(endRow, endCol);

      if (endRow > 7 || endRow < 0 || endCol > 7 || endCol < 0)
      {
        break;
      }

      Piece targetPiece = board->squares[endSquare];
      if (targetPiece == None)
      {
        writeMove(board, moveSet, createMove(square, endSquare));
      }
      else
      {
        if (((targetPiece & 0x10) == White) != board->isWhiteToMove)
        {
          writeMove(board, moveSet, createMove(square, endSquare));
        }
        break;
      }
    }
  }
}

void generateKingMoves(Board *board, MoveSet *moveSet, int square)
{
  int row = squareToRow(square);
  int col = squareToCol(square);

  int rowOffsets[8] = {1, 0, -1, 0, 1, 1, -1, -1};
  int colOffsets[8] = {0, 1, 0, -1, 1, -1, 1, -1};

  for (int i = 0; i < 8; i++)
  {
    int endRow = row + rowOffsets[i];
    int endCol = col + colOffsets[i];
    int endSquare = rowColToSquare(endRow, endCol);

    if (endRow > 7 || endRow < 0 || endCol > 7 || endCol < 0)
    {
      continue;
    }

    Piece targetPiece = board->squares[endSquare];
    if (targetPiece == None)
    {
      writeMove(board, moveSet, createMove(square, endSquare));
    }
    else
    {
      if (((targetPiece & 0x10) == White) != board->isWhiteToMove)
      {
        writeMove(board, moveSet, createMove(square, endSquare));
      }
      continue;
    }
  }
}

void printMoveSet(MoveSet *moveSet)
{
  for (int i = 0; i < moveSet->moveCount; i++)
  {
    printMove(moveSet->moves[i]);
    newLine();
  }
}

void printMove(Move move)
{
  printSquare(move.startSquare);
  printSquare(move.endSquare);
}

void printSquare(int square)
{
  char col;
  switch (squareToCol(square))
  {
  case 0:
    col = 'a';
    break;
  case 1:
    col = 'b';
    break;
  case 2:
    col = 'c';
    break;
  case 3:
    col = 'd';
    break;
  case 4:
    col = 'e';
    break;
  case 5:
    col = 'f';
    break;
  case 6:
    col = 'g';
    break;
  case 7:
    col = 'h';
    break;
  default:
    col = 'i';
    break;
  }

  printChar(col);
  printChar((squareToRow(square) + 1) + '0');
}