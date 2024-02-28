# This file is public domain, it can be freely copied without restrictions.
# SPDX-License-Identifier: CC0-1.0

# test_my_design.py (simple)

import os
import random
from pathlib import Path

import cocotb
from cocotb.clock import Clock
from cocotb.runner import get_runner
from cocotb.triggers import RisingEdge
from cocotb.triggers import FallingEdge
from cocotb.triggers import Timer
from cocotb.types import LogicArray


@cocotb.test()
async def rvtest_add(dut):

    # memory initialization
    imem_path = "../../software/asm_tests/add.hex"
    # dmem_path = "/home/pjy-wsl/rv32i/dmem.mem"
    with open(imem_path, "r") as mem:
        first_line = mem.readline()
        idx  = 0
        for line in mem:
            inst = line.strip()  # Remove leading/trailing whitespaces and newline characters
            inst_decimal = int(inst, 16)
            dut.ram_0.dp_ram_0.mem[idx].value = (inst_decimal & 0x000000ff)
            dut.ram_0.dp_ram_0.mem[idx+1].value = (inst_decimal & 0x0000ff00) >> 8
            dut.ram_0.dp_ram_0.mem[idx+2].value = (inst_decimal & 0x00ff0000) >> 16
            dut.ram_0.dp_ram_0.mem[idx+3].value = (inst_decimal & 0xff000000) >> 24
            idx = idx + 4

    dut.i_rst_n.value = 0

    # Create a 10ns period clock on port clk
    clock = Clock(dut.i_clk, 10, units="ns")  
    # Start the clock. Start it low to avoid issues on the first RisingEdge
    cocotb.start_soon(clock.start(start_high=False))

    await Timer(1, units="ns")
    dut.i_rst_n.value = 1

    for _ in range(1000):
        
        await RisingEdge(dut.i_clk)

    assert dut.core_0.core_ID.rf.rf_data[3].value == 0xffffffff, "RVTEST_FAIL"



@cocotb.test()
async def rvtest_sub(dut):

    # memory initialization
    imem_path = "../../software/asm_tests/sub.hex"
    # dmem_path = "/home/pjy-wsl/rv32i/dmem.mem"
    with open(imem_path, "r") as mem:
        first_line = mem.readline()
        idx  = 0
        for line in mem:
            inst = line.strip()  # Remove leading/trailing whitespaces and newline characters
            inst_decimal = int(inst, 16)
            dut.ram_0.dp_ram_0.mem[idx].value = (inst_decimal & 0x000000ff)
            dut.ram_0.dp_ram_0.mem[idx+1].value = (inst_decimal & 0x0000ff00) >> 8
            dut.ram_0.dp_ram_0.mem[idx+2].value = (inst_decimal & 0x00ff0000) >> 16
            dut.ram_0.dp_ram_0.mem[idx+3].value = (inst_decimal & 0xff000000) >> 24
            idx = idx + 4

    dut.i_rst_n.value = 0

    # Create a 10ns period clock on port clk
    clock = Clock(dut.i_clk, 10, units="ns")  
    # Start the clock. Start it low to avoid issues on the first RisingEdge
    cocotb.start_soon(clock.start(start_high=False))

    await Timer(1, units="ns")
    dut.i_rst_n.value = 1

    for _ in range(1000):
        
        await RisingEdge(dut.i_clk)

    assert dut.core_0.core_ID.rf.rf_data[3].value == 0xffffffff, "RVTEST_FAIL"

    

@cocotb.test()
async def rvtest_xor(dut):

    # memory initialization
    imem_path = "../../software/asm_tests/xor.hex"
    # dmem_path = "/home/pjy-wsl/rv32i/dmem.mem"
    with open(imem_path, "r") as mem:
        first_line = mem.readline()
        idx  = 0
        for line in mem:
            inst = line.strip()  # Remove leading/trailing whitespaces and newline characters
            inst_decimal = int(inst, 16)
            dut.ram_0.dp_ram_0.mem[idx].value = (inst_decimal & 0x000000ff)
            dut.ram_0.dp_ram_0.mem[idx+1].value = (inst_decimal & 0x0000ff00) >> 8
            dut.ram_0.dp_ram_0.mem[idx+2].value = (inst_decimal & 0x00ff0000) >> 16
            dut.ram_0.dp_ram_0.mem[idx+3].value = (inst_decimal & 0xff000000) >> 24
            idx = idx + 4

    dut.i_rst_n.value = 0

    # Create a 10ns period clock on port clk
    clock = Clock(dut.i_clk, 10, units="ns")  
    # Start the clock. Start it low to avoid issues on the first RisingEdge
    cocotb.start_soon(clock.start(start_high=False))

    await Timer(1, units="ns")
    dut.i_rst_n.value = 1

    for _ in range(1000):
        
        await RisingEdge(dut.i_clk)

    assert dut.core_0.core_ID.rf.rf_data[3].value == 0xffffffff, "RVTEST_FAIL"

@cocotb.test()
async def rvtest_or(dut):

    # memory initialization
    imem_path = "../../software/asm_tests/or.hex"
    # dmem_path = "/home/pjy-wsl/rv32i/dmem.mem"
    with open(imem_path, "r") as mem:
        first_line = mem.readline()
        idx  = 0
        for line in mem:
            inst = line.strip()  # Remove leading/trailing whitespaces and newline characters
            inst_decimal = int(inst, 16)
            dut.ram_0.dp_ram_0.mem[idx].value = (inst_decimal & 0x000000ff)
            dut.ram_0.dp_ram_0.mem[idx+1].value = (inst_decimal & 0x0000ff00) >> 8
            dut.ram_0.dp_ram_0.mem[idx+2].value = (inst_decimal & 0x00ff0000) >> 16
            dut.ram_0.dp_ram_0.mem[idx+3].value = (inst_decimal & 0xff000000) >> 24
            idx = idx + 4

    dut.i_rst_n.value = 0

    # Create a 10ns period clock on port clk
    clock = Clock(dut.i_clk, 10, units="ns")  
    # Start the clock. Start it low to avoid issues on the first RisingEdge
    cocotb.start_soon(clock.start(start_high=False))

    await Timer(1, units="ns")
    dut.i_rst_n.value = 1

    for _ in range(1000):
        
        await RisingEdge(dut.i_clk)

    assert dut.core_0.core_ID.rf.rf_data[3].value == 0xffffffff, "RVTEST_FAIL"

@cocotb.test()
async def rvtest_and(dut):

    # memory initialization
    imem_path = "../../software/asm_tests/and.hex"
    # dmem_path = "/home/pjy-wsl/rv32i/dmem.mem"
    with open(imem_path, "r") as mem:
        first_line = mem.readline()
        idx  = 0
        for line in mem:
            inst = line.strip()  # Remove leading/trailing whitespaces and newline characters
            inst_decimal = int(inst, 16)
            dut.ram_0.dp_ram_0.mem[idx].value = (inst_decimal & 0x000000ff)
            dut.ram_0.dp_ram_0.mem[idx+1].value = (inst_decimal & 0x0000ff00) >> 8
            dut.ram_0.dp_ram_0.mem[idx+2].value = (inst_decimal & 0x00ff0000) >> 16
            dut.ram_0.dp_ram_0.mem[idx+3].value = (inst_decimal & 0xff000000) >> 24
            idx = idx + 4

    dut.i_rst_n.value = 0

    # Create a 10ns period clock on port clk
    clock = Clock(dut.i_clk, 10, units="ns")  
    # Start the clock. Start it low to avoid issues on the first RisingEdge
    cocotb.start_soon(clock.start(start_high=False))

    await Timer(1, units="ns")
    dut.i_rst_n.value = 1

    for _ in range(1000):
        
        await RisingEdge(dut.i_clk)

    assert dut.core_0.core_ID.rf.rf_data[3].value == 0xffffffff, "RVTEST_FAIL"

