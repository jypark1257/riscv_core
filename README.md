# 32-bit RISC-V CORE

4-stage, in-order core which implements the 32-bit RISC-V instruction set. It fully implements the I extension as specified in Volume I: User-Level ISA V 2.3.

# Quick setup

The following instructions will allow you to compile and run an icarus verilog model of the core within the Cocotb testbench (sim/test_core.py).

1. Checkout the repository
```sh
git clone https://github.com/jypark1257/riscv_core.git
cd riscv_core
```

2. Install the GCC Toolchain [riscv-gnu-toolchain](https://github.com/riscv-collab/riscv-gnu-toolchain)
```sh
git clone https://github.com/riscv-collab/riscv-gnu-toolchain.git --recursive
cd riscv-gnu-toolchain
./configure --prefix=/opt/riscv
make
```

3. Install the sifive [elf2hex](https://github.com/sifive/elf2hex.git)
```sh
git clone git://github.com/sifive/elf2hex.git
cd elf2hex
autoreconf -i
./configure --target=riscv64-unknown-elf
make
make install
```

4. Install the testbench environment [cocotb](https://docs.cocotb.org/en/stable/install.html)
```sh
sudo apt-get install make python3 python3-pip
pip install cocotb
```
# Running simulations

Simulating the core is done by using cocotb based testbench `sim/test_core.py`.

Compile your program using linker script `software/Makefile.gcc.in`.
* The skeleton program is included in `software/test`.

Here is how you can run the `software/test/test.c` C program with the cocotb testbench: 

```sh
cd software/test

# Compile C program using Makefile
# compiled hex will be automatically initiliazed in the memory of the core
make

cd ../../sim

# Make cocotb testbench model and generate waveform dump file
# the fst dump file can be found in ./sim_build/core_top.fst
make WAVES=1

# Check waveform
gtkwave ./sim_build/core_top.fst
```
