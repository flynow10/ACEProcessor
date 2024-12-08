#ifndef gamestate_h
#define gamestate_h

#include "types.h"

typedef struct t_GameState GameState;

struct t_GameState
{
  int fiftyMoveCounter;
  int enPassentFile;
  int castleRights;
  Piece lastCapture;
  GameState *lastGameState;
};

GameState *createState();
GameState *nextState(GameState *current);
void deleteStateStack(GameState *toDelete);

#endif