@cocotb.test()
async def rvtest_sll(dut):

    # memory initialization
    imem_path = "../../software/asm_tests/sll.hex"
    # dmem_path = "/home/pjy-wsl/rv32i/dmem.mem"
    with open(imem_path, "r") as mem:
        first_line = mem.readline()
        idx  = 0
        for line in mem:
            inst = line.strip()  # Remove leading/trailing whitespaces and newline characters
            inst_decimal = int(inst, 16)
            dut.ram_0.dp_ram_0.mem[idx].value = (inst_decimal & 0x000000ff)
            dut.ram_0.dp_ram_0.mem[idx+1].value = (inst_decimal & 0x0000ff00) >> 8
            dut.ram_0.dp_ram_0.mem[idx+2].value = (inst_decimal & 0x00ff0000) >> 16
            dut.ram_0.dp_ram_0.mem[idx+3].value = (inst_decimal & 0xff000000) >> 24
            idx = idx + 4

    dut.i_rst_n.value = 0

    # Create a 10ns period clock on port clk
    clock = Clock(dut.i_clk, 10, units="ns")  
    # Start the clock. Start it low to avoid issues on the first RisingEdge
    cocotb.start_soon(clock.start(start_high=False))

    await Timer(1, units="ns")
    dut.i_rst_n.value = 1

    for _ in range(1000):
        
        await RisingEdge(dut.i_clk)

    assert dut.core_0.core_ID.rf.rf_data[3].value == 0xffffffff, "RVTEST_FAIL"

@cocotb.test()
async def rvtest_srl(dut):

    # memory initialization
    imem_path = "../../software/asm_tests/srl.hex"
    # dmem_path = "/home/pjy-wsl/rv32i/dmem.mem"
    with open(imem_path, "r") as mem:
        first_line = mem.readline()
        idx  = 0
        for line in mem:
            inst = line.strip()  # Remove leading/trailing whitespaces and newline characters
            inst_decimal = int(inst, 16)
            dut.ram_0.dp_ram_0.mem[idx].value = (inst_decimal & 0x000000ff)
            dut.ram_0.dp_ram_0.mem[idx+1].value = (inst_decimal & 0x0000ff00) >> 8
            dut.ram_0.dp_ram_0.mem[idx+2].value = (inst_decimal & 0x00ff0000) >> 16
            dut.ram_0.dp_ram_0.mem[idx+3].value = (inst_decimal & 0xff000000) >> 24
            idx = idx + 4

    dut.i_rst_n.value = 0

    # Create a 10ns period clock on port clk
    clock = Clock(dut.i_clk, 10, units="ns")  
    # Start the clock. Start it low to avoid issues on the first RisingEdge
    cocotb.start_soon(clock.start(start_high=False))

    await Timer(1, units="ns")
    dut.i_rst_n.value = 1

    for _ in range(1000):
        
        await RisingEdge(dut.i_clk)

    assert dut.core_0.core_ID.rf.rf_data[3].value == 0xffffffff, "RVTEST_FAIL"

@cocotb.test()
async def rvtest_slt(dut):

    # memory initialization
    imem_path = "../../software/asm_tests/slt.hex"
    # dmem_path = "/home/pjy-wsl/rv32i/dmem.mem"
    with open(imem_path, "r") as mem:
        first_line = mem.readline()
        idx  = 0
        for line in mem:
            inst = line.strip()  # Remove leading/trailing whitespaces and newline characters
            inst_decimal = int(inst, 16)
            dut.ram_0.dp_ram_0.mem[idx].value = (inst_decimal & 0x000000ff)
            dut.ram_0.dp_ram_0.mem[idx+1].value = (inst_decimal & 0x0000ff00) >> 8
            dut.ram_0.dp_ram_0.mem[idx+2].value = (inst_decimal & 0x00ff0000) >> 16
            dut.ram_0.dp_ram_0.mem[idx+3].value = (inst_decimal & 0xff000000) >> 24
            idx = idx + 4

    dut.i_rst_n.value = 0

    # Create a 10ns period clock on port clk
    clock = Clock(dut.i_clk, 10, units="ns")  
    # Start the clock. Start it low to avoid issues on the first RisingEdge
    cocotb.start_soon(clock.start(start_high=False))

    await Timer(1, units="ns")
    dut.i_rst_n.value = 1

    for _ in range(1000):
        
        await RisingEdge(dut.i_clk)

    assert dut.core_0.core_ID.rf.rf_data[3].value == 0xffffffff, "RVTEST_FAIL"

@cocotb.test()
async def rvtest_sltu(dut):

    # memory initialization
    imem_path = "../../software/asm_tests/sltu.hex"
    # dmem_path = "/home/pjy-wsl/rv32i/dmem.mem"
    with open(imem_path, "r") as mem:
        first_line = mem.readline()
        idx  = 0
        for line in mem:
            inst = line.strip()  # Remove leading/trailing whitespaces and newline characters
            inst_decimal = int(inst, 16)
            dut.ram_0.dp_ram_0.mem[idx].value = (inst_decimal & 0x000000ff)
            dut.ram_0.dp_ram_0.mem[idx+1].value = (inst_decimal & 0x0000ff00) >> 8
            dut.ram_0.dp_ram_0.mem[idx+2].value = (inst_decimal & 0x00ff0000) >> 16
            dut.ram_0.dp_ram_0.mem[idx+3].value = (inst_decimal & 0xff000000) >> 24
            idx = idx + 4

    dut.i_rst_n.value = 0

    # Create a 10ns period clock on port clk
    clock = Clock(dut.i_clk, 10, units="ns")  
    # Start the clock. Start it low to avoid issues on the first RisingEdge
    cocotb.start_soon(clock.start(start_high=False))

    await Timer(1, units="ns")
    dut.i_rst_n.value = 1

    for _ in range(1000):
        
        await RisingEdge(dut.i_clk)

    assert dut.core_0.core_ID.rf.rf_data[3].value == 0xffffffff, "RVTEST_FAIL"

@cocotb.test()
async def rvtest_addi(dut):

    # memory initialization
    imem_path = "../../software/asm_tests/addi.hex"
    # dmem_path = "/home/pjy-wsl/rv32i/dmem.mem"
    with open(imem_path, "r") as mem:
        first_line = mem.readline()
        idx  = 0
        for line in mem:
            inst = line.strip()  # Remove leading/trailing whitespaces and newline characters
            inst_decimal = int(inst, 16)
            dut.ram_0.dp_ram_0.mem[idx].value = (inst_decimal & 0x000000ff)
            dut.ram_0.dp_ram_0.mem[idx+1].value = (inst_decimal & 0x0000ff00) >> 8
            dut.ram_0.dp_ram_0.mem[idx+2].value = (inst_decimal & 0x00ff0000) >> 16
            dut.ram_0.dp_ram_0.mem[idx+3].value = (inst_decimal & 0xff000000) >> 24
            idx = idx + 4

    dut.i_rst_n.value = 0

    # Create a 10ns period clock on port clk
    clock = Clock(dut.i_clk, 10, units="ns")  
    # Start the clock. Start it low to avoid issues on the first RisingEdge
    cocotb.start_soon(clock.start(start_high=False))

    await Timer(1, units="ns")
    dut.i_rst_n.value = 1

    for _ in range(1000):
        
        await RisingEdge(dut.i_clk)

    assert dut.core_0.core_ID.rf.rf_data[3].value == 0xffffffff, "RVTEST_FAIL"

@cocotb.test()
async def rvtest_xori(dut):

    # memory initialization
    imem_path = "../../software/asm_tests/xori.hex"
    # dmem_path = "/home/pjy-wsl/rv32i/dmem.mem"
    with open(imem_path, "r") as mem:
        first_line = mem.readline()
        idx  = 0
        for line in mem:
            inst = line.strip()  # Remove leading/trailing whitespaces and newline characters
            inst_decimal = int(inst, 16)
            dut.ram_0.dp_ram_0.mem[idx].value = (inst_decimal & 0x000000ff)
            dut.ram_0.dp_ram_0.mem[idx+1].value = (inst_decimal & 0x0000ff00) >> 8
            dut.ram_0.dp_ram_0.mem[idx+2].value = (inst_decimal & 0x00ff0000) >> 16
            dut.ram_0.dp_ram_0.mem[idx+3].value = (inst_decimal & 0xff000000) >> 24
            idx = idx + 4

    dut.i_rst_n.value = 0

    # Create a 10ns period clock on port clk
    clock = Clock(dut.i_clk, 10, units="ns")  
    # Start the clock. Start it low to avoid issues on the first RisingEdge
    cocotb.start_soon(clock.start(start_high=False))

    await Timer(1, units="ns")
    dut.i_rst_n.value = 1

    for _ in range(1000):
        
        await RisingEdge(dut.i_clk)

    assert dut.core_0.core_ID.rf.rf_data[3].value == 0xffffffff, "RVTEST_FAIL"

