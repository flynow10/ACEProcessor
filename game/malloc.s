malloc:
  mv	a1,a0
  lw	a0,-700(gp)
  j	_malloc_r
free:
  mv	a1,a0
  lw	a0,-700(gp)
  j	_free_r
_malloc_r:
  addi	sp,sp,-48
  sw	s2,32(sp)
  sw	ra,44(sp)
  sw	s0,40(sp)
  sw	s1,36(sp)
  sw	s3,28(sp)
  addi	a5,a1,11
  li	a4,22
  mv	s2,a0
  bltu	a4,a5,malloc.L1
  li	s1,16
  bltu	s1,a1,malloc.L2
  jal	_malloc_lock
  li	a5,24
  li	a1,2
malloc.L55:
  auipc	s3,0x3
  addi	s3,s3,-400
  add	a5,s3,a5
  lw	s0,4(a5)
  addi	a4,a5,-8
  beq	s0,a4,malloc.L3
malloc.L45:
  lw	a5,4(s0)
  lw	a3,12(s0)
  lw	a2,8(s0)
  andi	a5,a5,-4
  add	a5,s0,a5
  lw	a4,4(a5)
  sw	a3,12(a2)
  sw	a2,8(a3)
  ori	a4,a4,1
  mv	a0,s2
  sw	a4,4(a5)
  jal	_malloc_unlock
  lw	ra,44(sp)
  addi	a0,s0,8
  lw	s0,40(sp)
  lw	s1,36(sp)
  lw	s2,32(sp)
  lw	s3,28(sp)
  addi	sp,sp,48
  ret
malloc.L1:
  andi	s1,a5,-8
  bltz	a5,malloc.L2
  bltu	s1,a1,malloc.L2
  jal	_malloc_lock
  li	a5,503
  bgeu	a5,s1,malloc.L4
  srli	a5,s1,0x9
  beqz	a5,malloc.L5
  li	a4,4
  bltu	a4,a5,malloc.L6
  srli	a5,s1,0x6
  addi	a1,a5,57
  addi	a6,a5,56
  slli	a2,a1,0x3
malloc.L22:
  auipc	s3,0x3
  addi	s3,s3,-560
  add	a2,s3,a2
  lw	s0,4(a2)
  addi	a2,a2,-8
  beq	a2,s0,malloc.L7
  li	a0,15
  j	malloc.L8
malloc.L10:
  lw	a3,12(s0)
  bgez	a4,malloc.L9
  beq	a2,a3,malloc.L7
  mv	s0,a3
malloc.L8:
  lw	a5,4(s0)
  andi	a5,a5,-4
  sub	a4,a5,s1
  bge	a0,a4,malloc.L10
  mv	a1,a6
malloc.L7:
  lw	s0,16(s3)
  auipc	a7,0x3
  addi	a7,a7,-624
  beq	s0,a7,malloc.L11
  lw	a5,4(s0)
  li	a3,15
  andi	a5,a5,-4
  sub	a4,a5,s1
  blt	a3,a4,malloc.L12
  sw	a7,20(s3)
  sw	a7,16(s3)
  bgez	a4,malloc.L13
  li	a4,511
  lw	a0,4(s3)
  bltu	a4,a5,malloc.L14
  andi	a4,a5,-8
  addi	a4,a4,8
  add	a4,s3,a4
  lw	a3,0(a4)
  srli	a2,a5,0x5
  li	a5,1
  sll	a5,a5,a2
  or	a0,a0,a5
  addi	a5,a4,-8
  sw	a3,8(s0)
  sw	a5,12(s0)
  sw	a0,4(s3)
  sw	s0,0(a4)
  sw	s0,12(a3)
malloc.L42:
  srai	a5,a1,0x2
  li	a2,1
  sll	a2,a2,a5
  bltu	a0,a2,malloc.L15
  and	a5,a2,a0
  bnez	a5,malloc.L16
  slli	a2,a2,0x1
  andi	a1,a1,-4
  and	a5,a2,a0
  addi	a1,a1,4
  bnez	a5,malloc.L16
malloc.L17:
  slli	a2,a2,0x1
  and	a5,a2,a0
  addi	a1,a1,4
  beqz	a5,malloc.L17
