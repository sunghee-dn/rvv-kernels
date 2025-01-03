axpy32int:                              # @axpy32int
	beqz	a0, .LBB0_3
	slli	a0, a0, 32
	srli	a0, a0, 32
.LBB0_2:                                # =>This Inner Loop Header: Depth=1
	lw	a4, 0(a2)
	lw	a5, 0(a3)
	mulw	a4, a4, a1
	addw	a4, a4, a5
	sw	a4, 0(a3)
	addi	a2, a2, 4
	addi	a0, a0, -1
	addi	a3, a3, 4
	bnez	a0, .LBB0_2
.LBB0_3:
	ret
                                        # -- End function
axpy32int_compiler_vectorize:           # @axpy32int_compiler_vectorize
	beqz	a0, .LBB1_8
	slli	a4, a0, 32
	li	a5, 16
	srli	a6, a4, 32
	bgeu	a0, a5, .LBB1_3
	li	a7, 0
	j	.LBB1_6
.LBB1_3:
	andi	a7, a6, -16
	addi	a5, a2, 32
	addi	a4, a3, 32
	mv	a0, a7
.LBB1_4:                                # =>This Inner Loop Header: Depth=1
	addi	t0, a5, -32
	vsetivli	zero, 8, e32, m1, ta, mu
	vle32.v	v8, (t0)
	vle32.v	v9, (a5)
	addi	t0, a4, -32
	vle32.v	v10, (t0)
	vle32.v	v11, (a4)
	vmacc.vx	v10, a1, v8
	vmacc.vx	v11, a1, v9
	vse32.v	v10, (t0)
	vse32.v	v11, (a4)
	addi	a5, a5, 64
	addi	a0, a0, -16
	addi	a4, a4, 64
	bnez	a0, .LBB1_4
	beq	a7, a6, .LBB1_8
.LBB1_6:
	slli	a4, a7, 2
	add	a0, a2, a4
	add	a2, a3, a4
	sub	a3, a6, a7
.LBB1_7:                                # =>This Inner Loop Header: Depth=1
	lw	a4, 0(a0)
	lw	a5, 0(a2)
	mulw	a4, a4, a1
	addw	a4, a4, a5
	sw	a4, 0(a2)
	addi	a0, a0, 4
	addi	a3, a3, -1
	addi	a2, a2, 4
	bnez	a3, .LBB1_7
.LBB1_8:
	ret
                                        # -- End function
axpy32int_rvv:                          # @axpy32int_rvv
	beqz	a0, .LBB2_3
	li	a4, 0
.LBB2_2:                                # =>This Inner Loop Header: Depth=1
	subw	a5, a0, a4
	slli	a5, a5, 32
	srli	a5, a5, 32
	vsetvli	a6, a5, e32, m1, ta, mu
	slli	a5, a4, 32
	srli	a7, a5, 30
	add	a5, a2, a7
	vle32.v	v8, (a5)
	add	a5, a3, a7
	vle32.v	v9, (a5)
	vsetvli	zero, a6, e32, m1, tu, mu
	vmacc.vx	v9, a1, v8
	addw	a4, a4, a6
	vse32.v	v9, (a5)
	bltu	a4, a0, .LBB2_2
.LBB2_3:
	ret
                                        # -- End function
axpy32int_rvv2:                         # @axpy32int_rvv2
	vsetvli	a6, zero, e32, m1, ta, mu
	bgeu	a6, a0, .LBB3_4
	li	a4, 0
	mv	a5, a6
.LBB3_2:                                # =>This Inner Loop Header: Depth=1
	slli	a4, a4, 32
	srli	a4, a4, 30
	add	a7, a2, a4
	vsetvli	zero, a6, e32, m1, ta, mu
	vle32.v	v8, (a7)
	add	a4, a4, a3
	vle32.v	v9, (a4)
	mv	a7, a5
	vsetvli	zero, zero, e32, m1, tu, mu
	vmacc.vx	v9, a1, v8
	addw	a5, a5, a6
	vse32.v	v9, (a4)
	mv	a4, a7
	bltu	a5, a0, .LBB3_2
	sext.w	a4, a7
	bltu	a4, a0, .LBB3_5
	j	.LBB3_12
.LBB3_4:
	li	a7, 0
	sext.w	a4, a7
	bgeu	a4, a0, .LBB3_12
.LBB3_5:
	slli	a4, a7, 32
	srli	a4, a4, 32
	slli	a0, a0, 32
	srli	a7, a0, 32
	sub	t1, a7, a4
	li	a0, 16
	bgeu	t1, a0, .LBB3_7
	mv	t0, a4
	j	.LBB3_10
.LBB3_7:
	andi	a6, t1, -16
	add	t0, a6, a4
	slli	a0, a4, 2
	addi	a4, a0, 32
	add	a0, a2, a4
	add	a4, a4, a3
	mv	a5, a6
.LBB3_8:                                # =>This Inner Loop Header: Depth=1
	addi	t2, a0, -32
	vsetivli	zero, 8, e32, m1, ta, mu
	vle32.v	v8, (t2)
	vle32.v	v9, (a0)
	addi	t2, a4, -32
	vle32.v	v10, (t2)
	vle32.v	v11, (a4)
	vmacc.vx	v10, a1, v8
	vmacc.vx	v11, a1, v9
	vse32.v	v10, (t2)
	vse32.v	v11, (a4)
	addi	a5, a5, -16
	addi	a0, a0, 64
	addi	a4, a4, 64
	bnez	a5, .LBB3_8
	beq	t1, a6, .LBB3_12
.LBB3_10:
	slli	a4, t0, 2
	add	a0, a2, a4
	add	a2, a3, a4
	sub	a3, a7, t0
.LBB3_11:                               # =>This Inner Loop Header: Depth=1
	lw	a4, 0(a0)
	lw	a5, 0(a2)
	mulw	a4, a4, a1
	addw	a4, a4, a5
	sw	a4, 0(a2)
	addi	a0, a0, 4
	addi	a3, a3, -1
	addi	a2, a2, 4
	bnez	a3, .LBB3_11
.LBB3_12:
	ret
                                        # -- End function
