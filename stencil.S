stencil_2d_5p:                          # @stencil_2d_5p
	addi	sp, sp, -80
	sd	s0, 72(sp)                      # 8-byte Folded Spill
	sd	s1, 64(sp)                      # 8-byte Folded Spill
	sd	s2, 56(sp)                      # 8-byte Folded Spill
	sd	s3, 48(sp)                      # 8-byte Folded Spill
	sd	s4, 40(sp)                      # 8-byte Folded Spill
	sd	s5, 32(sp)                      # 8-byte Folded Spill
	sd	s6, 24(sp)                      # 8-byte Folded Spill
	sd	s7, 16(sp)                      # 8-byte Folded Spill
	sd	s8, 8(sp)                       # 8-byte Folded Spill
	addi	s2, a0, 1
	li	a0, 2
	bltu	s2, a0, .LBB0_11
	addi	s3, a1, 2
	addi	t4, a1, -1
	andi	a6, a1, -4
	ori	a7, a6, 1
	vsetivli	zero, 4, e64, m1, ta, mu
	vfmv.v.f	v8, fa0
	vfmv.v.f	v9, fa2
	vfmv.v.f	v10, fa3
	vfmv.v.f	v11, fa4
	addi	t0, a2, 8
	addi	t1, a3, 8
	addi	t2, a2, 16
	addi	t3, a1, 1
	li	s7, 1
	li	t5, -2
	li	t6, 4
	j	.LBB0_4
.LBB0_2:                                #   in Loop: Header=BB0_4 Depth=1
	addi	s7, s7, 1
.LBB0_3:                                #   in Loop: Header=BB0_4 Depth=1
	beq	s7, s2, .LBB0_11
.LBB0_4:                                # =>This Loop Header: Depth=1
                                        #     Child Loop BB0_7 Depth 2
                                        #     Child Loop BB0_10 Depth 2
	bgeu	t4, t5, .LBB0_2
	addi	a0, s7, -1
	mul	s4, a0, s3
	mul	s5, s7, s3
	addi	s7, s7, 1
	mul	s6, s7, s3
	li	a5, 1
	bltu	a1, t6, .LBB0_9
	slli	a0, s4, 3
	add	s8, t0, a0
	slli	a0, s5, 3
	add	s0, t1, a0
	slli	a5, s6, 3
	add	s1, t0, a5
	add	a0, a0, t2
	mv	a5, a6
.LBB0_7:                                #   Parent Loop BB0_4 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	addi	a4, a0, -16
	vle64.v	v12, (a4)
	vle64.v	v13, (s8)
	vfmul.vf	v12, v12, fa1
	addi	a4, a0, -8
	vle64.v	v14, (a4)
	vle64.v	v15, (a0)
	vle64.v	v16, (s1)
	vfmacc.vv	v12, v8, v13
	vfmadd.vv	v14, v9, v12
	vfmadd.vv	v15, v10, v14
	vfmadd.vv	v16, v11, v15
	vse64.v	v16, (s0)
	addi	a5, a5, -4
	addi	s8, s8, 32
	addi	s0, s0, 32
	addi	s1, s1, 32
	addi	a0, a0, 32
	bnez	a5, .LBB0_7
	mv	a5, a7
	beq	a6, a1, .LBB0_3
.LBB0_9:                                #   in Loop: Header=BB0_4 Depth=1
	sub	a4, t3, a5
	add	a0, a5, s6
	slli	a0, a0, 3
	add	a0, a0, a2
	add	s0, a5, s5
	slli	s1, s0, 3
	add	s0, a3, s1
	add	a5, a5, s4
	slli	a5, a5, 3
	add	a5, a5, a2
	add	s1, s1, a2
.LBB0_10:                               #   Parent Loop BB0_4 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	fld	ft0, -8(s1)
	fld	ft1, 0(a5)
	fmul.d	ft0, ft0, fa1
	fld	ft2, 0(s1)
	fld	ft3, 8(s1)
	fmadd.d	ft0, fa0, ft1, ft0
	fld	ft1, 0(a0)
	fmadd.d	ft0, fa2, ft2, ft0
	fmadd.d	ft0, fa3, ft3, ft0
	addi	s1, s1, 8
	fmadd.d	ft0, fa4, ft1, ft0
	fsd	ft0, 0(s0)
	addi	a4, a4, -1
	addi	a0, a0, 8
	addi	s0, s0, 8
	addi	a5, a5, 8
	bnez	a4, .LBB0_10
	j	.LBB0_3
.LBB0_11:
	ld	s0, 72(sp)                      # 8-byte Folded Reload
	ld	s1, 64(sp)                      # 8-byte Folded Reload
	ld	s2, 56(sp)                      # 8-byte Folded Reload
	ld	s3, 48(sp)                      # 8-byte Folded Reload
	ld	s4, 40(sp)                      # 8-byte Folded Reload
	ld	s5, 32(sp)                      # 8-byte Folded Reload
	ld	s6, 24(sp)                      # 8-byte Folded Reload
	ld	s7, 16(sp)                      # 8-byte Folded Reload
	ld	s8, 8(sp)                       # 8-byte Folded Reload
	addi	sp, sp, 80
	ret
                                        # -- End function
