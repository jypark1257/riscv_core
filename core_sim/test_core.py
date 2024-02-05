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

    # memory initialization
    # imem_path = "/home/pjy-wsl/rv32i_mi/rtl/imem.hex"
    # # dmem_path = "/home/pjy-wsl/rv32i/dmem.mem"
    # with open(imem_path, "r") as imem_mem:
    #     idx  = 0
    #     for line in imem_mem:
    #         inst = line.strip()  # Remove leading/trailing whitespaces and newline characters
    #         inst_decimal = int(inst, 16)
    #         dut.u_mem.MEM[idx].value = inst_decimal
    #         idx = idx + 1
    # with open(dmem_path, "r") as dmem_mem:
    #     idx  = 0
    #     bank0_mask = 0x000000ff
    #     bank1_mask = 0x0000ff00
    #     bank2_mask = 0x00ff0000
    #     bank3_mask = 0xff000000
    #     for line in dmem_mem:
    #         data = line.strip()  # Remove leading/trailing whitespaces and newline characters
    #         data_decimal = int(data, 16)
    #         dut.dmem.bank0[idx].value = data_decimal & bank0_mask
    #         dut.dmem.bank1[idx].value = (data_decimal & bank1_mask) >> 8
    #         dut.dmem.bank2[idx].value = (data_decimal & bank2_mask) >> 16
    #         dut.dmem.bank3[idx].value = (data_decimal & bank3_mask) >> 24
    #         idx = idx + 1

    dut.i_rst_n.value = 0

    # Create a 10ns period clock on port clk
    clock = Clock(dut.i_clk, 10, units="ns")  
    # Start the clock. Start it low to avoid issues on the first RisingEdge
    cocotb.start_soon(clock.start(start_high=False))

    await Timer(1, units="ns")
    dut.i_rst_n.value = 1

    for _ in range(1000):
        
        await RisingEdge(dut.i_clk)
        
