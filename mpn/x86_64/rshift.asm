dnl  AMD64 mpn_rshift -- mpn left shift.

dnl  Copyright 2003, 2005 Free Software Foundation, Inc.
dnl
dnl  This file is part of the GNU MP Library.
dnl
dnl  The GNU MP Library is free software; you can redistribute it and/or
dnl  modify it under the terms of the GNU Lesser General Public License as
dnl  published by the Free Software Foundation; either version 3 of the
dnl  License, or (at your option) any later version.
dnl
dnl  The GNU MP Library is distributed in the hope that it will be useful,
dnl  but WITHOUT ANY WARRANTY; without even the implied warranty of
dnl  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
dnl  Lesser General Public License for more details.
dnl
dnl  You should have received a copy of the GNU Lesser General Public License
dnl  along with the GNU MP Library.  If not, see http://www.gnu.org/licenses/.

include(`../config.m4')


C	     cycles/limb
C K8,K9:	 2.375
C K10:		 2.375
C P4:		 8
C P6-15:	 2.11


C INPUT PARAMETERS
C rp	rdi
C up	rsi
C n	rdx
C cnt	rcx

define(`rp',`%rdi')
define(`up',`%rsi')
define(`n',`%rdx')

ASM_START()
	TEXT
	ALIGN(32)
PROLOGUE(mpn_rshift)
	neg	%ecx			C put rsh count in cl
	mov	(up), %rax
	shl	%cl, %rax		C function return value
	neg	%ecx			C put lsh count in cl

	lea	1(n), R32(%r8)

	lea	-8(up,n,8), up
	lea	-8(rp,n,8), rp
	neg	n

	and	$3, R32(%r8)
	je	L(rlx)			C jump for n = 3, 7, 11, ...

	dec	R32(%r8)
	jne	L(1)
C	n = 4, 8, 12, ...
	mov	8(up,n,8), %r10
	shr	%cl, %r10
	neg	%ecx			C put rsh count in cl
	mov	16(up,n,8), %r8
	shl	%cl, %r8
	or	%r8, %r10
	mov	%r10, 8(rp,n,8)
	inc	n
	jmp	L(rll)

L(1):	dec	R32(%r8)
	je	L(1x)			C jump for n = 1, 5, 9, 13, ...
C	n = 2, 6, 10, 16, ...
	mov	8(up,n,8), %r10
	shr	%cl, %r10
	neg	%ecx			C put rsh count in cl
	mov	16(up,n,8), %r8
	shl	%cl, %r8
	or	%r8, %r10
	mov	%r10, 8(rp,n,8)
	inc	n
	neg	%ecx			C put lsh count in cl
L(1x):
	cmp	$-1, n
	je	L(ast)
	mov	8(up,n,8), %r10
	shr	%cl, %r10
	mov	16(up,n,8), %r11
	shr	%cl, %r11
	neg	%ecx			C put rsh count in cl
	mov	16(up,n,8), %r8
	mov	24(up,n,8), %r9
	shl	%cl, %r8
	or	%r8, %r10
	shl	%cl, %r9
	or	%r9, %r11
	mov	%r10, 8(rp,n,8)
	mov	%r11, 16(rp,n,8)
	add	$2, n

L(rll):	neg	%ecx			C put lsh count in cl
L(rlx):	mov	8(up,n,8), %r10
	shr	%cl, %r10
	mov	16(up,n,8), %r11
	shr	%cl, %r11

	add	$4, n			C				      4
	jb	L(end)			C				      2
	ALIGN(16)
L(oop):
	C finish stuff from lsh block
	neg	%ecx			C put rsh count in cl
	mov	-16(up,n,8), %r8
	mov	-8(up,n,8), %r9
	shl	%cl, %r8
	or	%r8, %r10
	shl	%cl, %r9
	or	%r9, %r11
	mov	%r10, -24(rp,n,8)
	mov	%r11, -16(rp,n,8)
	C start two new rsh
	mov	(up,n,8), %r8
	mov	8(up,n,8), %r9
	shl	%cl, %r8
	shl	%cl, %r9

	C finish stuff from rsh block
	neg	%ecx			C put lsh count in cl
	mov	-8(up,n,8), %r10
	mov	0(up,n,8), %r11
	shr	%cl, %r10
	or	%r10, %r8
	shr	%cl, %r11
	or	%r11, %r9
	mov	%r8, -8(rp,n,8)
	mov	%r9, 0(rp,n,8)
	C start two new lsh
	mov	8(up,n,8), %r10
	mov	16(up,n,8), %r11
	shr	%cl, %r10
	shr	%cl, %r11

	add	$4, n
	jae	L(oop)			C				      2
L(end):
	neg	%ecx			C put rsh count in cl
	mov	-16(up,n,8), %r8
	shl	%cl, %r8
	or	%r8, %r10
	mov	-8(up,n,8), %r9
	shl	%cl, %r9
	or	%r9, %r11
	mov	%r10, -24(rp,n,8)
	mov	%r11, -16(rp,n,8)

	neg	%ecx			C put lsh count in cl
L(ast):	mov	(up), %r10
	shr	%cl, %r10
	mov	%r10, (rp)
	ret
EPILOGUE()
