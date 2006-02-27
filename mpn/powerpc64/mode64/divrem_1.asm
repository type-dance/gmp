dnl  PowerPC-64 mpn_divrem_1 -- Divide an mpn number by an unnormalized limb.

dnl  Copyright 2003, 2005 Free Software Foundation, Inc.

dnl  This file is part of the GNU MP Library.

dnl  The GNU MP Library is free software; you can redistribute it and/or modify
dnl  it under the terms of the GNU Lesser General Public License as published
dnl  by the Free Software Foundation; either version 2.1 of the License, or (at
dnl  your option) any later version.

dnl  The GNU MP Library is distributed in the hope that it will be useful, but
dnl  WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY
dnl  or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU Lesser General Public
dnl  License for more details.

dnl  You should have received a copy of the GNU Lesser General Public License
dnl  along with the GNU MP Library; see the file COPYING.LIB.  If not, write
dnl  to the Free Software Foundation, Inc., 51 Franklin Street, Fifth Floor,
dnl  Boston, MA 02110-1301, USA.

include(`../config.m4')

C		cycles/limb
C POWER3/PPC630:    40/30
C POWER4/PPC970:    40/22 (40-49 cycles for integer part, 22 stably for fraction)

C INPUT PARAMETERS
C qp  = r3
C qxn = r4
C up  = r5
C n   = r6
C vl  = r7

C This was generated by gcc, then the code was manually edited.  Lots of things
C could be streamlined.  It would probably be a good idea to merge the loops
C for normalized and unnormalized divisor, since the shifting stuff is done for
C free in parallel with other operations.

C FIXME: Replace divdu-based invert_limb code below!!!

ASM_START()
PROLOGUE(mpn_divrem_1)
	std	r27,-40(r1)
	mr	r27,r4
	std	r28,-32(r1)
	mr	r28,r5
	std	r31,-8(r1)
	mr	r31,r3
	li	r3,0
	std	r29,-24(r1)
	std	r30,-16(r1)
	add.	r11,r6,r27		C n = un + qxn
	bne	cr0,L(221)
	b	L(ret)
L(221):	sldi	r0,r11,3
	rldicr.	r8,r7,0,0		C test most significant vl bit
	add	r10,r31,r0		C qp += n
	addi	r31,r10,-8		C qp -= 1
	beq	cr0,L(salamin)		C branch to 2nd code block
	cmpdi	cr0,r6,0
	beq	cr0,L(224)
C High quotient limb is 0 or 1, skip a divide step
	sldi	r9,r6,3
	addi	r31,r31,-8
	add	r9,r28,r9
	addi	r6,r6,-1
	ld	r3,-8(r9)
	subfc	r11,r7,r3
	li	r11,0
	adde	r11,r11,r11
	neg	r0,r11
	std	r11,-8(r10)
	and	r0,r7,r0
	subf	r3,r0,r3

C Start invert_limb
L(224):	sldi.	r0,r7,1
	bne	cr0,L(642)
	li	r9,-1			C invert value for 0x80...0
	b	L(274)
L(642):	srdi	r5,r7,32
	neg	r0,r7
	li	r11,1
	sldi	r11,r11,32
	divdu	r8,r0,r5
	rldicl	r30,r7,0,32
	mulld	r9,r8,r5
	mulld	r12,r8,r30
	subf	r10,r9,r0
	mulld	r10,r10,r11
	cmpld	cr0,r10,r12
	bge	cr0,L(293)
	add	r10,r10,r7
	addi	r8,r8,-1
	cmpld	cr0,r10,r7
	blt	cr0,L(293)
	cmpld	cr0,r10,r12
	bge	cr0,L(293)
	addi	r8,r8,-1
	add	r10,r10,r7
L(293):	subf	r10,r12,r10
	li	r9,1
	sldi	r9,r9,32
	divdu	r11,r10,r5
	mulld	r0,r11,r5
	mulld	r12,r11,r30
	subf	r0,r0,r10
	mulld	r0,r0,r9
	cmpld	cr0,r0,r12
	bge	cr0,L(296)
	add	r0,r0,r7
	addi	r11,r11,-1
	cmpld	cr0,r0,r7
	blt	cr0,L(296)
	cmpld	cr0,r0,r12
	bge	cr0,L(296)
	addi	r11,r11,-1
L(296):	li	r0,1
	sldi	r0,r0,32
	mulld	r0,r8,r0
	or	r9,r0,r11
C End invert_limb

L(274):	addic.	r12,r6,-1
	mtctr	r6
	blt	cr0,L(638)
	sldi	r0,r12,3
	add	r28,r28,r0

Loop1:	ld	r6,0(r28)
	addi	r28,r28,-8
	mulhdu	r11,r3,r9
	add	r11,r11,r3
	mulhdu	r10,r11,r7
	mulld	r0,r11,r7
	subfc	r8,r0,r6
	subfe	r10,r10,r3
	mr	r3,r8
	cmpdi	cr0,r10,0
	beq	cr0,L(332)
	subfc	r3,r7,r3
	addme	r10,r10
	addi	r11,r11,1
	cmpdi	cr0,r10,0
	beq	cr0,L(332)
	subf	r3,r7,r3
	addi	r11,r11,1
L(332):	cmpld	cr0,r3,r7
	blt	cr0,L(346)
	subf	r3,r7,r3
	addi	r11,r11,1
L(346):	std	r11,0(r31)
	addi	r31,r31,-8
	bdnz	Loop1

L(638):	addic.	r12,r27,-1
	mtctr	r27
	blt	cr0,L(ret)

Loop2:	mulhdu	r11,r3,r9
	add	r11,r11,r3
	mulhdu	r10,r11,r7
	mulld	r0,r11,r7
	subfic	r8,r0,0
	subfe	r10,r10,r3
	mr	r3,r8
	cmpdi	cr0,r10,0
	beq	cr0,L(380)
	subfc	r3,r7,r3
	addme	r10,r10
	addi	r11,r11,1
	cmpdi	cr0,r10,0
	beq	cr0,L(380)
	subf	r3,r7,r3
	addi	r11,r11,1
L(380):	cmpld	cr0,r3,r7
	blt	cr0,L(394)
	subf	r3,r7,r3
	addi	r11,r11,1
L(394):	std	r11,0(r31)
	addi	r31,r31,-8
	bdnz	Loop2

	b	L(ret)

L(salamin):
	cmpdi	cr0,r6,0
	beq	cr0,L(401)
	sldi	r9,r6,3
	add	r9,r28,r9
	ld	r5,-8(r9)
	cmpld	cr0,r5,r7
	bge	cr0,L(401)
	cmpdi	cr0,r11,1
	std	r8,-8(r10)
	mr	r3,r5
	addi	r31,r31,-8
	bne	cr0,L(400)
	b	L(ret)

L(400):	addi	r6,r6,-1
L(401):	cntlzd	r30,r7
	sld	r7,r7,r30
	sld	r3,r3,r30

C Start invert_limb
	sldi.	r8,r7,1
	bne	cr0,L(643)
	li	r4,-1			C invert value for 0x80...0
	b	L(470)
L(643):	srdi	r5,r7,32
	neg	r0,r7
	li	r11,1
	sldi	r11,r11,32
	divdu	r8,r0,r5
	rldicl	r4,r7,0,32
	mulld	r9,r8,r5
	mulld	r12,r8,r4
	subf	r10,r9,r0
	mulld	r10,r10,r11
	cmpld	cr0,r10,r12
	bge	cr0,L(489)
	add	r10,r10,r7
	addi	r8,r8,-1
	cmpld	cr0,r10,r7
	blt	cr0,L(489)
	cmpld	cr0,r10,r12
	bge	cr0,L(489)
	addi	r8,r8,-1
	add	r10,r10,r7
L(489):	subf	r10,r12,r10
	li	r9,1
	sldi	r9,r9,32
	divdu	r11,r10,r5
	mulld	r0,r11,r5
	mulld	r12,r11,r4
	subf	r0,r0,r10
	mulld	r0,r0,r9
	cmpld	cr0,r0,r12
	bge	cr0,L(492)
	add	r0,r0,r7
	addi	r11,r11,-1
	cmpld	cr0,r0,r7
	blt	cr0,L(492)
	cmpld	cr0,r0,r12
	bge	cr0,L(492)
	addi	r11,r11,-1
L(492):	li	r0,1
	sldi	r0,r0,32
	mulld	r0,r8,r0
	or	r4,r0,r11
C End invert_limb

L(470):	cmpdi	cr0,r6,0
	beq	cr0,L(497)
	sldi	r9,r6,3
	subfic	r11,r30,64
	add	r9,r28,r9
	mtctr	r6
	addi	r12,r6,-2
	ld	r5,-8(r9)
	srd	r0,r5,r11
	or	r3,r3,r0
	bdz	L(640)
	mr	r29,r11
	sldi	r0,r12,3
	add	r28,r28,r0

Loop3:	ld	r6,0(r28)
	addi	r28,r28,-8
	mulhdu	r8,r3,r4
	add	r8,r8,r3
	mulhdu	r10,r8,r7
	mulld	r11,r8,r7
	sld	r0,r5,r30
	srd	r9,r6,r29
	or	r0,r0,r9
	subfc	r9,r11,r0
	subfe	r10,r10,r3
	mr	r3,r9
	cmpdi	cr0,r10,0
	beq	cr0,L(529)
	subfc	r3,r7,r3
	addme	r10,r10
	addi	r8,r8,1
	cmpdi	cr0,r10,0
	beq	cr0,L(529)
	subf	r3,r7,r3
	addi	r8,r8,1
L(529):	cmpld	cr0,r3,r7
	blt	cr0,L(543)
	subf	r3,r7,r3
	addi	r8,r8,1
L(543):	std	r8,0(r31)
	addi	r31,r31,-8
	mr	r5,r6
	bdnz	Loop3

L(640):	mulhdu	r11,r3,r4
	add	r11,r11,r3
	mulhdu	r10,r11,r7
	mulld	r9,r11,r7
	sld	r0,r5,r30
	subfc	r8,r9,r0
	subfe	r10,r10,r3
	mr	r3,r8
	cmpdi	cr0,r10,0
	beq	cr0,L(573)
	subfc	r9,r7,r3
	addme	r10,r10
	mr	r3,r9
	addi	r11,r11,1
	cmpdi	cr0,r10,0
	beq	cr0,L(573)
	subf	r3,r7,r3
	addi	r11,r11,1
L(573):	cmpld	cr0,r3,r7
	blt	cr0,L(587)
	subf	r3,r7,r3
	addi	r11,r11,1
L(587):	std	r11,0(r31)
	addi	r31,r31,-8
L(497):	addic.	r12,r27,-1
	mtctr	r27
	blt	cr0,L(641)

Loop4:	mulhdu	r11,r3,r4
	add	r11,r11,r3
	mulhdu	r9,r11,r7
	mulld	r0,r11,r7
	subfic	r10,r0,0
	subfe	r9,r9,r3
	mr	r3,r10
	cmpdi	cr0,r9,0
	beq	cr0,L(620)
	subfc	r0,r7,r3
	addme	r9,r9
	mr	r3,r0
	addi	r11,r11,1
	cmpdi	cr0,r9,0
	beq	cr0,L(620)
	subf	r3,r7,r3
	addi	r11,r11,1
L(620):	cmpld	cr0,r3,r7
	blt	cr0,L(634)
	subf	r3,r7,r3
	addi	r11,r11,1
L(634):	std	r11,0(r31)
	addi	r31,r31,-8
	bdnz	Loop4

L(641):	srd	r3,r3,r30
L(ret):	ld	r27,-40(r1)
	ld	r28,-32(r1)
	ld	r29,-24(r1)
	ld	r30,-16(r1)
	ld	r31,-8(r1)
	blr
EPILOGUE(mpn_divrem_1)
