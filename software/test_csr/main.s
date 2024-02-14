# Copyright (c) 2020 Sonal Pinto
# SPDX-License-Identifier: Apache-2.0

.section .text;
.globl main;
main: 
    csrrw x11, fflags, x4;
    csrrw x12, frm, x5;
    csrrw x13, fcsr, x6;

    csrrw x14, fflags, x4;
    csrrw x15, frm, x14;
    csrrw x16, fcsr, x14;

    csrrs x16, fflags, x4;
    csrrs x14, frm, x16;
    csrrs x15, fcsr, x14;

    csrrc x14, fflags, x4;
    csrrc x15, frm, x14;
    csrrc x16, fcsr, x0;

    csrrwi x14, fflags, 0x1d;
    csrrwi x15, frm, 0x0a;
    csrrwi x16, fcsr, 0x14;

    csrrsi x16, fflags, 0x1d;
    csrrsi x14, frm, 0x0e;
    csrrsi x15, fcsr, 0x0d;

    csrrci x14, fflags, 0x0d;
    csrrci x15, frm, 0x1d;
    csrrci x16, fcsr, 0x07;