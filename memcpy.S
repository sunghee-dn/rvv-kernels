memcpy_simple:                          # @memcpy_simple
	addi	sp, sp, -16
	sd	ra, 8(sp)                       # 8-byte Folded Spill
	sd	s0, 0(sp)                       # 8-byte Folded Spill
	mv	s0, a0
	beqz	a2, .LBB0_2
	mv	a0, s0
	call	memcpy@plt
.LBB0_2:
	mv	a0, s0
	ld	ra, 8(sp)                       # 8-byte Folded Reload
	ld	s0, 0(sp)                       # 8-byte Folded Reload
	addi	sp, sp, 16
	ret
                                        # -- End function
memcpy_libc:                            # @memcpy_libc
	tail	memcpy@plt
                                        # -- End function