malloc.L16:
  li	a6,15
malloc.L61:
  slli	t1,a1,0x3
  add	t1,s3,t1
  mv	a0,t1
  lw	a5,12(a0)
  mv	t3,a1
malloc.L20:
  beq	a0,a5,malloc.L18
  lw	a4,4(a5)
  mv	s0,a5
  lw	a5,12(a5)
  andi	a4,a4,-4
  sub	a3,a4,s1
  blt	a6,a3,malloc.L19
  bltz	a3,malloc.L20
  add	a4,s0,a4
  lw	a3,4(a4)
  lw	a2,8(s0)
  mv	a0,s2
  ori	a3,a3,1
  sw	a3,4(a4)
  sw	a5,12(a2)
  sw	a2,8(a5)
  jal	_malloc_unlock
  addi	a0,s0,8
  j	malloc.L21
malloc.L2:
  li	a5,12
  sw	a5,0(s2)
malloc.L95:
  li	a0,0
malloc.L21:
  lw	ra,44(sp)
  lw	s0,40(sp)
  lw	s1,36(sp)
  lw	s2,32(sp)
  lw	s3,28(sp)
  addi	sp,sp,48
  ret
malloc.L5:
  li	a2,512
  li	a1,64
  li	a6,63
  j	malloc.L22
malloc.L15:
  lw	s0,8(s3)
  sw	s6,16(sp)
  lw	a5,4(s0)
  andi	s6,a5,-4
  bltu	s6,s1,malloc.L23
  sub	a4,s6,s1
  li	a5,15
  blt	a5,a4,malloc.L24
malloc.L23:
  sw	s9,4(sp)
  addi	s9,gp,-708
  sw	s5,20(sp)
  lw	a4,0(s9)
  lw	s5,-688(gp)
  sw	s4,24(sp)
  sw	s7,12(sp)
  li	a5,-1
  add	s4,s0,s6
  add	s5,s1,s5
  beq	a4,a5,malloc.L25
  lui	a5,0x1
  addi	a5,a5,15
  add	s5,s5,a5
  lui	a5,0xfffff
  and	s5,s5,a5
malloc.L91:
  mv	a1,s5
  mv	a0,s2
  jal	_sbrk_r
  li	a5,-1
  mv	s7,a0
  beq	a0,a5,malloc.L30
  sw	s8,8(sp)
  bltu	a0,s4,malloc.L31
  addi	s8,gp,-640
  lw	a1,0(s8)
  add	a1,s5,a1
  sw	a1,0(s8)
  mv	a4,a1
  beq	s4,a0,malloc.L32
malloc.L98:
  lw	a3,0(s9)
  li	a5,-1
  beq	a3,a5,malloc.L33
  sub	a5,s7,s4
  add	a5,a5,a4
  sw	a5,0(s8)
malloc.L99:
  andi	s9,s7,7
  beqz	s9,malloc.L34
  sub	s7,s7,s9
  lui	a1,0x1
  addi	s7,s7,8
  addi	a1,a1,8
  add	s5,s7,s5
  sub	a1,a1,s9
  sub	a1,a1,s5
  slli	a1,a1,0x14
  srli	s4,a1,0x14
  mv	a1,s4
  mv	a0,s2
  jal	_sbrk_r
  li	a5,-1
  beq	a0,a5,malloc.L35
malloc.L93:
  sub	a0,a0,s7
  add	s5,a0,s4
malloc.L94:
  lw	a4,0(s8)
  sw	s7,8(s3)
  ori	a5,s5,1
  add	a1,s4,a4
  sw	a5,4(s7)
  sw	a1,0(s8)
  beq	s0,s3,malloc.L36
  li	a3,15
  bgeu	a3,s6,malloc.L37
  lw	a4,4(s0)
  addi	a5,s6,-12
  andi	a5,a5,-8
  andi	a4,a4,1
  or	a4,a4,a5
  sw	a4,4(s0)
  li	a2,5
  add	a4,s0,a5
  sw	a2,4(a4)
  sw	a2,8(a4)
  bltu	a3,a5,malloc.L38
