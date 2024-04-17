# This file is public domain, it can be freely copied without restrictions.
# SPDX-License-Identifier: CC0-1.0

TOPLEVEL_LANG ?= verilog
VERILOG_SOURCES += $(shell pwd)/../../rtl/core_top.sv
VERILOG_SOURCES += $(shell pwd)/../../rtl/core.sv
VERILOG_SOURCES += $(shell pwd)/../../rtl/core_if_stage.sv
VERILOG_SOURCES += $(shell pwd)/../../rtl/core_id_stage.sv
VERILOG_SOURCES += $(shell pwd)/../../rtl/core_ex_stage.sv
VERILOG_SOURCES += $(shell pwd)/../../rtl/core_wb_stage.sv
VERILOG_SOURCES += $(shell pwd)/../../rtl/ram.sv
VERILOG_SOURCES += $(shell pwd)/../../rtl/dp_ram_block.sv
VERILOG_SOURCES += $(shell pwd)/../../rtl/DW_div.v
VERILOG_SOURCES += $(shell pwd)/../../rtl/DW02_mult.v
VERILOG_SOURCES += $(shell pwd)/../../rtl/multiplier_unit.sv
VERILOG_SOURCES += $(shell pwd)/../../rtl/program_counter.sv
VERILOG_SOURCES += $(shell pwd)/../../rtl/main_control_unit.sv
VERILOG_SOURCES += $(shell pwd)/../../rtl/immediate_generator.sv
VERILOG_SOURCES += $(shell pwd)/../../rtl/register_file.sv
VERILOG_SOURCES += $(shell pwd)/../../rtl/cs_registers.sv
VERILOG_SOURCES += $(shell pwd)/../../rtl/branch_unit.sv
VERILOG_SOURCES += $(shell pwd)/../../rtl/forwarding_unit.sv
VERILOG_SOURCES += $(shell pwd)/../../rtl/alu_control_unit.sv
VERILOG_SOURCES += $(shell pwd)/../../rtl/alu.sv
VERILOG_SOURCES += $(shell pwd)/../../rtl/fp_cmp.v
VERILOG_SOURCES += $(shell pwd)/../../rtl/divv.v
VERILOG_SOURCES += $(shell pwd)/../../rtl/DW_fp_add.v
VERILOG_SOURCES += $(shell pwd)/../../rtl/DW_fp_addsub.v
VERILOG_SOURCES += $(shell pwd)/../../rtl/DW_fp_cmp.v
VERILOG_SOURCES += $(shell pwd)/../../rtl/DW_fp_div.v
VERILOG_SOURCES += $(shell pwd)/../../rtl/DW_fp_flt2i.v
VERILOG_SOURCES += $(shell pwd)/../../rtl/DW_fp_i2flt.v
VERILOG_SOURCES += $(shell pwd)/../../rtl/DW_fp_mult.v
VERILOG_SOURCES += $(shell pwd)/../../rtl/DW_fp_sqrt.v
VERILOG_SOURCES += $(shell pwd)/../../rtl/DW_fp_sub.v
VERILOG_SOURCES += $(shell pwd)/../../rtl/floating_point_unit.sv
VERILOG_SOURCES += $(shell pwd)/../../rtl/floating_point_classify.sv
VERILOG_SOURCES += $(shell pwd)/../../rtl/floating_point_f_u.sv
VERILOG_SOURCES += $(shell pwd)/../../rtl/floating_point_rf.sv
VERILOG_SOURCES += $(shell pwd)/../../rtl/floating_point_alu.sv
VERILOG_SOURCES += $(shell pwd)/../../rtl/uart.v
VERILOG_SOURCES += $(shell pwd)/../../rtl/uart_transmitter.v
VERILOG_SOURCES += $(shell pwd)/../../rtl/uart_receiver.v

TOPLEVEL = core_top
MODULE = test_asm

include $(shell cocotb-config --makefiles)/Makefile.sim