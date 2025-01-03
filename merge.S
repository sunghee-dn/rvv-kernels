merge:                                  # @merge
	addi	sp, sp, -64
	sd	ra, 56(sp)                      # 8-byte Folded Spill
	sd	s0, 48(sp)                      # 8-byte Folded Spill
	sd	s1, 40(sp)                      # 8-byte Folded Spill
	sd	s2, 32(sp)                      # 8-byte Folded Spill
	sd	s3, 24(sp)                      # 8-byte Folded Spill
	sd	s4, 16(sp)                      # 8-byte Folded Spill
	sd	s5, 8(sp)                       # 8-byte Folded Spill
	sd	s6, 0(sp)                       # 8-byte Folded Spill
	mv	s4, a2
	mv	s5, a0
	seqz	a0, a0
	seqz	a2, a2
	or	a0, a0, a2
	mv	s2, a4
	mv	s3, a3
	li	s1, 0
	li	s0, 0
	li	s6, 0
	bnez	a0, .LBB0_5
	li	s6, 0
	li	s0, 0
	li	s1, 0
	mv	a0, s2
	j	.LBB0_3
.LBB0_2:                                #   in Loop: Header=BB0_3 Depth=1
	xori	a3, a2, 1
	add	s1, s1, a2
	add	s0, s0, a3
	fsd	ft0, 0(a0)
	addi	s6, s6, 1
	sltu	a2, s1, s5
	sltu	a3, s0, s4
	and	a2, a2, a3
	addi	a0, a0, 8
	beqz	a2, .LBB0_5
.LBB0_3:                                # =>This Inner Loop Header: Depth=1
	slli	a2, s1, 3
	add	a2, a2, a1
	fld	ft0, 0(a2)
	slli	a2, s0, 3
	add	a2, a2, s3
	fld	ft1, 0(a2)
	flt.d	a2, ft0, ft1
	bnez	a2, .LBB0_2
	fmv.d	ft0, ft1
	j	.LBB0_2
.LBB0_5:
	bgeu	s1, s5, .LBB0_7
	slli	a0, s6, 3
	add	a0, a0, s2
	slli	a2, s1, 3
	add	a1, a1, a2
	sub	a2, s5, s1
	slli	a2, a2, 3
	call	memcpy@plt
	add	a0, s6, s5
	sub	s6, a0, s1
.LBB0_7:
	bgeu	s0, s4, .LBB0_9
	slli	a0, s6, 3
	add	a0, a0, s2
	slli	a1, s0, 3
	add	a1, a1, s3
	sub	a2, s4, s0
	slli	a2, a2, 3
	call	memcpy@plt
.LBB0_9:
	ld	ra, 56(sp)                      # 8-byte Folded Reload
	ld	s0, 48(sp)                      # 8-byte Folded Reload
	ld	s1, 40(sp)                      # 8-byte Folded Reload
	ld	s2, 32(sp)                      # 8-byte Folded Reload
	ld	s3, 24(sp)                      # 8-byte Folded Reload
	ld	s4, 16(sp)                      # 8-byte Folded Reload
	ld	s5, 8(sp)                       # 8-byte Folded Reload
	ld	s6, 0(sp)                       # 8-byte Folded Reload
	addi	sp, sp, 64
	ret
                                        # -- End function