malloc.L90:
  lw	a5,4(s7)
malloc.L36:
  addi	a4,gp,-692
  lw	a3,0(a4)
  bgeu	a3,a1,malloc.L39
  sw	a1,0(a4)
malloc.L39:
  addi	a4,gp,-696
  lw	a3,0(a4)
  bgeu	a3,a1,malloc.L40
  sw	a1,0(a4)
malloc.L40:
  lw	s8,8(sp)
  mv	s0,s7
  j	malloc.L41
malloc.L11:
  lw	a0,4(s3)
  j	malloc.L42
malloc.L31:
  beq	s0,s3,malloc.L43
  lw	s0,8(s3)
  lw	s8,8(sp)
  lw	a5,4(s0)
malloc.L41:
  andi	a5,a5,-4
  sub	a4,a5,s1
  bltu	a5,s1,malloc.L44
  li	a5,15
  bge	a5,a4,malloc.L44
  lw	s4,24(sp)
  lw	s5,20(sp)
  lw	s7,12(sp)
  lw	s9,4(sp)
malloc.L24:
  ori	a5,s1,1
  sw	a5,4(s0)
  add	s1,s0,s1
  sw	s1,8(s3)
  ori	a4,a4,1
  mv	a0,s2
  sw	a4,4(s1)
  jal	_malloc_unlock
  lw	ra,44(sp)
  addi	a0,s0,8
  lw	s0,40(sp)
  lw	s6,16(sp)
  lw	s1,36(sp)
  lw	s2,32(sp)
  lw	s3,28(sp)
  addi	sp,sp,48
  ret
malloc.L9:
  lw	a2,8(s0)
  add	a5,s0,a5
  lw	a4,4(a5)
  sw	a3,12(a2)
  sw	a2,8(a3)
  ori	a4,a4,1
  mv	a0,s2
  sw	a4,4(a5)
  jal	_malloc_unlock
  lw	ra,44(sp)
  addi	a0,s0,8
  lw	s0,40(sp)
  lw	s1,36(sp)
  lw	s2,32(sp)
  lw	s3,28(sp)
  addi	sp,sp,48
  ret
malloc.L3:
  lw	s0,12(a5)
  addi	a1,a1,2
  beq	a5,s0,malloc.L7
  j	malloc.L45
malloc.L14:
  srli	a4,a5,0x9
  li	a3,4
  bgeu	a3,a4,malloc.L46
  li	a3,20
  bltu	a3,a4,malloc.L47
  addi	a2,a4,92
  slli	a2,a2,0x3
  addi	a3,a4,91
malloc.L56:
  add	a2,s3,a2
  lw	a4,0(a2)
  addi	a2,a2,-8
  bne	a2,a4,malloc.L48
  j	malloc.L49
malloc.L51:
  lw	a4,8(a4)
  beq	a2,a4,malloc.L50
malloc.L48:
  lw	a3,4(a4)
  andi	a3,a3,-4
  bltu	a5,a3,malloc.L51
malloc.L50:
  lw	a2,12(a4)
malloc.L92:
  sw	a2,12(s0)
  sw	a4,8(s0)
  sw	s0,8(a2)
  sw	s0,12(a4)
  j	malloc.L42
malloc.L6:
  li	a4,20
  bgeu	a4,a5,malloc.L52
  li	a4,84
  bltu	a4,a5,malloc.L53
  srli	a5,s1,0xc
  addi	a1,a5,111
  addi	a6,a5,110
  slli	a2,a1,0x3
  j	malloc.L22
malloc.L18:
  addi	t3,t3,1
  andi	a5,t3,3
  addi	a0,a0,8
  beqz	a5,malloc.L54
  lw	a5,12(a0)
  j	malloc.L20
malloc.L19:
  lw	a2,8(s0)
  ori	a1,s1,1
  sw	a1,4(s0)
  sw	a5,12(a2)
  sw	a2,8(a5)
  add	s1,s0,s1
  sw	s1,20(s3)
  sw	s1,16(s3)
  ori	a5,a3,1
  add	a4,s0,a4
  sw	a7,12(s1)
  sw	a7,8(s1)
  sw	a5,4(s1)
  mv	a0,s2
  sw	a3,0(a4)
  jal	_malloc_unlock
  addi	a0,s0,8
  j	malloc.L21
