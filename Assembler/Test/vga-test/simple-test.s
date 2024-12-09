main:
  lui t0, 0x10000
  lui t1, 0x48fff
  addi t1, t1, 0xfff
  sw t1, 0(t0)
  hlt