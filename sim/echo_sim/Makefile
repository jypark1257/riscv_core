# This file is public domain, it can be freely copied without restrictions.
# SPDX-License-Identifier: CC0-1.0

TOPLEVEL_LANG ?= verilog
VERILOG_SOURCES += $(shell pwd)/echo_integration_testbench.sv
VERILOG_SOURCES += $(shell pwd)/../../rtl/core_top.sv
VERILOG_SOURCES += $(shell pwd)/../../rtl/core.sv
VERILOG_SOURCES += $(shell pwd)/../../rtl/core_if_stage.sv
VERILOG_SOURCES += $(shell pwd)/../../rtl/core_id_stage.sv
VERILOG_SOURCES += $(shell pwd)/../../rtl/core_ex_stage.sv
VERILOG_SOURCES += $(shell pwd)/../../rtl/core_wb_stage.sv
VERILOG_SOURCES += $(shell pwd)/../../rtl/ram.sv
VERILOG_SOURCES += $(shell pwd)/../../rtl/dp_ram.sv
VERILOG_SOURCES += $(shell pwd)/../../rtl/program_counter.sv
VERILOG_SOURCES += $(shell pwd)/../../rtl/main_control_unit.sv
VERILOG_SOURCES += $(shell pwd)/../../rtl/immediate_generator.sv
VERILOG_SOURCES += $(shell pwd)/../../rtl/register_file.sv
VERILOG_SOURCES += $(shell pwd)/../../rtl/branch_unit.sv
VERILOG_SOURCES += $(shell pwd)/../../rtl/forwarding_unit.sv
VERILOG_SOURCES += $(shell pwd)/../../rtl/alu_control_unit.sv
VERILOG_SOURCES += $(shell pwd)/../../rtl/alu.sv
VERILOG_SOURCES += $(shell pwd)/../../rtl/uart.v
VERILOG_SOURCES += $(shell pwd)/../../rtl/uart_transmitter.v
VERILOG_SOURCES += $(shell pwd)/../../rtl/uart_receiver.v

TOPLEVEL = uart_com
MODULE = test_core

include $(shell cocotb-config --makefiles)/Makefile.sim