malloc.L13:
  add	a5,s0,a5
  lw	a4,4(a5)
  mv	a0,s2
  ori	a4,a4,1
  sw	a4,4(a5)
  jal	_malloc_unlock
  addi	a0,s0,8
  j	malloc.L21
malloc.L4:
  srli	a1,s1,0x3
  addi	a5,s1,8
  j	malloc.L55
malloc.L12:
  ori	a3,s1,1
  sw	a3,4(s0)
  add	s1,s0,s1
  sw	s1,20(s3)
  sw	s1,16(s3)
  ori	a3,a4,1
  add	a5,s0,a5
  sw	a7,12(s1)
  sw	a7,8(s1)
  sw	a3,4(s1)
  mv	a0,s2
  sw	a4,0(a5)
  jal	_malloc_unlock
  addi	a0,s0,8
  j	malloc.L21
malloc.L46:
  srli	a4,a5,0x6
  addi	a2,a4,57
  slli	a2,a2,0x3
  addi	a3,a4,56
  j	malloc.L56
malloc.L52:
  addi	a1,a5,92
  addi	a6,a5,91
  slli	a2,a1,0x3
  j	malloc.L22
malloc.L58:
  lw	a5,8(t1)
  addi	a1,a1,-1
  bne	a5,t1,malloc.L57
malloc.L54:
  andi	a5,a1,3
  addi	t1,t1,-8
  bnez	a5,malloc.L58
  lw	a4,4(s3)
  not	a5,a2
  and	a5,a5,a4
  sw	a5,4(s3)
malloc.L103:
  slli	a2,a2,0x1
  bltu	a5,a2,malloc.L15
  beqz	a2,malloc.L15
  and	a4,a2,a5
  bnez	a4,malloc.L59
malloc.L60:
  slli	a2,a2,0x1
  and	a4,a2,a5
  addi	t3,t3,4
  beqz	a4,malloc.L60
malloc.L59:
  mv	a1,t3
  j	malloc.L61
malloc.L38:
  addi	a1,s0,8
  mv	a0,s2
  jal	_free_r
  lw	a1,0(s8)
  lw	s7,8(s3)
  j	malloc.L90
malloc.L25:
  addi	s5,s5,16
  j	malloc.L91
malloc.L49:
  srai	a3,a3,0x2
  li	a5,1
  sll	a5,a5,a3
  or	a0,a0,a5
  sw	a0,4(s3)
  j	malloc.L92
malloc.L34:
  add	a1,s7,s5
  neg	a1,a1
  slli	a1,a1,0x14
  srli	s4,a1,0x14
  mv	a1,s4
  mv	a0,s2
  jal	_sbrk_r
  li	a5,-1
  bne	a0,a5,malloc.L93
  li	s4,0
  j	malloc.L94
malloc.L37:
  lw	s8,8(sp)
  li	a5,1
  sw	a5,4(s7)
malloc.L44:
  mv	a0,s2
  jal	_malloc_unlock
  lw	s4,24(sp)
  lw	s5,20(sp)
  lw	s6,16(sp)
  lw	s7,12(sp)
  lw	s9,4(sp)
  j	malloc.L95
malloc.L47:
  li	a3,84
  bltu	a3,a4,malloc.L96
  srli	a4,a5,0xc
  addi	a2,a4,111
  slli	a2,a2,0x3
  addi	a3,a4,110
  j	malloc.L56
malloc.L53:
  li	a4,340
  bltu	a4,a5,malloc.L97
  srli	a5,s1,0xf
  addi	a1,a5,120
  addi	a6,a5,119
  slli	a2,a1,0x3
  j	malloc.L22
malloc.L43:
  addi	s8,gp,-640
  lw	a4,0(s8)
  add	a4,s5,a4
  sw	a4,0(s8)
  j	malloc.L98
malloc.L30:
  lw	s0,8(s3)
  lw	a5,4(s0)
  j	malloc.L41