@cocotb.test()
async def rvtest_ori(dut):

    # memory initialization
    imem_path = "../../software/asm_tests/ori.hex"
    # dmem_path = "/home/pjy-wsl/rv32i/dmem.mem"
    with open(imem_path, "r") as mem:
        first_line = mem.readline()
        idx  = 0
        for line in mem:
            inst = line.strip()  # Remove leading/trailing whitespaces and newline characters
            inst_decimal = int(inst, 16)
            dut.ram_0.dp_ram_0.mem[idx].value = (inst_decimal & 0x000000ff)
            dut.ram_0.dp_ram_0.mem[idx+1].value = (inst_decimal & 0x0000ff00) >> 8
            dut.ram_0.dp_ram_0.mem[idx+2].value = (inst_decimal & 0x00ff0000) >> 16
            dut.ram_0.dp_ram_0.mem[idx+3].value = (inst_decimal & 0xff000000) >> 24
            idx = idx + 4

    dut.i_rst_n.value = 0

    # Create a 10ns period clock on port clk
    clock = Clock(dut.i_clk, 10, units="ns")  
    # Start the clock. Start it low to avoid issues on the first RisingEdge
    cocotb.start_soon(clock.start(start_high=False))

    await Timer(1, units="ns")
    dut.i_rst_n.value = 1

    for _ in range(1000):
        
        await RisingEdge(dut.i_clk)

    assert dut.core_0.core_ID.rf.rf_data[3].value == 0xffffffff, "RVTEST_FAIL"

@cocotb.test()
async def rvtest_andi(dut):

    # memory initialization
    imem_path = "../../software/asm_tests/andi.hex"
    # dmem_path = "/home/pjy-wsl/rv32i/dmem.mem"
    with open(imem_path, "r") as mem:
        first_line = mem.readline()
        idx  = 0
        for line in mem:
            inst = line.strip()  # Remove leading/trailing whitespaces and newline characters
            inst_decimal = int(inst, 16)
            dut.ram_0.dp_ram_0.mem[idx].value = (inst_decimal & 0x000000ff)
            dut.ram_0.dp_ram_0.mem[idx+1].value = (inst_decimal & 0x0000ff00) >> 8
            dut.ram_0.dp_ram_0.mem[idx+2].value = (inst_decimal & 0x00ff0000) >> 16
            dut.ram_0.dp_ram_0.mem[idx+3].value = (inst_decimal & 0xff000000) >> 24
            idx = idx + 4

    dut.i_rst_n.value = 0

    # Create a 10ns period clock on port clk
    clock = Clock(dut.i_clk, 10, units="ns")  
    # Start the clock. Start it low to avoid issues on the first RisingEdge
    cocotb.start_soon(clock.start(start_high=False))

    await Timer(1, units="ns")
    dut.i_rst_n.value = 1

    for _ in range(1000):
        
        await RisingEdge(dut.i_clk)

    assert dut.core_0.core_ID.rf.rf_data[3].value == 0xffffffff, "RVTEST_FAIL"

@cocotb.test()
async def rvtest_slli(dut):

    # memory initialization
    imem_path = "../../software/asm_tests/slli.hex"
    # dmem_path = "/home/pjy-wsl/rv32i/dmem.mem"
    with open(imem_path, "r") as mem:
        first_line = mem.readline()
        idx  = 0
        for line in mem:
            inst = line.strip()  # Remove leading/trailing whitespaces and newline characters
            inst_decimal = int(inst, 16)
            dut.ram_0.dp_ram_0.mem[idx].value = (inst_decimal & 0x000000ff)
            dut.ram_0.dp_ram_0.mem[idx+1].value = (inst_decimal & 0x0000ff00) >> 8
            dut.ram_0.dp_ram_0.mem[idx+2].value = (inst_decimal & 0x00ff0000) >> 16
            dut.ram_0.dp_ram_0.mem[idx+3].value = (inst_decimal & 0xff000000) >> 24
            idx = idx + 4

    dut.i_rst_n.value = 0

    # Create a 10ns period clock on port clk
    clock = Clock(dut.i_clk, 10, units="ns")  
    # Start the clock. Start it low to avoid issues on the first RisingEdge
    cocotb.start_soon(clock.start(start_high=False))

    await Timer(1, units="ns")
    dut.i_rst_n.value = 1

    for _ in range(1000):
        
        await RisingEdge(dut.i_clk)

    assert dut.core_0.core_ID.rf.rf_data[3].value == 0xffffffff, "RVTEST_FAIL"

@cocotb.test()
async def rvtest_srli(dut):

    # memory initialization
    imem_path = "../../software/asm_tests/srli.hex"
    # dmem_path = "/home/pjy-wsl/rv32i/dmem.mem"
    with open(imem_path, "r") as mem:
        first_line = mem.readline()
        idx  = 0
        for line in mem:
            inst = line.strip()  # Remove leading/trailing whitespaces and newline characters
            inst_decimal = int(inst, 16)
            dut.ram_0.dp_ram_0.mem[idx].value = (inst_decimal & 0x000000ff)
            dut.ram_0.dp_ram_0.mem[idx+1].value = (inst_decimal & 0x0000ff00) >> 8
            dut.ram_0.dp_ram_0.mem[idx+2].value = (inst_decimal & 0x00ff0000) >> 16
            dut.ram_0.dp_ram_0.mem[idx+3].value = (inst_decimal & 0xff000000) >> 24
            idx = idx + 4

    dut.i_rst_n.value = 0

    # Create a 10ns period clock on port clk
    clock = Clock(dut.i_clk, 10, units="ns")  
    # Start the clock. Start it low to avoid issues on the first RisingEdge
    cocotb.start_soon(clock.start(start_high=False))

    await Timer(1, units="ns")
    dut.i_rst_n.value = 1

    for _ in range(1000):
        
        await RisingEdge(dut.i_clk)

    assert dut.core_0.core_ID.rf.rf_data[3].value == 0xffffffff, "RVTEST_FAIL"

@cocotb.test()
async def rvtest_srai(dut):

    # memory initialization
    imem_path = "../../software/asm_tests/srai.hex"
    # dmem_path = "/home/pjy-wsl/rv32i/dmem.mem"
    with open(imem_path, "r") as mem:
        first_line = mem.readline()
        idx  = 0
        for line in mem:
            inst = line.strip()  # Remove leading/trailing whitespaces and newline characters
            inst_decimal = int(inst, 16)
            dut.ram_0.dp_ram_0.mem[idx].value = (inst_decimal & 0x000000ff)
            dut.ram_0.dp_ram_0.mem[idx+1].value = (inst_decimal & 0x0000ff00) >> 8
            dut.ram_0.dp_ram_0.mem[idx+2].value = (inst_decimal & 0x00ff0000) >> 16
            dut.ram_0.dp_ram_0.mem[idx+3].value = (inst_decimal & 0xff000000) >> 24
            idx = idx + 4

    dut.i_rst_n.value = 0

    # Create a 10ns period clock on port clk
    clock = Clock(dut.i_clk, 10, units="ns")  
    # Start the clock. Start it low to avoid issues on the first RisingEdge
    cocotb.start_soon(clock.start(start_high=False))

    await Timer(1, units="ns")
    dut.i_rst_n.value = 1

    for _ in range(1000):
        
        await RisingEdge(dut.i_clk)

    assert dut.core_0.core_ID.rf.rf_data[3].value == 0xffffffff, "RVTEST_FAIL"

