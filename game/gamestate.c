#include <stdlib.h>
#include "gamestate.h"

GameState *createState()
{
  GameState *initialState = malloc(sizeof(GameState));
  initialState->castleRights = 0;
  initialState->enPassentFile = -1;
  initialState->fiftyMoveCounter = 0;
  initialState->lastCapture = None;
}

GameState *nextState(GameState *current)
{
  return current->lastGameState;
}

void deleteStateStack(GameState *toDelete)
{
  GameState *next = nextState(toDelete);

  do
  {
    free(toDelete);
    toDelete = next;
    next = nextState(toDelete);
  } while (nextState);
}