malloc.L32:
  slli	a5,a0,0x14
  bnez	a5,malloc.L98
  lw	s7,8(s3)
  add	a5,s6,s5
  ori	a5,a5,1
  sw	a5,4(s7)
  j	malloc.L36
malloc.L33:
  sw	s7,0(s9)
  j	malloc.L99
malloc.L96:
  li	a3,340
  bltu	a3,a4,malloc.L100
  srli	a4,a5,0xf
  addi	a2,a4,120
  slli	a2,a2,0x3
  addi	a3,a4,119
  j	malloc.L56
malloc.L97:
  li	a4,1364
  bltu	a4,a5,malloc.L101
  srli	a5,s1,0x12
  addi	a1,a5,125
  addi	a6,a5,124
  slli	a2,a1,0x3
  j	malloc.L22
malloc.L35:
  addi	s9,s9,-8
  add	s5,s5,s9
  sub	s5,s5,s7
  li	s4,0
  j	malloc.L94
malloc.L100:
  li	a3,1364
  bltu	a3,a4,malloc.L102
  srli	a4,a5,0x12
  addi	a2,a4,125
  slli	a2,a2,0x3
  addi	a3,a4,124
  j	malloc.L56
malloc.L101:
  li	a2,1016
  li	a1,127
  li	a6,126
  j	malloc.L22
malloc.L102:
  li	a2,1016
  li	a3,126
  j	malloc.L56
malloc.L57:
  lw	a5,4(s3)
  j	malloc.L103
_malloc_lock:
  ret
_malloc_unlock:
  ret
_sbrk_r:
  addi	sp,sp,-16
  sw	s0,8(sp)
  mv	s0,a0
  mv	a0,a1
  sw	zero,-680(gp)
  sw	ra,12(sp)
  jal	_sbrk
  li	a5,-1
  beq	a0,a5,malloc.L26
  lw	ra,12(sp)
  lw	s0,8(sp)
  addi	sp,sp,16
  ret
malloc.L26:
  sw	s1,4(sp)
  addi	s1,gp,-680
  lw	a5,0(s1)
  beqz	a5,malloc.L27
  lw	ra,12(sp)
  sw	a5,0(s0)
  lw	s0,8(sp)
  lw	s1,4(sp)
  addi	sp,sp,16
  ret
malloc.L27:
  lw	ra,12(sp)
  lw	s0,8(sp)
  lw	s1,4(sp)
  addi	sp,sp,16
  ret
_sbrk:
  addi	a3,gp,-672
  lw	a4,0(a3)
  addi	sp,sp,-16
  sw	ra,12(sp)
  mv	a5,a0
  bnez	a4,malloc.L28
  li	a7,214
  li	a0,0
  ecall
  li	a2,-1
  mv	a4,a0
  beq	a0,a2,malloc.L29
  sw	a0,0(a3)
malloc.L28:
  add	a0,a5,a4
  li	a7,214
  ecall
  lw	a4,0(a3)
  add	a5,a5,a4
  bne	a0,a5,malloc.L29
  lw	ra,12(sp)
  sw	a0,0(a3)
  mv	a0,a4
  addi	sp,sp,16
  ret
malloc.L29:
  jal	__errno
  lw	ra,12(sp)
  li	a5,12
  sw	a5,0(a0)
  li	a0,-1
  addi	sp,sp,16
  ret
__errno:
  lw	a0,-700(gp)
  ret
_free_r:
  beqz	a1,malloc.L62
  addi	sp,sp,-16
  sw	s0,8(sp)
  sw	s1,4(sp)
  mv	s0,a1
  mv	s1,a0
  sw	ra,12(sp)
  jal	_malloc_lock
  lw	a1,-4(s0)
  addi	a4,s0,-8
  auipc	a6,0x2
  addi	a6,a6,-1572
  andi	a5,a1,-2
  add	a2,a4,a5
  lw	a3,4(a2)
  lw	a0,8(a6)
  andi	a7,a1,1
  andi	a3,a3,-4
  beq	a0,a2,malloc.L63
  sw	a3,4(a2)
  add	a0,a2,a3
  lw	a0,4(a0)
  andi	a0,a0,1
  bnez	a7,malloc.L64
  lw	t1,-8(s0)
  auipc	a7,0x2
  addi	a7,a7,-1624
  sub	a4,a4,t1
  lw	a1,8(a4)
  add	a5,a5,t1
  beq	a1,a7,malloc.L65
  lw	t1,12(a4)
  sw	t1,12(a1)
  sw	a1,8(t1)
  beqz	a0,malloc.L66
  ori	a3,a5,1
  sw	a3,4(a4)
  sw	a5,0(a2)
