#ifndef types_h
#define types_h

typedef enum t_Color
{
  White = 0x00,
  Black = 0x10
} Color;

typedef enum t_PieceType
{
  Empty = 0,
  Pawn,
  Bishop,
  Knight,
  Rook,
  Queen,
  King
} PieceType;

typedef enum t_Piece
{
  None,
  WhitePawn = 1,
  WhtieBishop,
  WhiteKnight,
  WhiteRook,
  WhiteQueen,
  WhiteKing,
  BlackPawn = Pawn | Black,
  BlackBishop,
  BlackKnight,
  BlackRook,
  BlackQueen,
  BlackKing
} Piece;

#endif