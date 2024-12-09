main:
	addi	sp,sp,-16
	sw	ra,12(sp)
	sw	s0,8(sp)
	addi	s0,sp,16
	li	a1,0
	li	a0,71
	call	print
	li	a1,1
	li	a0,97
	call	print
	li	a1,2
	li	a0,98
	call	print
	li	a1,3
	li	a0,101
	call	print
	li	a5,0
	mv	a0,a5
	lw	ra,12(sp)
	lw	s0,8(sp)
	addi	sp,sp,16
	jr	ra
print:
	addi	sp,sp,-48
	sw	ra,44(sp)
	sw	s0,40(sp)
	addi	s0,sp,48
	mv	a5,a0
	sw	a1,-40(s0)
	sb	a5,-33(s0)
	lbu	a5,-33(s0)
	sw	a5,-20(s0)
	lw	a5,-20(s0)
	lw	a4,-40(s0)
	lui t0, 0x10000
	add t0, t0, a4
	mv t1, a5
	lui t2, 0x00fff
	slli t1, t1, 24
	add t1, t1, t2
	addi t1,t1, 0x7ff
	addi t1,t1, 0x7ff
	addi t1,t1, 1
	sw t1, 0(t0)
	nop
	lw	ra,44(sp)
	lw	s0,40(sp)
	addi	sp,sp,48
	jr	ra