malloc.L70:
  li	a3,511
  bltu	a3,a5,malloc.L67
malloc.L71:
  andi	a3,a5,-8
  addi	a3,a3,8
  lw	a1,4(a6)
  add	a3,a6,a3
  lw	a2,0(a3)
  srli	a0,a5,0x5
  li	a5,1
  sll	a5,a5,a0
  or	a5,a5,a1
  addi	a1,a3,-8
  sw	a2,8(a4)
  sw	a1,12(a4)
  sw	a5,4(a6)
  sw	a4,0(a3)
  sw	a4,12(a2)
malloc.L78:
  lw	s0,8(sp)
  lw	ra,12(sp)
  mv	a0,s1
  lw	s1,4(sp)
  addi	sp,sp,16
  j	_malloc_unlock
malloc.L64:
  bnez	a0,malloc.L68
  add	a5,a5,a3
  auipc	a7,0x2
  addi	a7,a7,-1776
malloc.L83:
  lw	a3,8(a2)
  ori	a0,a5,1
  add	a1,a4,a5
  beq	a3,a7,malloc.L69
  lw	a2,12(a2)
  sw	a2,12(a3)
  sw	a3,8(a2)
  sw	a0,4(a4)
  sw	a5,0(a1)
  j	malloc.L70
malloc.L62:
  ret
malloc.L68:
  ori	a1,a1,1
  sw	a1,-4(s0)
  sw	a5,0(a2)
  li	a3,511
  bgeu	a3,a5,malloc.L71
malloc.L67:
  srli	a3,a5,0x9
  li	a2,4
  bltu	a2,a3,malloc.L72
  srli	a3,a5,0x6
  addi	a1,a3,57
  slli	a1,a1,0x3
  addi	a2,a3,56
malloc.L86:
  add	a1,a6,a1
  lw	a3,0(a1)
  addi	a1,a1,-8
  bne	a1,a3,malloc.L73
  j	malloc.L74
malloc.L76:
  lw	a3,8(a3)
  beq	a1,a3,malloc.L75
malloc.L73:
  lw	a2,4(a3)
  andi	a2,a2,-4
  bltu	a5,a2,malloc.L76
malloc.L75:
  lw	a1,12(a3)
malloc.L87:
  sw	a1,12(a4)
  sw	a3,8(a4)
  lw	s0,8(sp)
  lw	ra,12(sp)
  sw	a4,8(a1)
  mv	a0,s1
  lw	s1,4(sp)
  sw	a4,12(a3)
  addi	sp,sp,16
  j	_malloc_unlock
malloc.L65:
  bnez	a0,malloc.L77
  lw	a1,12(a2)
  lw	a2,8(a2)
  add	a3,a3,a5
  ori	a5,a3,1
  sw	a1,12(a2)
  sw	a2,8(a1)
  sw	a5,4(a4)
  add	a4,a4,a3
  sw	a3,0(a4)
  j	malloc.L78
malloc.L63:
  add	a3,a5,a3
  bnez	a7,malloc.L79
  lw	a1,-8(s0)
  sub	a4,a4,a1
  lw	a5,12(a4)
  lw	a2,8(a4)
  add	a3,a3,a1
  sw	a5,12(a2)
  sw	a2,8(a5)
malloc.L79:
  ori	a2,a3,1
  lw	a5,-704(gp)
  sw	a2,4(a4)
  sw	a4,8(a6)
  bltu	a3,a5,malloc.L78
  lw	a1,-688(gp)
  mv	a0,s1
  jal	_malloc_trim_r
  j	malloc.L78
malloc.L66:
  add	a5,a5,a3
  j	malloc.L83
