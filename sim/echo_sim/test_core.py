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
async def core_bench(dut):
    dmem_path = "/home/pjy-wsl/idslab-cores/riscv_core/software/echo/echo.hex"
    with open(dmem_path, "r") as dmem_mem:
        idx  = 0
        bank0_mask = 0x000000ff
        bank1_mask = 0x0000ff00
        bank2_mask = 0x00ff0000
        bank3_mask = 0xff000000
        for line in dmem_mem:
            data = line.strip()  # Remove leading/trailing whitespaces and newline characters
            data_decimal = int(data, 16)
            dut.top.ram_0.dp_ram_0.mem[idx].value = data_decimal & bank0_mask
            dut.top.ram_0.dp_ram_0.mem[idx+1].value = (data_decimal & bank1_mask) >> 8
            dut.top.ram_0.dp_ram_0.mem[idx+2].value = (data_decimal & bank2_mask) >> 16
            dut.top.ram_0.dp_ram_0.mem[idx+3].value = (data_decimal & bank3_mask) >> 24
            idx = idx + 4


    # reset all ports
    dut.i_rst_n.value = 0
    dut.data_in.value = random.randint(0, 2**8-1)
    dut.data_out_ready.value = 0

    # Create a 10ns period clock on port clk
    clock = Clock(dut.i_clk, 10, units="ns")  
    # Start the clock. Start it low to avoid issues on the first RisingEdge
    cocotb.start_soon(clock.start(start_high=False))

    await RisingEdge(dut.i_clk)
    dut.i_rst_n.value = 1

    for _ in range(5):
        await RisingEdge(dut.i_clk)

    done = 0
    send_done = 1
    recv_done = 0

    for clk in range(100000):
        while recv_done == 0:
            if dut.data_out_valid.value == 1:
                # last char
                if int(dut.data_out.value.binstr, 2) == 0x0d:
                    print("", end="")
                elif int(dut.data_out.value.binstr, 2) == 0x00:
                    recv_done = 1
                    send_done = 0
                else:
                    print(chr(int(dut.data_out.value.binstr, 2)), end="")
                dut.data_out_ready.value = 1
                await RisingEdge(dut.i_clk)
                await Timer(1, units="ns")
                dut.data_out_ready.value = 0
            else:
                await RisingEdge(dut.i_clk)

        read = input()
        read = read + '\r'
        i = 0
        while send_done == 0:
            if dut.data_in_ready.value == 1:
                dut.data_in.value = ord(read[i])
                if read[i] == '\r':
                    recv_done = 0
                    send_done = 1
                dut.data_in_valid.value = 1
                await RisingEdge(dut.i_clk)
                await Timer(1, units="ns")
                dut.data_in_valid.value = 0
                i = i + 1
            else:
                await RisingEdge(dut.i_clk)

        if done == 1:
            for _ in range(10):
                await RisingEdge(dut.i_clk)
            break

        await RisingEdge(dut.i_clk)