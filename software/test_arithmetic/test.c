unsigned int test_data[] = {    0x00000005,
                                0x0000FFFF,
                                0x1234FFFA,
                                0x00000003,
                                0x1234FF03,
                                0x00000005,
                                0x000000F3,
                                0x00000007,
                                0x00000008,
                                0x0000000F,
                                0x00000010,
                                0x0000000F};

int main(){

    asm volatile("lw x4, 1024(x0)\n \t");
    asm volatile("lh x5, 1032(x0)\n \t");
    asm volatile("lhu x2, 1032(x0)\n \t");
    asm volatile("lbu x3, 1032(x0)\n \t");
    asm volatile("lb x6, 1040(x0)\n \t");
    asm volatile("add x7, x5, x4\n \t");
    asm volatile("sub x8, x5, x4\n \t");
    asm volatile("xor x9, x5, x4\n \t");
    asm volatile("or x10, x5, x4\n \t");
    asm volatile("and x11, x5, x4\n \t");
    asm volatile("sll x12, x4, x6\n \t");
    asm volatile("srl x13, x5, x6\n \t");
    asm volatile("sra x14, x5, x6\n \t");
    asm volatile("slt x15, x5, x6\n \t");
    asm volatile("addi x7, x5, 14\n \t");
    asm volatile("xori x8, x5, -4\n \t");
    asm volatile("ori x9, x6, 7\n \t");
    asm volatile("andi x10, x4, 1\n \t");
    asm volatile("slli x11, x4, 3\n \t");
    asm volatile("srli x12, x5, 4\n \t");
    asm volatile("srai x13, x5, 4\n \t");
    asm volatile("slti x14, x5, 3\n \t");
    asm volatile("sltiu x15, x5, 3\n \t");
    asm volatile("lui x16, 7\n \t");
    asm volatile("auipc x17, 9\n \t");
    asm volatile("sb x2, 1025(x0)\n \t");
    asm volatile("sh x2, 1037(x0)\n \t");
    asm volatile("sw x6, 1052(x0)\n \t");
    asm volatile("lw x1, 1024(x0)\n \t");
    asm volatile("lw x2, 1036(x0)\n \t");
    asm volatile("lw x3, 1052(x0)\n \t");

    return 0;
}