malloc.L72:
  li	a2,20
  bgeu	a2,a3,malloc.L84
  li	a2,84
  bltu	a2,a3,malloc.L85
  srli	a3,a5,0xc
  addi	a1,a3,111
  slli	a1,a1,0x3
  addi	a2,a3,110
  j	malloc.L86
malloc.L77:
  ori	a3,a5,1
  sw	a3,4(a4)
  sw	a5,0(a2)
  j	malloc.L78
malloc.L84:
  addi	a1,a3,92
  slli	a1,a1,0x3
  addi	a2,a3,91
  j	malloc.L86
malloc.L69:
  sw	a4,20(a6)
  sw	a4,16(a6)
  sw	a7,12(a4)
  sw	a7,8(a4)
  sw	a0,4(a4)
  sw	a5,0(a1)
  j	malloc.L78
malloc.L74:
  lw	a0,4(a6)
  srai	a2,a2,0x2
  li	a5,1
  sll	a5,a5,a2
  or	a5,a5,a0
  sw	a5,4(a6)
  j	malloc.L87
malloc.L85:
  li	a2,340
  bltu	a2,a3,malloc.L88
  srli	a3,a5,0xf
  addi	a1,a3,120
  slli	a1,a1,0x3
  addi	a2,a3,119
  j	malloc.L86
malloc.L88:
  li	a2,1364
  bltu	a2,a3,malloc.L89
  srli	a3,a5,0x12
  addi	a1,a3,125
  slli	a1,a1,0x3
  addi	a2,a3,124
  j	malloc.L86
malloc.L89:
  li	a1,1016
  li	a2,126
  j	malloc.L86
_malloc_trim_r:
  addi	sp,sp,-32
  sw	s0,24(sp)
  sw	s1,20(sp)
  sw	s2,16(sp)
  sw	s3,12(sp)
  sw	s4,8(sp)
  mv	s3,a1
  sw	ra,28(sp)
  mv	s2,a0
  auipc	s4,0x2
  addi	s4,s4,-1256
  jal	_malloc_lock
  lw	a5,8(s4)
  lui	s0,0x1
  addi	s0,s0,-17
  lw	s1,4(a5)
  lui	a5,0x1
  andi	s1,s1,-4
  add	s0,s1,s0
  sub	s0,s0,s3
  srli	s0,s0,0xc
  addi	s0,s0,-1
  slli	s0,s0,0xc
  blt	s0,a5,malloc.L80
  li	a1,0
  mv	a0,s2
  jal	_sbrk_r
  lw	a5,8(s4)
  add	a5,a5,s1
  beq	a0,a5,malloc.L81
malloc.L80:
  mv	a0,s2
  jal	_malloc_unlock
  lw	ra,28(sp)
  lw	s0,24(sp)
  lw	s1,20(sp)
  lw	s2,16(sp)
  lw	s3,12(sp)
  lw	s4,8(sp)
  li	a0,0
  addi	sp,sp,32
  ret
malloc.L81:
  neg	a1,s0
  mv	a0,s2
  jal	_sbrk_r
  li	a5,-1
  beq	a0,a5,malloc.L82
  addi	a4,gp,-640
  lw	a3,8(s4)
  lw	a5,0(a4)
  sub	s1,s1,s0
  ori	s1,s1,1
  mv	a0,s2
  sub	a5,a5,s0
  sw	s1,4(a3)
  sw	a5,0(a4)
  jal	_malloc_unlock
  lw	ra,28(sp)
  lw	s0,24(sp)
  lw	s1,20(sp)
  lw	s2,16(sp)
  lw	s3,12(sp)
  lw	s4,8(sp)
  li	a0,1
  addi	sp,sp,32
  ret
malloc.L82:
  li	a1,0
  mv	a0,s2
  jal	_sbrk_r
  lw	a4,8(s4)
  li	a3,15
  sub	a5,a0,a4
  bge	a3,a5,malloc.L80
  lw	a3,-708(gp)
  ori	a5,a5,1
  sw	a5,4(a4)
  sub	a0,a0,a3
  sw	a0,-640(gp)
  j	malloc.L80