@cocotb.test()
async def rvtest_slti(dut):

    # memory initialization
    imem_path = "../../software/asm_tests/slti.hex"
    # dmem_path = "/home/pjy-wsl/rv32i/dmem.mem"
    with open(imem_path, "r") as mem:
        first_line = mem.readline()
        idx  = 0
        for line in mem:
            inst = line.strip()  # Remove leading/trailing whitespaces and newline characters
            inst_decimal = int(inst, 16)
            dut.ram_0.dp_ram_0.mem[idx].value = (inst_decimal & 0x000000ff)
            dut.ram_0.dp_ram_0.mem[idx+1].value = (inst_decimal & 0x0000ff00) >> 8
            dut.ram_0.dp_ram_0.mem[idx+2].value = (inst_decimal & 0x00ff0000) >> 16
            dut.ram_0.dp_ram_0.mem[idx+3].value = (inst_decimal & 0xff000000) >> 24
            idx = idx + 4

    dut.i_rst_n.value = 0

    # Create a 10ns period clock on port clk
    clock = Clock(dut.i_clk, 10, units="ns")  
    # Start the clock. Start it low to avoid issues on the first RisingEdge
    cocotb.start_soon(clock.start(start_high=False))

    await Timer(1, units="ns")
    dut.i_rst_n.value = 1

    for _ in range(1000):
        
        await RisingEdge(dut.i_clk)

    assert dut.core_0.core_ID.rf.rf_data[3].value == 0xffffffff, "RVTEST_FAIL"

@cocotb.test()
async def rvtest_sltiu(dut):

    # memory initialization
    imem_path = "../../software/asm_tests/sltiu.hex"
    # dmem_path = "/home/pjy-wsl/rv32i/dmem.mem"
    with open(imem_path, "r") as mem:
        first_line = mem.readline()
        idx  = 0
        for line in mem:
            inst = line.strip()  # Remove leading/trailing whitespaces and newline characters
            inst_decimal = int(inst, 16)
            dut.ram_0.dp_ram_0.mem[idx].value = (inst_decimal & 0x000000ff)
            dut.ram_0.dp_ram_0.mem[idx+1].value = (inst_decimal & 0x0000ff00) >> 8
            dut.ram_0.dp_ram_0.mem[idx+2].value = (inst_decimal & 0x00ff0000) >> 16
            dut.ram_0.dp_ram_0.mem[idx+3].value = (inst_decimal & 0xff000000) >> 24
            idx = idx + 4

    dut.i_rst_n.value = 0

    # Create a 10ns period clock on port clk
    clock = Clock(dut.i_clk, 10, units="ns")  
    # Start the clock. Start it low to avoid issues on the first RisingEdge
    cocotb.start_soon(clock.start(start_high=False))

    await Timer(1, units="ns")
    dut.i_rst_n.value = 1

    for _ in range(1000):
        
        await RisingEdge(dut.i_clk)

    assert dut.core_0.core_ID.rf.rf_data[3].value == 0xffffffff, "RVTEST_FAIL"

@cocotb.test()
async def rvtest_lb(dut):

    # memory initialization
    imem_path = "../../software/asm_tests/lb.hex"
    # dmem_path = "/home/pjy-wsl/rv32i/dmem.mem"
    with open(imem_path, "r") as mem:
        first_line = mem.readline()
        idx  = 0
        for line in mem:
            inst = line.strip()  # Remove leading/trailing whitespaces and newline characters
            inst_decimal = int(inst, 16)
            dut.ram_0.dp_ram_0.mem[idx].value = (inst_decimal & 0x000000ff)
            dut.ram_0.dp_ram_0.mem[idx+1].value = (inst_decimal & 0x0000ff00) >> 8
            dut.ram_0.dp_ram_0.mem[idx+2].value = (inst_decimal & 0x00ff0000) >> 16
            dut.ram_0.dp_ram_0.mem[idx+3].value = (inst_decimal & 0xff000000) >> 24
            idx = idx + 4

    dut.i_rst_n.value = 0

    # Create a 10ns period clock on port clk
    clock = Clock(dut.i_clk, 10, units="ns")  
    # Start the clock. Start it low to avoid issues on the first RisingEdge
    cocotb.start_soon(clock.start(start_high=False))

    await Timer(1, units="ns")
    dut.i_rst_n.value = 1

    for _ in range(1000):
        
        await RisingEdge(dut.i_clk)

    assert dut.core_0.core_ID.rf.rf_data[3].value == 0xffffffff, "RVTEST_FAIL"

@cocotb.test()
async def rvtest_lh(dut):

    # memory initialization
    imem_path = "../../software/asm_tests/lh.hex"
    # dmem_path = "/home/pjy-wsl/rv32i/dmem.mem"
    with open(imem_path, "r") as mem:
        first_line = mem.readline()
        idx  = 0
        for line in mem:
            inst = line.strip()  # Remove leading/trailing whitespaces and newline characters
            inst_decimal = int(inst, 16)
            dut.ram_0.dp_ram_0.mem[idx].value = (inst_decimal & 0x000000ff)
            dut.ram_0.dp_ram_0.mem[idx+1].value = (inst_decimal & 0x0000ff00) >> 8
            dut.ram_0.dp_ram_0.mem[idx+2].value = (inst_decimal & 0x00ff0000) >> 16
            dut.ram_0.dp_ram_0.mem[idx+3].value = (inst_decimal & 0xff000000) >> 24
            idx = idx + 4

    dut.i_rst_n.value = 0

    # Create a 10ns period clock on port clk
    clock = Clock(dut.i_clk, 10, units="ns")  
    # Start the clock. Start it low to avoid issues on the first RisingEdge
    cocotb.start_soon(clock.start(start_high=False))

    await Timer(1, units="ns")
    dut.i_rst_n.value = 1

    for _ in range(1000):
        
        await RisingEdge(dut.i_clk)

    assert dut.core_0.core_ID.rf.rf_data[3].value == 0xffffffff, "RVTEST_FAIL"

@cocotb.test()
async def rvtest_lw(dut):

    # memory initialization
    imem_path = "../../software/asm_tests/lw.hex"
    # dmem_path = "/home/pjy-wsl/rv32i/dmem.mem"
    with open(imem_path, "r") as mem:
        first_line = mem.readline()
        idx  = 0
        for line in mem:
            inst = line.strip()  # Remove leading/trailing whitespaces and newline characters
            inst_decimal = int(inst, 16)
            dut.ram_0.dp_ram_0.mem[idx].value = (inst_decimal & 0x000000ff)
            dut.ram_0.dp_ram_0.mem[idx+1].value = (inst_decimal & 0x0000ff00) >> 8
            dut.ram_0.dp_ram_0.mem[idx+2].value = (inst_decimal & 0x00ff0000) >> 16
            dut.ram_0.dp_ram_0.mem[idx+3].value = (inst_decimal & 0xff000000) >> 24
            idx = idx + 4

    dut.i_rst_n.value = 0

    # Create a 10ns period clock on port clk
    clock = Clock(dut.i_clk, 10, units="ns")  
    # Start the clock. Start it low to avoid issues on the first RisingEdge
    cocotb.start_soon(clock.start(start_high=False))

    await Timer(1, units="ns")
    dut.i_rst_n.value = 1

    for _ in range(1000):
        
        await RisingEdge(dut.i_clk)

    assert dut.core_0.core_ID.rf.rf_data[3].value == 0xffffffff, "RVTEST_FAIL"

@cocotb.test()
async def rvtest_lbu(dut):

    # memory initialization
    imem_path = "../../software/asm_tests/lbu.hex"
    # dmem_path = "/home/pjy-wsl/rv32i/dmem.mem"
    with open(imem_path, "r") as mem:
        first_line = mem.readline()
        idx  = 0
        for line in mem:
            inst = line.strip()  # Remove leading/trailing whitespaces and newline characters
            inst_decimal = int(inst, 16)
            dut.ram_0.dp_ram_0.mem[idx].value = (inst_decimal & 0x000000ff)
            dut.ram_0.dp_ram_0.mem[idx+1].value = (inst_decimal & 0x0000ff00) >> 8
            dut.ram_0.dp_ram_0.mem[idx+2].value = (inst_decimal & 0x00ff0000) >> 16
            dut.ram_0.dp_ram_0.mem[idx+3].value = (inst_decimal & 0xff000000) >> 24
            idx = idx + 4

    dut.i_rst_n.value = 0

    # Create a 10ns period clock on port clk
    clock = Clock(dut.i_clk, 10, units="ns")  
    # Start the clock. Start it low to avoid issues on the first RisingEdge
    cocotb.start_soon(clock.start(start_high=False))

    await Timer(1, units="ns")
    dut.i_rst_n.value = 1

    for _ in range(1000):
        
        await RisingEdge(dut.i_clk)

    assert dut.core_0.core_ID.rf.rf_data[3].value == 0xffffffff, "RVTEST_FAIL"

