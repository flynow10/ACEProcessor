#include "random.h"
#define POLY_MASK_32 0xB4BCD35C
#define POLY_MASK_31 0x7A5BC2E3

typedef unsigned int uint;

uint lfsr32, lfsr31;

int shift_lfsr(uint *lfsr, uint polynomial_mask)
{
  int feedback;

  feedback = *lfsr & 1;
  *lfsr >>= 1;

  if (feedback == 1)
  {
    *lfsr ^= polynomial_mask;
  }

  return *lfsr;
}

void init_lfsrs(void)
{
  lfsr32 = 0xABCDE;
  lfsr31 = 0x23456789;
}

int get_random(void)
{
  shift_lfsr(&lfsr32, POLY_MASK_32);
  return (shift_lfsr(&lfsr32, POLY_MASK_32) ^ shift_lfsr(&lfsr31, POLY_MASK_31)) & 0xffff;
}