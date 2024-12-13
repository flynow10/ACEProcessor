#include "chess.h"

#include "board.h"
#include "movegen.h"
#include "utils.h"
#include "print.h"
#include "input.h"
#include <stdbool.h>

#define PIECE_SELECTION 0
#define MOVE_SELECTION 1

int perft(Board *board, int depth);

int main()
{
  Board *board = createBoard();
  MoveSet moveSet;
  generateMoves(board, &moveSet);
  int selectedSquare = 0;
  int selectedMove = 0;
  int phase = PIECE_SELECTION;
  int moveSquares[64];
  int numMoveSquares = 0;
  for (int i = 0; i < moveSet.moveCount; i++)
  {
    Move move = moveSet.moves[i];
    if (move.startSquare == selectedSquare)
    {
      moveSquares[numMoveSquares++] = move.endSquare;
    }
  }
  printBoard(board, selectedSquare, moveSquares, numMoveSquares);
  bool pressed[4] = {false, false, false, false};

  while (1)
  {
    bool pressedFrame[4] = {false, false, false, false};
    for (int i = 0; i < 4; i++)
    {
      if (pressed[i] && !isKeyPressed(i))
      {
        pressed[i] = false;
      }

      if (!pressed[i] && isKeyPressed(i))
      {
        pressed[i] = true;
        pressedFrame[i] = true;
      }
    }
    if (phase == PIECE_SELECTION)
    {
      if (pressedFrame[0])
      {
        do
        {
          selectedSquare = (selectedSquare + 1) % 64;
        } while (board->squares[selectedSquare] == None || (board->squares[selectedSquare] & 0x1) == White);
        // for (int i = 0; i < moveSet.moveCount; i++)
        // {
        //   Move move = moveSet.moves[i];
        //   if (move.startSquare == selectedSquare)
        //   {
        //     moveSquares[numMoveSquares++] = move.endSquare;
        //   }
        // }
        printBoard(board, selectedSquare, moveSquares, numMoveSquares);
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
        } while (board->squares[selectedSquare] == None || (board->squares[selectedSquare] & 0x1) == White);
        // for (int i = 0; i < moveSet.moveCount; i++)
        // {
        //   Move move = moveSet.moves[i];
        //   if (move.startSquare == selectedSquare)
        //   {
        //     moveSquares[numMoveSquares++] = move.endSquare;
        //   }
        // }
        printBoard(board, selectedSquare, moveSquares, numMoveSquares);
      }

      if (pressedFrame[2])
      {
        phase = MOVE_SELECTION;
      }
    }
    else if (phase == MOVE_SELECTION)
    {
    }
  }
  return 0;
}

void createMoveSquareList(int selectedSquare, MoveSet *moveSet, int moveSquares[], int *numMoves)
{
  for (int i = 0; i < moveSet->moveCount; i++)
  {
    Move move = moveSet->moves[i];
    if (move.startSquare == selectedSquare)
    {
      moveSquares[*numMoves++] = move.endSquare;
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