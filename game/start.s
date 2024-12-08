_start:
  auipc	gp,0x4
  addi	gp,gp,-896
  addi	a0,gp,-696
  addi	a2,gp,112
  sub	a2,a2,a0
  li	a1,0
  jal	memset
  auipc	a0,0x2
  addi	a0,a0,-1772
  beqz	a0,start.L7
  auipc	a0,0x2
  addi	a0,a0,396
  jal	atexit
start.L7:
  jal __libc_init_array
  lw	a0,0(sp)
  addi	a1,sp,4
  li	a2,0
  jal	main
  j	0
memset:
  li	t1,15
  mv	a4,a0
  bgeu	t1,a2,start.L1
  andi	a5,a4,15
  bnez	a5,start.L2
start.L6:
  bnez	a1,start.L3
start.L5:
  andi	a3,a2,-16
  andi	a2,a2,15
  add	a3,a3,a4
start.L4:
  sw	a1,0(a4)
  sw	a1,4(a4)
  sw	a1,8(a4)
  sw	a1,12(a4)
  addi	a4,a4,16
  bltu	a4,a3,start.L4
  bnez	a2,start.L1
  ret
start.L1:
  sub	a3,t1,a2
  slli	a3,a3,0x2
  auipc	t0,0x0
  add	a3,a3,t0
  jr	12(a3)
  sb	a1,14(a4)
  sb	a1,13(a4)
  sb	a1,12(a4)
  sb	a1,11(a4)
  sb	a1,10(a4)
  sb	a1,9(a4)
  sb	a1,8(a4)
  sb	a1,7(a4)
  sb	a1,6(a4)
  sb	a1,5(a4)
  sb	a1,4(a4)
  sb	a1,3(a4)
  sb	a1,2(a4)
  sb	a1,1(a4)
  sb	a1,0(a4)
  ret
start.L3:
  zext.b	a1,a1
  slli	a3,a1,0x8
  or	a1,a1,a3
  slli	a3,a1,0x10
  or	a1,a1,a3
  j	start.L5
start.L2:
  slli	a3,a5,0x2
  auipc	t0,0x0
  add	a3,a3,t0
  mv	t0,ra
  jalr	-96(a3)
  mv	ra,t0
  addi	a5,a5,-16
  sub	a4,a4,a5
  add	a2,a2,a5
  bgeu	t1,a2,start.L1
  j	start.L6
atexit:
  mv	a1,a0
  li	a3,0
  li	a2,0
  li	a0,0
  j	__register_exitproc
__register_exitproc:
  addi	a4,gp,-676
  lw	a5,0(a4)
  beqz	a5,start.L8
start.L12:
  lw	a4,4(a5)
  li	a6,31
  blt	a6,a4,start.L9
  slli	a6,a4,0x2
  beqz	a0,start.L10
  add	t1,a5,a6
  sw	a2,136(t1)
  lw	a7,392(a5)
  li	a2,1
  sll	a2,a2,a4
  or	a7,a7,a2
  sw	a7,392(a5)
  sw	a3,264(t1)
  li	a3,2
  beq	a0,a3,start.L11
start.L10:
  addi	a4,a4,1
  sw	a4,4(a5)
  add	a5,a5,a6
  sw	a1,8(a5)
  li	a0,0
  ret
start.L8:
  addi	a5,gp,-288
  sw	a5,0(a4)
  j	start.L12
start.L11:
  lw	a3,396(a5)
  addi	a4,a4,1
  sw	a4,4(a5)
  or	a3,a3,a2
  sw	a3,396(a5)
  add	a5,a5,a6
  sw	a1,8(a5)
  li	a0,0
  ret
start.L9:
  li	a0,-1
  ret
__libc_init_array:
  addi	sp,sp,-16
  sw	s0,8(sp)
  sw	s2,0(sp)
  auipc	a5,0x2
  addi	a5,a5,-548
  auipc	s0,0x2
  addi	s0,s0,-556
  sw	ra,12(sp)
  sw	s1,4(sp)
  sub	s2,a5,s0
  beq	a5,s0,start.L13
  srai	s2,s2,0x2
  li	s1,0
start.L14:
  lw	a5,0(s0)
  addi	s1,s1,1
  addi	s0,s0,4
  jalr	a5
  bltu	s1,s2,start.L14
start.L13:
  auipc	a5,0x2
  addi	a5,a5,-600
  auipc	s0,0x2
  addi	s0,s0,-616
  sub	s2,a5,s0
  srai	s2,s2,0x2
  beq	a5,s0,start.L15
  li	s1,0
start.L16:
  lw	a5,0(s0)
  addi	s1,s1,1
  addi	s0,s0,4
  jalr	a5
  bltu	s1,s2,start.L16
start.L15:
  lw	ra,12(sp)
  lw	s0,8(sp)
  lw	s1,4(sp)
  lw	s2,0(sp)
  addi	sp,sp,16
  ret