@cocotb.test()
async def rvtest_lhu(dut):

    # memory initialization
    imem_path = "../../software/asm_tests/lhu.hex"
    # dmem_path = "/home/pjy-wsl/rv32i/dmem.mem"
    with open(imem_path, "r") as mem:
        first_line = mem.readline()
        idx  = 0
        for line in mem:
            inst = line.strip()  # Remove leading/trailing whitespaces and newline characters
            inst_decimal = int(inst, 16)
            dut.ram_0.dp_ram_0.mem[idx].value = (inst_decimal & 0x000000ff)
            dut.ram_0.dp_ram_0.mem[idx+1].value = (inst_decimal & 0x0000ff00) >> 8
            dut.ram_0.dp_ram_0.mem[idx+2].value = (inst_decimal & 0x00ff0000) >> 16
            dut.ram_0.dp_ram_0.mem[idx+3].value = (inst_decimal & 0xff000000) >> 24
            idx = idx + 4

    dut.i_rst_n.value = 0

    # Create a 10ns period clock on port clk
    clock = Clock(dut.i_clk, 10, units="ns")  
    # Start the clock. Start it low to avoid issues on the first RisingEdge
    cocotb.start_soon(clock.start(start_high=False))

    await Timer(1, units="ns")
    dut.i_rst_n.value = 1

    for _ in range(1000):
        
        await RisingEdge(dut.i_clk)

    assert dut.core_0.core_ID.rf.rf_data[3].value == 0xffffffff, "RVTEST_FAIL"

@cocotb.test()
async def rvtest_sb(dut):

    # memory initialization
    imem_path = "../../software/asm_tests/sb.hex"
    # dmem_path = "/home/pjy-wsl/rv32i/dmem.mem"
    with open(imem_path, "r") as mem:
        first_line = mem.readline()
        idx  = 0
        for line in mem:
            inst = line.strip()  # Remove leading/trailing whitespaces and newline characters
            inst_decimal = int(inst, 16)
            dut.ram_0.dp_ram_0.mem[idx].value = (inst_decimal & 0x000000ff)
            dut.ram_0.dp_ram_0.mem[idx+1].value = (inst_decimal & 0x0000ff00) >> 8
            dut.ram_0.dp_ram_0.mem[idx+2].value = (inst_decimal & 0x00ff0000) >> 16
            dut.ram_0.dp_ram_0.mem[idx+3].value = (inst_decimal & 0xff000000) >> 24
            idx = idx + 4

    dut.i_rst_n.value = 0

    # Create a 10ns period clock on port clk
    clock = Clock(dut.i_clk, 10, units="ns")  
    # Start the clock. Start it low to avoid issues on the first RisingEdge
    cocotb.start_soon(clock.start(start_high=False))

    await Timer(1, units="ns")
    dut.i_rst_n.value = 1

    for _ in range(1000):
        
        await RisingEdge(dut.i_clk)

    assert dut.core_0.core_ID.rf.rf_data[3].value == 0xffffffff, "RVTEST_FAIL"

@cocotb.test()
async def rvtest_sh(dut):

    # memory initialization
    imem_path = "../../software/asm_tests/sh.hex"
    # dmem_path = "/home/pjy-wsl/rv32i/dmem.mem"
    with open(imem_path, "r") as mem:
        first_line = mem.readline()
        idx  = 0
        for line in mem:
            inst = line.strip()  # Remove leading/trailing whitespaces and newline characters
            inst_decimal = int(inst, 16)
            dut.ram_0.dp_ram_0.mem[idx].value = (inst_decimal & 0x000000ff)
            dut.ram_0.dp_ram_0.mem[idx+1].value = (inst_decimal & 0x0000ff00) >> 8
            dut.ram_0.dp_ram_0.mem[idx+2].value = (inst_decimal & 0x00ff0000) >> 16
            dut.ram_0.dp_ram_0.mem[idx+3].value = (inst_decimal & 0xff000000) >> 24
            idx = idx + 4

    dut.i_rst_n.value = 0

    # Create a 10ns period clock on port clk
    clock = Clock(dut.i_clk, 10, units="ns")  
    # Start the clock. Start it low to avoid issues on the first RisingEdge
    cocotb.start_soon(clock.start(start_high=False))

    await Timer(1, units="ns")
    dut.i_rst_n.value = 1

    for _ in range(1000):
        
        await RisingEdge(dut.i_clk)

    assert dut.core_0.core_ID.rf.rf_data[3].value == 0xffffffff, "RVTEST_FAIL"

@cocotb.test()
async def rvtest_sw(dut):

    # memory initialization
    imem_path = "../../software/asm_tests/sw.hex"
    # dmem_path = "/home/pjy-wsl/rv32i/dmem.mem"
    with open(imem_path, "r") as mem:
        first_line = mem.readline()
        idx  = 0
        for line in mem:
            inst = line.strip()  # Remove leading/trailing whitespaces and newline characters
            inst_decimal = int(inst, 16)
            dut.ram_0.dp_ram_0.mem[idx].value = (inst_decimal & 0x000000ff)
            dut.ram_0.dp_ram_0.mem[idx+1].value = (inst_decimal & 0x0000ff00) >> 8
            dut.ram_0.dp_ram_0.mem[idx+2].value = (inst_decimal & 0x00ff0000) >> 16
            dut.ram_0.dp_ram_0.mem[idx+3].value = (inst_decimal & 0xff000000) >> 24
            idx = idx + 4

    dut.i_rst_n.value = 0

    # Create a 10ns period clock on port clk
    clock = Clock(dut.i_clk, 10, units="ns")  
    # Start the clock. Start it low to avoid issues on the first RisingEdge
    cocotb.start_soon(clock.start(start_high=False))

    await Timer(1, units="ns")
    dut.i_rst_n.value = 1

    for _ in range(1000):
        
        await RisingEdge(dut.i_clk)

    assert dut.core_0.core_ID.rf.rf_data[3].value == 0xffffffff, "RVTEST_FAIL"

@cocotb.test()
async def rvtest_beq(dut):

    # memory initialization
    imem_path = "../../software/asm_tests/beq.hex"
    # dmem_path = "/home/pjy-wsl/rv32i/dmem.mem"
    with open(imem_path, "r") as mem:
        first_line = mem.readline()
        idx  = 0
        for line in mem:
            inst = line.strip()  # Remove leading/trailing whitespaces and newline characters
            inst_decimal = int(inst, 16)
            dut.ram_0.dp_ram_0.mem[idx].value = (inst_decimal & 0x000000ff)
            dut.ram_0.dp_ram_0.mem[idx+1].value = (inst_decimal & 0x0000ff00) >> 8
            dut.ram_0.dp_ram_0.mem[idx+2].value = (inst_decimal & 0x00ff0000) >> 16
            dut.ram_0.dp_ram_0.mem[idx+3].value = (inst_decimal & 0xff000000) >> 24
            idx = idx + 4

    dut.i_rst_n.value = 0

    # Create a 10ns period clock on port clk
    clock = Clock(dut.i_clk, 10, units="ns")  
    # Start the clock. Start it low to avoid issues on the first RisingEdge
    cocotb.start_soon(clock.start(start_high=False))

    await Timer(1, units="ns")
    dut.i_rst_n.value = 1

    for _ in range(1000):
        
        await RisingEdge(dut.i_clk)

    assert dut.core_0.core_ID.rf.rf_data[3].value == 0xffffffff, "RVTEST_FAIL"