stencil_2d_9p:                          # @stencil_2d_9p
	addi	sp, sp, -80
	sd	s0, 72(sp)                      # 8-byte Folded Spill
	sd	s1, 64(sp)                      # 8-byte Folded Spill
	sd	s2, 56(sp)                      # 8-byte Folded Spill
	sd	s3, 48(sp)                      # 8-byte Folded Spill
	sd	s4, 40(sp)                      # 8-byte Folded Spill
	sd	s5, 32(sp)                      # 8-byte Folded Spill
	sd	s6, 24(sp)                      # 8-byte Folded Spill
	sd	s7, 16(sp)                      # 8-byte Folded Spill
	addi	t6, a0, 1
	li	a0, 2
	sd	a2, 8(sp)
	bltu	t6, a0, .LBB1_11
	fld	ft0, 8(sp)
	addi	s2, a1, 2
	addi	t3, a1, -1
	andi	a6, a1, -4
	ori	a7, a6, 1
	vsetivli	zero, 4, e64, m1, ta, mu
	vfmv.v.f	v8, fa0
	vfmv.v.f	v9, fa2
	vfmv.v.f	v10, fa3
	vfmv.v.f	v11, fa4
	vfmv.v.f	v12, fa5
	vfmv.v.f	v13, fa6
	vfmv.v.f	v14, fa7
	vfmv.v.f	v15, ft0
	addi	t0, a4, 8
	addi	t1, a3, 16
	addi	t2, a1, 1
	li	s6, 1
	li	t4, -2
	li	t5, 4
	j	.LBB1_4
.LBB1_2:                                #   in Loop: Header=BB1_4 Depth=1
	addi	s6, s6, 1
.LBB1_3:                                #   in Loop: Header=BB1_4 Depth=1
	beq	s6, t6, .LBB1_11
.LBB1_4:                                # =>This Loop Header: Depth=1
                                        #     Child Loop BB1_7 Depth 2
                                        #     Child Loop BB1_10 Depth 2
	bgeu	t3, t4, .LBB1_2
	addi	a0, s6, -1
	mul	s5, a0, s2
	mul	s4, s6, s2
	addi	s6, s6, 1
	mul	s3, s6, s2
	li	s1, 1
	bltu	a1, t5, .LBB1_9
	slli	a5, s4, 3
	add	s7, t0, a5
	slli	a0, s5, 3
	add	a0, a0, t1
	slli	s0, s3, 3
	add	s0, s0, t1
	add	s1, t1, a5
	mv	a5, a6
.LBB1_7:                                #   Parent Loop BB1_4 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	addi	a2, a0, -8
	vle64.v	v16, (a2)
	addi	a2, a0, -16
	vle64.v	v17, (a2)
	vfmul.vf	v16, v16, fa1
	vle64.v	v18, (a0)
	addi	a2, s1, -16
	vle64.v	v19, (a2)
	addi	a2, s1, -8
	vle64.v	v20, (a2)
	vfmacc.vv	v16, v8, v17
	vfmadd.vv	v18, v9, v16
	vfmadd.vv	v19, v10, v18
	vfmadd.vv	v20, v11, v19
	vle64.v	v16, (s1)
	addi	a2, s0, -16
	vle64.v	v17, (a2)
	addi	a2, s0, -8
	vle64.v	v18, (a2)
	vle64.v	v19, (s0)
	vfmadd.vv	v16, v12, v20
	vfmadd.vv	v17, v13, v16
	vfmadd.vv	v18, v14, v17
	vfmadd.vv	v19, v15, v18
	vse64.v	v19, (s7)
	addi	a5, a5, -4
	addi	s7, s7, 32
	addi	a0, a0, 32
	addi	s0, s0, 32
	addi	s1, s1, 32
	bnez	a5, .LBB1_7
	mv	s1, a7
	beq	a6, a1, .LBB1_3
.LBB1_9:                                #   in Loop: Header=BB1_4 Depth=1
	sub	a0, t2, s1
	add	a2, s1, s5
	slli	a2, a2, 3
	add	a5, a3, a2
	add	a2, s1, s4
	slli	s0, a2, 3
	add	a2, a4, s0
	add	s0, s0, a3
	add	s1, s1, s3
	slli	s1, s1, 3
	add	s1, s1, a3
.LBB1_10:                               #   Parent Loop BB1_4 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	fld	ft1, 0(a5)
	fld	ft2, -8(a5)
	fld	ft3, 8(a5)
	fld	ft4, -8(s0)
	fmul.d	ft1, ft1, fa1
	fmadd.d	ft1, fa0, ft2, ft1
	fmadd.d	ft1, fa2, ft3, ft1
	fmadd.d	ft1, fa3, ft4, ft1
	fld	ft2, 0(s0)
	fld	ft3, 8(s0)
	fld	ft4, -8(s1)
	fld	ft5, 0(s1)
	fmadd.d	ft1, fa4, ft2, ft1
	fmadd.d	ft1, fa5, ft3, ft1
	fmadd.d	ft1, fa6, ft4, ft1
	fmadd.d	ft1, fa7, ft5, ft1
	fld	ft2, 8(s1)
	addi	a5, a5, 8
	addi	s0, s0, 8
	addi	s1, s1, 8
	fmadd.d	ft1, ft0, ft2, ft1
	fsd	ft1, 0(a2)
	addi	a0, a0, -1
	addi	a2, a2, 8
	bnez	a0, .LBB1_10
	j	.LBB1_3
.LBB1_11:
	ld	s0, 72(sp)                      # 8-byte Folded Reload
	ld	s1, 64(sp)                      # 8-byte Folded Reload
	ld	s2, 56(sp)                      # 8-byte Folded Reload
	ld	s3, 48(sp)                      # 8-byte Folded Reload
	ld	s4, 40(sp)                      # 8-byte Folded Reload
	ld	s5, 32(sp)                      # 8-byte Folded Reload
	ld	s6, 24(sp)                      # 8-byte Folded Reload
	ld	s7, 16(sp)                      # 8-byte Folded Reload
	addi	sp, sp, 80
	ret
                                        # -- End function
