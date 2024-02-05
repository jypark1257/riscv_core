# Copyright (c) 2020 Sonal Pinto
# SPDX-License-Identifier: Apache-2.0

.section .text;
.globl main;
main: 
    li x1, 0x0000FA05
    li x2, 0x0000FFFF
    li x3, 0x1234FFFA
    li x4, 0x00FFFA03
    li x5, 0xF234FF03
    li x6, 0x00000005
    li x7, 0x000000F3
    li x8, 0x00000003
    sw x1, 1024(x0)
    sw x2, 1028(x0)
    sw x3, 1032(x0)
    sw x4, 1036(x0)
    sw x5, 1040(x0)
    sw x6, 1044(x0)
    sw x7, 1048(x0)
    sw x8, 1052(x0)

jal:
    jal x18, beq
beq:
    beq x2, x3, bne
    beq x2, x2, bne
bne:
    bne x2, x2, blt
    bne x2, x3, blt
blt:
    blt x6, x5, bge
    blt x5, x6, bge
bge:
    bge x5, x4, bltu
    bge x4, x5, bltu
bltu:
    bltu x5, x6, bgeu
    bltu x6, x5, bgeu
bgeu:
    bgeu x4, x5, jalr
    bgeu x5, x4, jalr
jalr:
    jalr x20, 0(x0)