@cocotb.test()
async def rvtest_bne(dut):

    # memory initialization
    imem_path = "../../software/asm_tests/bne.hex"
    # dmem_path = "/home/pjy-wsl/rv32i/dmem.mem"
    with open(imem_path, "r") as mem:
        first_line = mem.readline()
        idx  = 0
        for line in mem:
            inst = line.strip()  # Remove leading/trailing whitespaces and newline characters
            inst_decimal = int(inst, 16)
            dut.ram_0.dp_ram_0.mem[idx].value = (inst_decimal & 0x000000ff)
            dut.ram_0.dp_ram_0.mem[idx+1].value = (inst_decimal & 0x0000ff00) >> 8
            dut.ram_0.dp_ram_0.mem[idx+2].value = (inst_decimal & 0x00ff0000) >> 16
            dut.ram_0.dp_ram_0.mem[idx+3].value = (inst_decimal & 0xff000000) >> 24
            idx = idx + 4

    dut.i_rst_n.value = 0

    # Create a 10ns period clock on port clk
    clock = Clock(dut.i_clk, 10, units="ns")  
    # Start the clock. Start it low to avoid issues on the first RisingEdge
    cocotb.start_soon(clock.start(start_high=False))

    await Timer(1, units="ns")
    dut.i_rst_n.value = 1

    for _ in range(1000):
        
        await RisingEdge(dut.i_clk)

    assert dut.core_0.core_ID.rf.rf_data[3].value == 0xffffffff, "RVTEST_FAIL"

@cocotb.test()
async def rvtest_blt(dut):

    # memory initialization
    imem_path = "../../software/asm_tests/blt.hex"
    # dmem_path = "/home/pjy-wsl/rv32i/dmem.mem"
    with open(imem_path, "r") as mem:
        first_line = mem.readline()
        idx  = 0
        for line in mem:
            inst = line.strip()  # Remove leading/trailing whitespaces and newline characters
            inst_decimal = int(inst, 16)
            dut.ram_0.dp_ram_0.mem[idx].value = (inst_decimal & 0x000000ff)
            dut.ram_0.dp_ram_0.mem[idx+1].value = (inst_decimal & 0x0000ff00) >> 8
            dut.ram_0.dp_ram_0.mem[idx+2].value = (inst_decimal & 0x00ff0000) >> 16
            dut.ram_0.dp_ram_0.mem[idx+3].value = (inst_decimal & 0xff000000) >> 24
            idx = idx + 4

    dut.i_rst_n.value = 0

    # Create a 10ns period clock on port clk
    clock = Clock(dut.i_clk, 10, units="ns")  
    # Start the clock. Start it low to avoid issues on the first RisingEdge
    cocotb.start_soon(clock.start(start_high=False))

    await Timer(1, units="ns")
    dut.i_rst_n.value = 1

    for _ in range(1000):
        
        await RisingEdge(dut.i_clk)

    assert dut.core_0.core_ID.rf.rf_data[3].value == 0xffffffff, "RVTEST_FAIL"

@cocotb.test()
async def rvtest_bge(dut):

    # memory initialization
    imem_path = "../../software/asm_tests/bge.hex"
    # dmem_path = "/home/pjy-wsl/rv32i/dmem.mem"
    with open(imem_path, "r") as mem:
        first_line = mem.readline()
        idx  = 0
        for line in mem:
            inst = line.strip()  # Remove leading/trailing whitespaces and newline characters
            inst_decimal = int(inst, 16)
            dut.ram_0.dp_ram_0.mem[idx].value = (inst_decimal & 0x000000ff)
            dut.ram_0.dp_ram_0.mem[idx+1].value = (inst_decimal & 0x0000ff00) >> 8
            dut.ram_0.dp_ram_0.mem[idx+2].value = (inst_decimal & 0x00ff0000) >> 16
            dut.ram_0.dp_ram_0.mem[idx+3].value = (inst_decimal & 0xff000000) >> 24
            idx = idx + 4

    dut.i_rst_n.value = 0

    # Create a 10ns period clock on port clk
    clock = Clock(dut.i_clk, 10, units="ns")  
    # Start the clock. Start it low to avoid issues on the first RisingEdge
    cocotb.start_soon(clock.start(start_high=False))

    await Timer(1, units="ns")
    dut.i_rst_n.value = 1

    for _ in range(1000):
        
        await RisingEdge(dut.i_clk)

    assert dut.core_0.core_ID.rf.rf_data[3].value == 0xffffffff, "RVTEST_FAIL"

@cocotb.test()
async def rvtest_bltu(dut):

    # memory initialization
    imem_path = "../../software/asm_tests/bltu.hex"
    # dmem_path = "/home/pjy-wsl/rv32i/dmem.mem"
    with open(imem_path, "r") as mem:
        first_line = mem.readline()
        idx  = 0
        for line in mem:
            inst = line.strip()  # Remove leading/trailing whitespaces and newline characters
            inst_decimal = int(inst, 16)
            dut.ram_0.dp_ram_0.mem[idx].value = (inst_decimal & 0x000000ff)
            dut.ram_0.dp_ram_0.mem[idx+1].value = (inst_decimal & 0x0000ff00) >> 8
            dut.ram_0.dp_ram_0.mem[idx+2].value = (inst_decimal & 0x00ff0000) >> 16
            dut.ram_0.dp_ram_0.mem[idx+3].value = (inst_decimal & 0xff000000) >> 24
            idx = idx + 4

    dut.i_rst_n.value = 0

    # Create a 10ns period clock on port clk
    clock = Clock(dut.i_clk, 10, units="ns")  
    # Start the clock. Start it low to avoid issues on the first RisingEdge
    cocotb.start_soon(clock.start(start_high=False))

    await Timer(1, units="ns")
    dut.i_rst_n.value = 1

    for _ in range(1000):
        
        await RisingEdge(dut.i_clk)

    assert dut.core_0.core_ID.rf.rf_data[3].value == 0xffffffff, "RVTEST_FAIL"

@cocotb.test()
async def rvtest_bgeu(dut):

    # memory initialization
    imem_path = "../../software/asm_tests/bgeu.hex"
    # dmem_path = "/home/pjy-wsl/rv32i/dmem.mem"
    with open(imem_path, "r") as mem:
        first_line = mem.readline()
        idx  = 0
        for line in mem:
            inst = line.strip()  # Remove leading/trailing whitespaces and newline characters
            inst_decimal = int(inst, 16)
            dut.ram_0.dp_ram_0.mem[idx].value = (inst_decimal & 0x000000ff)
            dut.ram_0.dp_ram_0.mem[idx+1].value = (inst_decimal & 0x0000ff00) >> 8
            dut.ram_0.dp_ram_0.mem[idx+2].value = (inst_decimal & 0x00ff0000) >> 16
            dut.ram_0.dp_ram_0.mem[idx+3].value = (inst_decimal & 0xff000000) >> 24
            idx = idx + 4

    dut.i_rst_n.value = 0

    # Create a 10ns period clock on port clk
    clock = Clock(dut.i_clk, 10, units="ns")  
    # Start the clock. Start it low to avoid issues on the first RisingEdge
    cocotb.start_soon(clock.start(start_high=False))

    await Timer(1, units="ns")
    dut.i_rst_n.value = 1

    for _ in range(1000):
        
        await RisingEdge(dut.i_clk)

    assert dut.core_0.core_ID.rf.rf_data[3].value == 0xffffffff, "RVTEST_FAIL"

@cocotb.test()
async def rvtest_jal(dut):

    # memory initialization
    imem_path = "../../software/asm_tests/jal.hex"
    # dmem_path = "/home/pjy-wsl/rv32i/dmem.mem"
    with open(imem_path, "r") as mem:
        first_line = mem.readline()
        idx  = 0
        for line in mem:
            inst = line.strip()  # Remove leading/trailing whitespaces and newline characters
            inst_decimal = int(inst, 16)
            dut.ram_0.dp_ram_0.mem[idx].value = (inst_decimal & 0x000000ff)
            dut.ram_0.dp_ram_0.mem[idx+1].value = (inst_decimal & 0x0000ff00) >> 8
            dut.ram_0.dp_ram_0.mem[idx+2].value = (inst_decimal & 0x00ff0000) >> 16
            dut.ram_0.dp_ram_0.mem[idx+3].value = (inst_decimal & 0xff000000) >> 24
            idx = idx + 4

    dut.i_rst_n.value = 0

    # Create a 10ns period clock on port clk
    clock = Clock(dut.i_clk, 10, units="ns")  
    # Start the clock. Start it low to avoid issues on the first RisingEdge
    cocotb.start_soon(clock.start(start_high=False))

    await Timer(1, units="ns")
    dut.i_rst_n.value = 1

    for _ in range(1000):
        
        await RisingEdge(dut.i_clk)

    assert dut.core_0.core_ID.rf.rf_data[3].value == 0xffffffff, "RVTEST_FAIL"

