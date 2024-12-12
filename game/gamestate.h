#ifndef gamestate_h
#define gamestate_h

#include "types.h"
#include <stdbool.h>

typedef struct t_GameState GameState;

struct t_GameState
{
  int fiftyMoveCounter;
  int enPassentFile;
  int castleRights;
  Piece lastCapture;
};

GameState *createState();
GameState *getState();
GameState *popState();
bool hasState();

#endif