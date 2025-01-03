axpy32:                                 # @axpy32
	beqz	a0, .LBB0_3
	slli	a0, a0, 32
	srli	a0, a0, 32
.LBB0_2:                                # =>This Inner Loop Header: Depth=1
	flw	ft0, 0(a1)
	flw	ft1, 0(a2)
	fmadd.s	ft0, fa0, ft0, ft1
	fsw	ft0, 0(a2)
	addi	a1, a1, 4
	addi	a0, a0, -1
	addi	a2, a2, 4
	bnez	a0, .LBB0_2
.LBB0_3:
	ret
                                        # -- End function
axpy32_compiler_vectorize:              # @axpy32_compiler_vectorize
	beqz	a0, .LBB1_8
	slli	a3, a0, 32
	li	a4, 16
	srli	a6, a3, 32
	bgeu	a0, a4, .LBB1_3
	li	a7, 0
	j	.LBB1_6
.LBB1_3:
	andi	a7, a6, -16
	vsetivli	zero, 8, e32, m1, ta, mu
	vfmv.v.f	v8, fa0
	addi	a4, a1, 32
	addi	a5, a2, 32
	mv	a0, a7
.LBB1_4:                                # =>This Inner Loop Header: Depth=1
	addi	a3, a4, -32
	vle32.v	v9, (a3)
	vle32.v	v10, (a4)
	addi	a3, a5, -32
	vle32.v	v11, (a3)
	vle32.v	v12, (a5)
	vfmacc.vv	v11, v8, v9
	vfmacc.vv	v12, v8, v10
	vse32.v	v11, (a3)
	vse32.v	v12, (a5)
	addi	a4, a4, 64
	addi	a0, a0, -16
	addi	a5, a5, 64
	bnez	a0, .LBB1_4
	beq	a7, a6, .LBB1_8
.LBB1_6:
	slli	a3, a7, 2
	add	a0, a1, a3
	add	a1, a2, a3
	sub	a2, a6, a7
.LBB1_7:                                # =>This Inner Loop Header: Depth=1
	flw	ft0, 0(a0)
	flw	ft1, 0(a1)
	fmadd.s	ft0, fa0, ft0, ft1
	fsw	ft0, 0(a1)
	addi	a0, a0, 4
	addi	a2, a2, -1
	addi	a1, a1, 4
	bnez	a2, .LBB1_7
.LBB1_8:
	ret
                                        # -- End function
axpy32_rvv:                             # @axpy32_rvv
	beqz	a0, .LBB2_3
	li	a3, 0
.LBB2_2:                                # =>This Inner Loop Header: Depth=1
	subw	a4, a0, a3
	slli	a4, a4, 32
	srli	a4, a4, 32
	vsetvli	a6, a4, e32, m1, ta, mu
	slli	a5, a3, 32
	srli	a5, a5, 30
	add	a4, a1, a5
	vle32.v	v8, (a4)
	add	a4, a2, a5
	vle32.v	v9, (a4)
	vsetvli	zero, a6, e32, m1, tu, mu
	vfmacc.vf	v9, fa0, v8
	addw	a3, a3, a6
	vse32.v	v9, (a4)
	bltu	a3, a0, .LBB2_2
.LBB2_3:
	ret
                                        # -- End function
axpy32_rvv2:                            # @axpy32_rvv2
	vsetvli	a6, zero, e32, m1, ta, mu
	bgeu	a6, a0, .LBB3_4
	li	a4, 0
	mv	a5, a6
.LBB3_2:                                # =>This Inner Loop Header: Depth=1
	slli	a3, a4, 32
	srli	a3, a3, 30
	add	a4, a1, a3
	vsetvli	zero, a6, e32, m1, ta, mu
	vle32.v	v8, (a4)
	add	a4, a2, a3
	vle32.v	v9, (a4)
	mv	a3, a5
	vsetvli	zero, zero, e32, m1, tu, mu
	vfmacc.vf	v9, fa0, v8
	addw	a5, a5, a6
	vse32.v	v9, (a4)
	mv	a4, a3
	bltu	a5, a0, .LBB3_2
	sext.w	a4, a3
	bltu	a4, a0, .LBB3_5
	j	.LBB3_12
.LBB3_4:
	li	a3, 0
	sext.w	a4, a3
	bgeu	a4, a0, .LBB3_12
.LBB3_5:
	slli	a3, a3, 32
	srli	a3, a3, 32
	slli	a0, a0, 32
	srli	a7, a0, 32
	sub	t1, a7, a3
	li	a0, 16
	bgeu	t1, a0, .LBB3_7
	mv	t0, a3
	j	.LBB3_10
.LBB3_7:
	andi	a6, t1, -16
	add	t0, a6, a3
	vsetivli	zero, 8, e32, m1, ta, mu
	vfmv.v.f	v8, fa0
	slli	a0, a3, 2
	addi	a0, a0, 32
	add	a5, a1, a0
	add	a0, a0, a2
	mv	a3, a6
.LBB3_8:                                # =>This Inner Loop Header: Depth=1
	addi	a4, a5, -32
	vle32.v	v9, (a4)
	vle32.v	v10, (a5)
	addi	a4, a0, -32
	vle32.v	v11, (a4)
	vle32.v	v12, (a0)
	vfmacc.vv	v11, v8, v9
	vfmacc.vv	v12, v8, v10
	vse32.v	v11, (a4)
	vse32.v	v12, (a0)
	addi	a3, a3, -16
	addi	a5, a5, 64
	addi	a0, a0, 64
	bnez	a3, .LBB3_8
	beq	t1, a6, .LBB3_12
.LBB3_10:
	slli	a3, t0, 2
	add	a0, a1, a3
	add	a1, a2, a3
	sub	a2, a7, t0
.LBB3_11:                               # =>This Inner Loop Header: Depth=1
	flw	ft0, 0(a0)
	flw	ft1, 0(a1)
	fmadd.s	ft0, fa0, ft0, ft1
	fsw	ft0, 0(a1)
	addi	a0, a0, 4
	addi	a2, a2, -1
	addi	a1, a1, 4
	bnez	a2, .LBB3_11
.LBB3_12:
	ret
                                        # -- End function
