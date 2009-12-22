/* Intel Pentium-4 gmp-mparam.h -- Compiler/machine parameter header file.

Copyright 1991, 1993, 1994, 2000, 2001, 2002, 2003, 2004, 2005, 2007, 2008,
2009 Free Software Foundation, Inc.

This file is part of the GNU MP Library.

The GNU MP Library is free software; you can redistribute it and/or modify
it under the terms of the GNU Lesser General Public License as published by
the Free Software Foundation; either version 3 of the License, or (at your
option) any later version.

The GNU MP Library is distributed in the hope that it will be useful, but
WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY
or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU Lesser General Public
License for more details.

You should have received a copy of the GNU Lesser General Public License
along with the GNU MP Library.  If not, see http://www.gnu.org/licenses/.  */

#define GMP_LIMB_BITS 32
#define BYTES_PER_MP_LIMB 4


#define MUL_TOOM22_THRESHOLD               31
#define MUL_TOOM33_THRESHOLD              109
#define MUL_TOOM44_THRESHOLD              292

#define MUL_TOOM32_TO_TOOM43_THRESHOLD    199
#define MUL_TOOM32_TO_TOOM53_THRESHOLD    209
#define MUL_TOOM42_TO_TOOM53_THRESHOLD    207
#define MUL_TOOM42_TO_TOOM63_THRESHOLD    195

#define SQR_BASECASE_THRESHOLD              0  /* always (native) */
#define SQR_TOOM2_THRESHOLD                49
#define SQR_TOOM3_THRESHOLD               171
#define SQR_TOOM4_THRESHOLD               458

#define MULMOD_BNM1_THRESHOLD              17
#define SQRMOD_BNM1_THRESHOLD              20

#define MUL_FFT_TABLE  { 528, 1184, 1664, 4608, 14336, 40960, 229376, 655360, 0 }
#define MUL_FFT_MODF_THRESHOLD            592
#define MUL_FFT_THRESHOLD                9216

#define SQR_FFT_TABLE  { 496, 1184, 1920, 5632, 14336, 40960, 163840, 655360, 0 }
#define SQR_FFT_MODF_THRESHOLD            512
#define SQR_FFT_THRESHOLD                4864

#define MULLO_BASECASE_THRESHOLD           12
#define MULLO_DC_THRESHOLD                 51
#define MULLO_MUL_N_THRESHOLD            9324

#define DC_DIV_QR_THRESHOLD                28
#define DC_DIVAPPR_Q_THRESHOLD             70
#define DC_BDIV_QR_THRESHOLD               54
#define DC_BDIV_Q_THRESHOLD                88

#define INV_MULMOD_BNM1_THRESHOLD          61
#define INV_NEWTON_THRESHOLD              140
#define INV_APPR_THRESHOLD                  9

#define BINV_NEWTON_THRESHOLD             375
#define REDC_1_TO_REDC_N_THRESHOLD         65

#define MATRIX22_STRASSEN_THRESHOLD        29
#define HGCD_THRESHOLD                     68
#define GCD_DC_THRESHOLD                  283
#define GCDEXT_DC_THRESHOLD               237
#define JACOBI_BASE_METHOD                  2

#define MOD_1_NORM_THRESHOLD               29
#define MOD_1_UNNORM_THRESHOLD          MP_SIZE_T_MAX  /* never */
#define MOD_1_1_THRESHOLD                  12
#define MOD_1_2_THRESHOLD                  17
#define MOD_1_4_THRESHOLD                  18
#define USE_PREINV_DIVREM_1                 1  /* native */
#define USE_PREINV_MOD_1                    1
#define DIVEXACT_1_THRESHOLD                0  /* always (native) */
#define MODEXACT_1_ODD_THRESHOLD            0  /* always (native) */

#define GET_STR_DC_THRESHOLD               12
#define GET_STR_PRECOMPUTE_THRESHOLD       24
#define SET_STR_DC_THRESHOLD              148
#define SET_STR_PRECOMPUTE_THRESHOLD     1037
