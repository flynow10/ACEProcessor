#include "chess.h"

#include "board.h"
#include "types.h"
#include "utils.h"
#include "print.h"
#include "input.h"
#include <stdbool.h>

#define PIECE_SELECTION 0
#define MOVE_SELECTION 1

void updateMoveSquares(int selectedSquare, MoveSet *moveSet);
int perft(Board *board, int depth);

int moveSquares[64];
int numMoveSquares = 0;

int main()
{
  Board *board = createBoard();
  MoveSet moveSet;
  generateMoves(board, &moveSet);
  int selectedSquare = 0;
  int selectedMove = 0;
  int phase = PIECE_SELECTION;

  updateMoveSquares(selectedSquare, &moveSet);
  printBoard(board, selectedSquare, moveSquares, numMoveSquares, -1);

  while (1)
  {
    bool pressedFrame[4] = {false, false, false, false};
    getKeysPressed(pressedFrame);
    if (phase == PIECE_SELECTION)
    {
      if (pressedFrame[0])
      {
        do
        {
          selectedSquare = (selectedSquare + 1) % 64;
        } while (board->squares[selectedSquare] == None || ((board->squares[selectedSquare] & 0x10) == White) != board->isWhiteToMove);
        updateMoveSquares(selectedSquare, &moveSet);
        printBoard(board, selectedSquare, moveSquares, numMoveSquares, -1);
      }

      if (pressedFrame[1])
      {
        do
        {
          selectedSquare--;
          if (selectedSquare == -1)
          {
            selectedSquare = 63;
          }
        } while (board->squares[selectedSquare] == None || ((board->squares[selectedSquare] & 0x10) == White) != board->isWhiteToMove);
        updateMoveSquares(selectedSquare, &moveSet);
        printBoard(board, selectedSquare, moveSquares, numMoveSquares, -1);
      }

      if (pressedFrame[2])
      {
        phase = MOVE_SELECTION;
        selectedMove = 0;
        int count = 0;
        while (moveSet.moves[selectedMove].startSquare != selectedSquare)
        {
          selectedMove = (selectedMove + 1) % moveSet.moveCount;
          if (count++ >= 256)
          {
            break;
          }
        }
        printBoard(board, selectedSquare, moveSquares, numMoveSquares, moveSet.moves[selectedMove].endSquare);
      }
    }
    else if (phase == MOVE_SELECTION)
    {
      if (pressedFrame[0])
      {
        int count = 0;
        do
        {
          selectedMove = (selectedMove + 1) % moveSet.moveCount;
          if (count++ >= 256)
          {
            break;
          }
        } while (moveSet.moves[selectedMove].startSquare != selectedSquare);
        printBoard(board, selectedSquare, moveSquares, numMoveSquares, moveSet.moves[selectedMove].endSquare);
      }

      if (pressedFrame[1])
      {
        int count = 0;
        do
        {
          selectedMove--;
          if (selectedMove == -1)
          {
            selectedMove = moveSet.moveCount - 1;
          }
          if (count++ >= 256)
          {
            break;
          }
        } while (moveSet.moves[selectedMove].startSquare != selectedSquare);
        printBoard(board, selectedSquare, moveSquares, numMoveSquares, moveSet.moves[selectedMove].endSquare);
      }

      if (pressedFrame[2])
      {
        makeMove(board, moveSet.moves[selectedMove]);
        generateMoves(board, &moveSet);
        if (moveSet.moveCount == 0)
        {
          if (moveSet.isInCheck)
          {
            if (board->isWhiteToMove)
            {
              printString("Black wins!", 0xffffff);
            }
            else
            {
              printString("White wins!", 0xffffff);
            }
          }
          else
          {
            printString("Stalemate!", 0xffffff);
          }
          updateMoveSquares(selectedSquare, &moveSet);
          printBoard(board, -1, moveSquares, numMoveSquares, -1);
          break;
        }
        selectedSquare = 0;
        while (board->squares[selectedSquare] == None || ((board->squares[selectedSquare] & 0x10) == White) != board->isWhiteToMove)
        {
          selectedSquare = (selectedSquare + 1) % 64;
        }
        selectedMove = -1;
        updateMoveSquares(selectedSquare, &moveSet);
        printBoard(board, selectedSquare, moveSquares, numMoveSquares, -1);
        phase = PIECE_SELECTION;
      }
      if (pressedFrame[3])
      {
        selectedMove = -1;
        printBoard(board, selectedSquare, moveSquares, numMoveSquares, -1);
        phase = PIECE_SELECTION;
      }
    }
  }

  while (1)
  {
  }
  return 0;
}

void updateMoveSquares(int selectedSquare, MoveSet *moveSet)
{
  numMoveSquares = 0;
  for (int i = 0; i < moveSet->moveCount; i++)
  {
    Move move = moveSet->moves[i];
    if (move.startSquare == selectedSquare)
    {
      moveSquares[numMoveSquares++] = move.endSquare;
    }
  }
}

int perft(Board *board, int depth)
{
  MoveSet moveSet;
  generateMoves(board, &moveSet);
  if (depth == 1)
  {
    return moveSet.moveCount;
  }

  int sum = 0;
  for (int i = 0; i < moveSet.moveCount; i++)
  {
    makeMove(board, moveSet.moves[i]);
    sum += perft(board, depth - 1);
    undoMove(board, moveSet.moves[i]);
  }

  return sum;
}