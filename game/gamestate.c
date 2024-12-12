#include "gamestate.h"

GameState states[256];
int currentState = 0;

GameState *createState()
{
  GameState *initialState = &states[currentState++];
  initialState->castleRights = 0;
  initialState->enPassentFile = -1;
  initialState->fiftyMoveCounter = 0;
  initialState->lastCapture = None;
  return initialState;
}

GameState *getState()
{
  return &states[currentState - 1];
}

GameState *popState()
{
  return &states[--currentState];
}

bool hasState()
{
  return currentState != 0;
}