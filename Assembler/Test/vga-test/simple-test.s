main:
  lui t0, 0x10000
  lui t1, 0x48fff
  addi t1, t1, 0xfff
  sw t1, 0(t0)
  addi t0, t0, 1
  lui t1, 0x45fff
  addi t1, t1, 0xfff
  sw t1, 0(t0)
  addi t0, t0, 1
  lui t1, 0x4cfff
  addi t1, t1, 0xfff
  sw t1, 0(t0)
  addi t0, t0, 1
  lui t1, 0x4cfff
  addi t1, t1, 0xfff
  sw t1, 0(t0)
  addi t0, t0, 1
  lui t1, 0x4ffff
  addi t1, t1, 0xfff
  sw t1, 0(t0)
  hlt