@cocotb.test()
async def rvtest_jalr(dut):

    # memory initialization
    imem_path = "../../software/asm_tests/jalr.hex"
    # dmem_path = "/home/pjy-wsl/rv32i/dmem.mem"
    with open(imem_path, "r") as mem:
        first_line = mem.readline()
        idx  = 0
        for line in mem:
            inst = line.strip()  # Remove leading/trailing whitespaces and newline characters
            inst_decimal = int(inst, 16)
            dut.ram_0.dp_ram_0.mem[idx].value = (inst_decimal & 0x000000ff)
            dut.ram_0.dp_ram_0.mem[idx+1].value = (inst_decimal & 0x0000ff00) >> 8
            dut.ram_0.dp_ram_0.mem[idx+2].value = (inst_decimal & 0x00ff0000) >> 16
            dut.ram_0.dp_ram_0.mem[idx+3].value = (inst_decimal & 0xff000000) >> 24
            idx = idx + 4

    dut.i_rst_n.value = 0

    # Create a 10ns period clock on port clk
    clock = Clock(dut.i_clk, 10, units="ns")  
    # Start the clock. Start it low to avoid issues on the first RisingEdge
    cocotb.start_soon(clock.start(start_high=False))

    await Timer(1, units="ns")
    dut.i_rst_n.value = 1

    for _ in range(1000):
        
        await RisingEdge(dut.i_clk)

    assert dut.core_0.core_ID.rf.rf_data[3].value == 0xffffffff, "RVTEST_FAIL"

@cocotb.test()
async def rvtest_lui(dut):

    # memory initialization
    imem_path = "../../software/asm_tests/lui.hex"
    # dmem_path = "/home/pjy-wsl/rv32i/dmem.mem"
    with open(imem_path, "r") as mem:
        first_line = mem.readline()
        idx  = 0
        for line in mem:
            inst = line.strip()  # Remove leading/trailing whitespaces and newline characters
            inst_decimal = int(inst, 16)
            dut.ram_0.dp_ram_0.mem[idx].value = (inst_decimal & 0x000000ff)
            dut.ram_0.dp_ram_0.mem[idx+1].value = (inst_decimal & 0x0000ff00) >> 8
            dut.ram_0.dp_ram_0.mem[idx+2].value = (inst_decimal & 0x00ff0000) >> 16
            dut.ram_0.dp_ram_0.mem[idx+3].value = (inst_decimal & 0xff000000) >> 24
            idx = idx + 4

    dut.i_rst_n.value = 0

    # Create a 10ns period clock on port clk
    clock = Clock(dut.i_clk, 10, units="ns")  
    # Start the clock. Start it low to avoid issues on the first RisingEdge
    cocotb.start_soon(clock.start(start_high=False))

    await Timer(1, units="ns")
    dut.i_rst_n.value = 1

    for _ in range(1000):
        
        await RisingEdge(dut.i_clk)

    assert dut.core_0.core_ID.rf.rf_data[3].value == 0xffffffff, "RVTEST_FAIL"

@cocotb.test()
async def rvtest_auipc(dut):

    # memory initialization
    imem_path = "../../software/asm_tests/auipc.hex"
    # dmem_path = "/home/pjy-wsl/rv32i/dmem.mem"
    with open(imem_path, "r") as mem:
        first_line = mem.readline()
        idx  = 0
        for line in mem:
            inst = line.strip()  # Remove leading/trailing whitespaces and newline characters
            inst_decimal = int(inst, 16)
            dut.ram_0.dp_ram_0.mem[idx].value = (inst_decimal & 0x000000ff)
            dut.ram_0.dp_ram_0.mem[idx+1].value = (inst_decimal & 0x0000ff00) >> 8
            dut.ram_0.dp_ram_0.mem[idx+2].value = (inst_decimal & 0x00ff0000) >> 16
            dut.ram_0.dp_ram_0.mem[idx+3].value = (inst_decimal & 0xff000000) >> 24
            idx = idx + 4

    dut.i_rst_n.value = 0

    # Create a 10ns period clock on port clk
    clock = Clock(dut.i_clk, 10, units="ns")  
    # Start the clock. Start it low to avoid issues on the first RisingEdge
    cocotb.start_soon(clock.start(start_high=False))

    await Timer(1, units="ns")
    dut.i_rst_n.value = 1

    for _ in range(1000):
        
        await RisingEdge(dut.i_clk)

    assert dut.core_0.core_ID.rf.rf_data[3].value == 0xffffffff, "RVTEST_FAIL"

@cocotb.test()
async def rvtest_mul(dut):

    # memory initialization
    imem_path = "../../software/asm_tests/mul.hex"
    # dmem_path = "/home/pjy-wsl/rv32i/dmem.mem"
    with open(imem_path, "r") as mem:
        first_line = mem.readline()
        idx  = 0
        for line in mem:
            inst = line.strip()  # Remove leading/trailing whitespaces and newline characters
            inst_decimal = int(inst, 16)
            dut.ram_0.dp_ram_0.mem[idx].value = (inst_decimal & 0x000000ff)
            dut.ram_0.dp_ram_0.mem[idx+1].value = (inst_decimal & 0x0000ff00) >> 8
            dut.ram_0.dp_ram_0.mem[idx+2].value = (inst_decimal & 0x00ff0000) >> 16
            dut.ram_0.dp_ram_0.mem[idx+3].value = (inst_decimal & 0xff000000) >> 24
            idx = idx + 4

    dut.i_rst_n.value = 0

    # Create a 10ns period clock on port clk
    clock = Clock(dut.i_clk, 10, units="ns")  
    # Start the clock. Start it low to avoid issues on the first RisingEdge
    cocotb.start_soon(clock.start(start_high=False))

    await Timer(1, units="ns")
    dut.i_rst_n.value = 1

    for _ in range(1000):
        
        await RisingEdge(dut.i_clk)

    assert dut.core_0.core_ID.rf.rf_data[3].value == 0xffffffff, "RVTEST_FAIL"

@cocotb.test()
async def rvtest_mulh(dut):

    # memory initialization
    imem_path = "../../software/asm_tests/mulh.hex"
    # dmem_path = "/home/pjy-wsl/rv32i/dmem.mem"
    with open(imem_path, "r") as mem:
        first_line = mem.readline()
        idx  = 0
        for line in mem:
            inst = line.strip()  # Remove leading/trailing whitespaces and newline characters
            inst_decimal = int(inst, 16)
            dut.ram_0.dp_ram_0.mem[idx].value = (inst_decimal & 0x000000ff)
            dut.ram_0.dp_ram_0.mem[idx+1].value = (inst_decimal & 0x0000ff00) >> 8
            dut.ram_0.dp_ram_0.mem[idx+2].value = (inst_decimal & 0x00ff0000) >> 16
            dut.ram_0.dp_ram_0.mem[idx+3].value = (inst_decimal & 0xff000000) >> 24
            idx = idx + 4

    dut.i_rst_n.value = 0

    # Create a 10ns period clock on port clk
    clock = Clock(dut.i_clk, 10, units="ns")  
    # Start the clock. Start it low to avoid issues on the first RisingEdge
    cocotb.start_soon(clock.start(start_high=False))

    await Timer(1, units="ns")
    dut.i_rst_n.value = 1

    for _ in range(1000):
        
        await RisingEdge(dut.i_clk)

    assert dut.core_0.core_ID.rf.rf_data[3].value == 0xffffffff, "RVTEST_FAIL"

