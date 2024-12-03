main:
	addi	sp,sp,-32
	sw	ra,28(sp)
	sw	s0,24(sp)
	addi	s0,sp,32
	sw	zero,-20(s0)
	sw	zero,-24(s0)
	j	.L2
.L3:
	lw	a0,-24(s0)
	call	factorial
	mv	a4,a0
	lw	a5,-20(s0)
	add	a5,a5,a4
	sw	a5,-20(s0)
	lw	a5,-24(s0)
	addi	a5,a5,1
	sw	a5,-24(s0)
.L2:
	lw	a4,-24(s0)
	li	a5,9
	ble	a4,a5,.L3
	li	a5,0
	mv	a0,a5
	lw	ra,28(sp)
	lw	s0,24(sp)
	addi	sp,sp,32
	jr	ra
factorial:
	addi	sp,sp,-32
	sw	ra,28(sp)
	sw	s0,24(sp)
	addi	s0,sp,32
	sw	a0,-20(s0)
	lw	a5,-20(s0)
	bgt	a5,zero,.L6
	li	a5,1
	j	.L7
.L6:
	lw	a5,-20(s0)
	addi	a5,a5,-1
	mv	a0,a5
	call	factorial
	mv	a5,a0
	lw	a1,-20(s0)
	mv	a0,a5
	call	__mulsi3
	mv	a5,a0
.L7:
	mv	a0,a5
	lw	ra,28(sp)
	lw	s0,24(sp)
	addi	sp,sp,32
	jr	ra
__mulsi3:
	mv	a2,a0
	li	a0,0
.L8:
  andi	a3,a1,1
  beqz	a3, .L9
  add	a0,a0,a2
.L9:
  srli	a1,a1,0x1
  slli	a2,a2,0x1
  bnez	a1, .L8
  ret