# @cocotb.test()
# async def test_forwarding(dut):
# 
#     # memory initialization
#     imem_path = "/home/pjy-wsl/rv32i/verif/core_sim/test_arithmetic/imem.mem"
#     dmem_path = "/home/pjy-wsl/rv32i/verif/core_sim/test_arithmetic/dmem.mem"
#     inst_bin = [0b00000000001100010000000010110011,
#                 0b00000000010100100000000100110011,
#                 0b00000000001000001000000110110011 ]
#     
#     dut.imem.data[0].value = inst_bin[0]
#     dut.imem.data[1].value = inst_bin[1]
#     dut.imem.data[2].value = inst_bin[2]
# 
#     dut.rf.rf_data[2].value = 2
#     dut.rf.rf_data[3].value = 3
#     dut.rf.rf_data[4].value = 4
#     dut.rf.rf_data[5].value = 5
#     
#     with open(dmem_path, "r") as dmem_mem:
#         idx  = 0
#         bank0_mask = 0x000000ff
#         bank1_mask = 0x0000ff00
#         bank2_mask = 0x00ff0000
#         bank3_mask = 0xff000000
#         for line in dmem_mem:
#             data = line.strip()  # Remove leading/trailing whitespaces and newline characters
#             data_decimal = int(data, 16)
#             dut.dmem.bank0[idx].value = data_decimal & bank0_mask
#             dut.dmem.bank1[idx].value = (data_decimal & bank1_mask) >> 8
#             dut.dmem.bank2[idx].value = (data_decimal & bank2_mask) >> 16
#             dut.dmem.bank3[idx].value = (data_decimal & bank3_mask) >> 24
#             idx = idx + 1
# 
#     dut.imem.data[0].value
# 
#     dut.i_rst_n.value = 0
# 
#     # Create a 10ns period clock on port clk
#     clock = Clock(dut.i_clk, 10, units="ns")  
#     # Start the clock. Start it low to avoid issues on the first RisingEdge
#     cocotb.start_soon(clock.start(start_high=False))
# 
#     await Timer(1, units="ns")
#     dut.i_rst_n.value = 1
# 
#     for _ in range(20):
#         await RisingEdge(dut.i_clk)
#     
#     assert dut.rf.rf_data[3].value == 14, "data forwarding mismatch"
# 
# @cocotb.test()
# async def test_priority_forwarding(dut):
# 
#     # memory initialization
#     imem_path = "/home/pjy-wsl/rv32i/verif/core_sim/test_arithmetic/imem.mem"
#     dmem_path = "/home/pjy-wsl/rv32i/verif/core_sim/test_arithmetic/dmem.mem"
#     inst_bin = [0b00000000001100010000000010110011,
#                 0b00000000010100100000000010110011,
#                 0b00000000001000001000000110110011 ]
#     
#     dut.imem.data[0].value = inst_bin[0]
#     dut.imem.data[1].value = inst_bin[1]
#     dut.imem.data[2].value = inst_bin[2]
# 
#     dut.rf.rf_data[2].value = 2
#     dut.rf.rf_data[3].value = 3
#     dut.rf.rf_data[4].value = 4
#     dut.rf.rf_data[5].value = 5
#     
#     with open(dmem_path, "r") as dmem_mem:
#         idx  = 0
#         bank0_mask = 0x000000ff
#         bank1_mask = 0x0000ff00
#         bank2_mask = 0x00ff0000
#         bank3_mask = 0xff000000
#         for line in dmem_mem:
#             data = line.strip()  # Remove leading/trailing whitespaces and newline characters
#             data_decimal = int(data, 16)
#             dut.dmem.bank0[idx].value = data_decimal & bank0_mask
#             dut.dmem.bank1[idx].value = (data_decimal & bank1_mask) >> 8
#             dut.dmem.bank2[idx].value = (data_decimal & bank2_mask) >> 16
#             dut.dmem.bank3[idx].value = (data_decimal & bank3_mask) >> 24
#             idx = idx + 1
# 
#     dut.imem.data[0].value
# 
#     dut.i_rst_n.value = 0
# 
#     # Create a 10ns period clock on port clk
#     clock = Clock(dut.i_clk, 10, units="ns")  
#     # Start the clock. Start it low to avoid issues on the first RisingEdge
#     cocotb.start_soon(clock.start(start_high=False))
# 
#     await Timer(1, units="ns")
#     dut.i_rst_n.value = 1
# 
#     for _ in range(20):
#         await RisingEdge(dut.i_clk)
# 
#     assert dut.rf.rf_data[3].value == 11, "data priority forwarding mismatch"
#     
# 
# @cocotb.test()
# async def test_stall_by_load_use(dut):
# 
#     # memory initialization
#     imem_path = "/home/pjy-wsl/rv32i/verif/core_sim/test_arithmetic/imem.mem"
#     dmem_path = "/home/pjy-wsl/rv32i/verif/core_sim/test_arithmetic/dmem.mem"
#     inst_bin = [0b00000000100000000100000010000011,
#                 0b00000000010100001000000100110011 ]
#     
#     dut.imem.data[0].value = inst_bin[0]
#     dut.imem.data[1].value = inst_bin[1]
#     dut.imem.data[2].value = 0
# 
#     dut.rf.rf_data[2].value = 2
#     dut.rf.rf_data[3].value = 3
#     dut.rf.rf_data[4].value = 4
#     dut.rf.rf_data[5].value = 5
#     
#     with open(dmem_path, "r") as dmem_mem:
#         idx  = 0
#         bank0_mask = 0x000000ff
#         bank1_mask = 0x0000ff00
#         bank2_mask = 0x00ff0000
#         bank3_mask = 0xff000000
#         for line in dmem_mem:
#             data = line.strip()  # Remove leading/trailing whitespaces and newline characters
#             data_decimal = int(data, 16)
#             dut.dmem.bank0[idx].value = data_decimal & bank0_mask
#             dut.dmem.bank1[idx].value = (data_decimal & bank1_mask) >> 8
#             dut.dmem.bank2[idx].value = (data_decimal & bank2_mask) >> 16
#             dut.dmem.bank3[idx].value = (data_decimal & bank3_mask) >> 24
#             idx = idx + 1
# 
#     dut.imem.data[0].value
# 
#     dut.i_rst_n.value = 0
# 
#     # Create a 10ns period clock on port clk
#     clock = Clock(dut.i_clk, 10, units="ns")  
#     # Start the clock. Start it low to avoid issues on the first RisingEdge
#     cocotb.start_soon(clock.start(start_high=False))
# 
#     await Timer(1, units="ns")
#     dut.i_rst_n.value = 1
# 
#     for _ in range(20):
#         await RisingEdge(dut.i_clk)
#             
# @cocotb.test()
# async def test_Arithmetic(dut):
# 
#     # memory initialization
#     imem_path = "/home/pjy-wsl/rv32i/verif/core_sim/test_arithmetic/imem.mem"
#     dmem_path = "/home/pjy-wsl/rv32i/verif/core_sim/test_arithmetic/dmem.mem"
#     with open(imem_path, "r") as imem_mem:
#         idx  = 0
#         for line in imem_mem:
#             inst = line.strip()  # Remove leading/trailing whitespaces and newline characters
#             inst_decimal = int(inst, 2)
#             dut.imem.data[idx].value = inst_decimal
#             idx = idx + 1
#     with open(dmem_path, "r") as dmem_mem:
#         idx  = 0
#         bank0_mask = 0x000000ff
#         bank1_mask = 0x0000ff00
#         bank2_mask = 0x00ff0000
#         bank3_mask = 0xff000000
#         for line in dmem_mem:
#             data = line.strip()  # Remove leading/trailing whitespaces and newline characters
#             data_decimal = int(data, 16)
#             dut.dmem.bank0[idx].value = data_decimal & bank0_mask
#             dut.dmem.bank1[idx].value = (data_decimal & bank1_mask) >> 8
#             dut.dmem.bank2[idx].value = (data_decimal & bank2_mask) >> 16
#             dut.dmem.bank3[idx].value = (data_decimal & bank3_mask) >> 24
#             idx = idx + 1
# 
#     dut.i_rst_n.value = 0
# 
#     # Create a 10ns period clock on port clk
#     clock = Clock(dut.i_clk, 10, units="ns")  
#     # Start the clock. Start it low to avoid issues on the first RisingEdge
#     cocotb.start_soon(clock.start(start_high=False))
# 
#     await Timer(1, units="ns")
#     dut.i_rst_n.value = 1
# 
#     for _ in range(100):
#         
#         await RisingEdge(dut.i_clk)
# 
# @cocotb.test()
# async def test_branch_jump(dut):
# 
#     # memory initialization
#     imem_path = "/home/pjy-wsl/rv32i/verif/core_sim/test_branch_jump/imem.mem"
#     dmem_path = "/home/pjy-wsl/rv32i/verif/core_sim/test_branch_jump/dmem.mem"
#     with open(imem_path, "r") as imem_mem:
#         idx  = 0
#         for line in imem_mem:
#             inst = line.strip()  # Remove leading/trailing whitespaces and newline characters
#             inst_decimal = int(inst, 2)
#             dut.imem.data[idx].value = inst_decimal
#             idx = idx + 1
#     with open(dmem_path, "r") as dmem_mem:
#         idx  = 0
#         bank0_mask = 0x000000ff
#         bank1_mask = 0x0000ff00
#         bank2_mask = 0x00ff0000
#         bank3_mask = 0xff000000
#         for line in dmem_mem:
#             data = line.strip()  # Remove leading/trailing whitespaces and newline characters
#             data_decimal = int(data, 16)
#             dut.dmem.bank0[idx].value = data_decimal & bank0_mask
#             dut.dmem.bank1[idx].value = (data_decimal & bank1_mask) >> 8
#             dut.dmem.bank2[idx].value = (data_decimal & bank2_mask) >> 16
#             dut.dmem.bank3[idx].value = (data_decimal & bank3_mask) >> 24
#             idx = idx + 1
# 
#     dut.i_rst_n.value = 0
# 
#     # Create a 10ns period clock on port clk
#     clock = Clock(dut.i_clk, 10, units="ns")  
#     # Start the clock. Start it low to avoid issues on the first RisingEdge
#     cocotb.start_soon(clock.start(start_high=False))
# 
#     await Timer(1, units="ns")
#     dut.i_rst_n.value = 1
# 
#     for _ in range(100):
#         
#         await RisingEdge(dut.i_clk)


    

    


    