@cocotb.test()
async def rvtest_mulhsu(dut):

    # memory initialization
    imem_path = "../../software/asm_tests/mulhsu.hex"
    # dmem_path = "/home/pjy-wsl/rv32i/dmem.mem"
    with open(imem_path, "r") as mem:
        first_line = mem.readline()
        idx  = 0
        for line in mem:
            inst = line.strip()  # Remove leading/trailing whitespaces and newline characters
            inst_decimal = int(inst, 16)
            dut.ram_0.dp_ram_0.mem[idx].value = (inst_decimal & 0x000000ff)
            dut.ram_0.dp_ram_0.mem[idx+1].value = (inst_decimal & 0x0000ff00) >> 8
            dut.ram_0.dp_ram_0.mem[idx+2].value = (inst_decimal & 0x00ff0000) >> 16
            dut.ram_0.dp_ram_0.mem[idx+3].value = (inst_decimal & 0xff000000) >> 24
            idx = idx + 4

    dut.i_rst_n.value = 0

    # Create a 10ns period clock on port clk
    clock = Clock(dut.i_clk, 10, units="ns")  
    # Start the clock. Start it low to avoid issues on the first RisingEdge
    cocotb.start_soon(clock.start(start_high=False))

    await Timer(1, units="ns")
    dut.i_rst_n.value = 1

    for _ in range(1000):
        
        await RisingEdge(dut.i_clk)

    assert dut.core_0.core_ID.rf.rf_data[3].value == 0xffffffff, "RVTEST_FAIL"

@cocotb.test()
async def rvtest_mulhu(dut):

    # memory initialization
    imem_path = "../../software/asm_tests/mulhu.hex"
    # dmem_path = "/home/pjy-wsl/rv32i/dmem.mem"
    with open(imem_path, "r") as mem:
        first_line = mem.readline()
        idx  = 0
        for line in mem:
            inst = line.strip()  # Remove leading/trailing whitespaces and newline characters
            inst_decimal = int(inst, 16)
            dut.ram_0.dp_ram_0.mem[idx].value = (inst_decimal & 0x000000ff)
            dut.ram_0.dp_ram_0.mem[idx+1].value = (inst_decimal & 0x0000ff00) >> 8
            dut.ram_0.dp_ram_0.mem[idx+2].value = (inst_decimal & 0x00ff0000) >> 16
            dut.ram_0.dp_ram_0.mem[idx+3].value = (inst_decimal & 0xff000000) >> 24
            idx = idx + 4

    dut.i_rst_n.value = 0

    # Create a 10ns period clock on port clk
    clock = Clock(dut.i_clk, 10, units="ns")  
    # Start the clock. Start it low to avoid issues on the first RisingEdge
    cocotb.start_soon(clock.start(start_high=False))

    await Timer(1, units="ns")
    dut.i_rst_n.value = 1

    for _ in range(1000):
        
        await RisingEdge(dut.i_clk)

    assert dut.core_0.core_ID.rf.rf_data[3].value == 0xffffffff, "RVTEST_FAIL"

@cocotb.test()
async def rvtest_div(dut):

    # memory initialization
    imem_path = "../../software/asm_tests/div.hex"
    # dmem_path = "/home/pjy-wsl/rv32i/dmem.mem"
    with open(imem_path, "r") as mem:
        first_line = mem.readline()
        idx  = 0
        for line in mem:
            inst = line.strip()  # Remove leading/trailing whitespaces and newline characters
            inst_decimal = int(inst, 16)
            dut.ram_0.dp_ram_0.mem[idx].value = (inst_decimal & 0x000000ff)
            dut.ram_0.dp_ram_0.mem[idx+1].value = (inst_decimal & 0x0000ff00) >> 8
            dut.ram_0.dp_ram_0.mem[idx+2].value = (inst_decimal & 0x00ff0000) >> 16
            dut.ram_0.dp_ram_0.mem[idx+3].value = (inst_decimal & 0xff000000) >> 24
            idx = idx + 4

    dut.i_rst_n.value = 0

    # Create a 10ns period clock on port clk
    clock = Clock(dut.i_clk, 10, units="ns")  
    # Start the clock. Start it low to avoid issues on the first RisingEdge
    cocotb.start_soon(clock.start(start_high=False))

    await Timer(1, units="ns")
    dut.i_rst_n.value = 1

    for _ in range(1000):
        
        await RisingEdge(dut.i_clk)

    assert dut.core_0.core_ID.rf.rf_data[3].value == 0xffffffff, "RVTEST_FAIL"

@cocotb.test()
async def rvtest_divu(dut):

    # memory initialization
    imem_path = "../../software/asm_tests/divu.hex"
    # dmem_path = "/home/pjy-wsl/rv32i/dmem.mem"
    with open(imem_path, "r") as mem:
        first_line = mem.readline()
        idx  = 0
        for line in mem:
            inst = line.strip()  # Remove leading/trailing whitespaces and newline characters
            inst_decimal = int(inst, 16)
            dut.ram_0.dp_ram_0.mem[idx].value = (inst_decimal & 0x000000ff)
            dut.ram_0.dp_ram_0.mem[idx+1].value = (inst_decimal & 0x0000ff00) >> 8
            dut.ram_0.dp_ram_0.mem[idx+2].value = (inst_decimal & 0x00ff0000) >> 16
            dut.ram_0.dp_ram_0.mem[idx+3].value = (inst_decimal & 0xff000000) >> 24
            idx = idx + 4

    dut.i_rst_n.value = 0

    # Create a 10ns period clock on port clk
    clock = Clock(dut.i_clk, 10, units="ns")  
    # Start the clock. Start it low to avoid issues on the first RisingEdge
    cocotb.start_soon(clock.start(start_high=False))

    await Timer(1, units="ns")
    dut.i_rst_n.value = 1

    for _ in range(1000):
        
        await RisingEdge(dut.i_clk)

    assert dut.core_0.core_ID.rf.rf_data[3].value == 0xffffffff, "RVTEST_FAIL"

@cocotb.test()
async def rvtest_rem(dut):

    # memory initialization
    imem_path = "../../software/asm_tests/rem.hex"
    # dmem_path = "/home/pjy-wsl/rv32i/dmem.mem"
    with open(imem_path, "r") as mem:
        first_line = mem.readline()
        idx  = 0
        for line in mem:
            inst = line.strip()  # Remove leading/trailing whitespaces and newline characters
            inst_decimal = int(inst, 16)
            dut.ram_0.dp_ram_0.mem[idx].value = (inst_decimal & 0x000000ff)
            dut.ram_0.dp_ram_0.mem[idx+1].value = (inst_decimal & 0x0000ff00) >> 8
            dut.ram_0.dp_ram_0.mem[idx+2].value = (inst_decimal & 0x00ff0000) >> 16
            dut.ram_0.dp_ram_0.mem[idx+3].value = (inst_decimal & 0xff000000) >> 24
            idx = idx + 4

    dut.i_rst_n.value = 0

    # Create a 10ns period clock on port clk
    clock = Clock(dut.i_clk, 10, units="ns")  
    # Start the clock. Start it low to avoid issues on the first RisingEdge
    cocotb.start_soon(clock.start(start_high=False))

    await Timer(1, units="ns")
    dut.i_rst_n.value = 1

    for _ in range(1000):
        
        await RisingEdge(dut.i_clk)

    assert dut.core_0.core_ID.rf.rf_data[3].value == 0xffffffff, "RVTEST_FAIL"

@cocotb.test()
async def rvtest_remu(dut):

    # memory initialization
    imem_path = "../../software/asm_tests/remu.hex"
    # dmem_path = "/home/pjy-wsl/rv32i/dmem.mem"
    with open(imem_path, "r") as mem:
        first_line = mem.readline()
        idx  = 0
        for line in mem:
            inst = line.strip()  # Remove leading/trailing whitespaces and newline characters
            inst_decimal = int(inst, 16)
            dut.ram_0.dp_ram_0.mem[idx].value = (inst_decimal & 0x000000ff)
            dut.ram_0.dp_ram_0.mem[idx+1].value = (inst_decimal & 0x0000ff00) >> 8
            dut.ram_0.dp_ram_0.mem[idx+2].value = (inst_decimal & 0x00ff0000) >> 16
            dut.ram_0.dp_ram_0.mem[idx+3].value = (inst_decimal & 0xff000000) >> 24
            idx = idx + 4

    dut.i_rst_n.value = 0

    # Create a 10ns period clock on port clk
    clock = Clock(dut.i_clk, 10, units="ns")  
    # Start the clock. Start it low to avoid issues on the first RisingEdge
    cocotb.start_soon(clock.start(start_high=False))

    await Timer(1, units="ns")
    dut.i_rst_n.value = 1

    for _ in range(1000):
        
        await RisingEdge(dut.i_clk)

    assert dut.core_0.core_ID.rf.rf_data[3].value == 0xffffffff, "RVTEST_FAIL"