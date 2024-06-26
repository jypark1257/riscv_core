// Pipe reg: IF/ID
typedef struct packed {
    logic   [31:0]  pc;
    logic   [31:0]  instr;
} pipe_if_id;

// Pipe reg: ID/EX
typedef struct packed {
    logic   [31:0]  pc;
    logic   [6:0]   opcode;
    logic   [4:0]   rd;         // rd for regfile
    logic   [2:0]   funct3;
    logic   [4:0]   rs1;
    logic   [4:0]   rs2;
    logic   [6:0]   funct7;
    logic   [31:0]  imm;
    logic           mem_write;
    logic           reg_write;
    logic   [2:0]   mem_to_reg;
    logic   [1:0]   d_size;
    logic           d_unsigned;
    logic   [1:0]   csr_op;
    logic           csr_imm;
    logic           csr_write;
    logic   [31:0]  rs1_dout;
    logic   [31:0]  rs2_dout;
} pipe_id_ex;

// Pipe reg: MEM/WB
typedef struct packed {
    logic   [31:0]  pc_plus_4;
    logic   [4:0]   rd;
    logic   [31:0]  imm;
    logic   [31:0]  alu_result;
    logic   [31:0]  csr_data;
    logic   [31:0]  mul_result;
    logic   [31:0]  fpu_result;
    logic           reg_write;
    logic           fp_reg_write;
    logic   [2:0]   mem_to_reg;
    logic   [1:0]   d_size;
    logic           d_unsigned;
    logic   [31:0]  rd_din;
} pipe_ex_wb;

module core #(
    parameter XLEN = 32,
    parameter FLEN = 32,
    parameter RESET_PC = 32'h4000_0000
) (
    input                       i_clk,
    input                       i_rst_n,
    // instruction interface
    output  logic   [XLEN-1:0]  o_instr_addr,
    input           [XLEN-1:0]  i_instr_data,
    // data interface
    output  logic   [XLEN-1:0]  o_data_addr,
    input           [XLEN-1:0]  i_data_rd_data,
    output  logic   [XLEN-1:0]  o_data_wr_data,
    output  logic   [1:0]       o_data_mask,
    output  logic               o_data_wr_en,
            // UART
    output  logic               o_data_out_ready,
    output  logic               o_data_in_valid,
    output  logic   [7:0]       o_data_in
);

    // FP OPCODE
    localparam OPCODE_FLW = 7'b0000111;
    localparam OPCODE_FSW = 7'b0100111;

    // pipline registers
    pipe_if_id      id;
    pipe_id_ex      ex;
    pipe_ex_wb      wb;

    logic pc_write;
    logic [XLEN-1:0] pc_curr;
    logic [XLEN-1:0] pc_instr;

    logic branch_taken;
    logic [XLEN-1:0] pc_branch;
    
    logic [6:0] opcode;
    logic [4:0] rd;
    logic [2:0] funct3;
    logic [4:0] rs1;
    logic [4:0] rs2;
    logic [6:0] funct7;

    logic mem_write;
    logic reg_write;
    logic [2:0] mem_to_reg;
    logic [1:0] d_size;
    logic d_unsigned;
    logic [1:0] csr_op;
    logic csr_imm;
    logic csr_write;

    logic [XLEN-1:0] wr_data;
    logic [XLEN-1:0] forward_in2;
    logic [XLEN-1:0] alu_result;
    logic [XLEN-1:0] csr_data;
    logic [XLEN-1:0] mul_result;
    logic [FLEN-1:0] fpu_result;
    logic ex_mem_write;

    logic [2:0] frm;
    logic [4:0] fflags;
    logic [XLEN-1:0] int_forward_rs1;

    logic [XLEN-1:0] imm;

    logic [XLEN-1:0] rs1_dout;
    logic [XLEN-1:0] rs2_dout;

    logic [XLEN-1:0] rd_din;
    
    logic [FLEN-1:0] fp_wr_data;

    logic fp_reg_write;

    logic if_flush;    
    logic id_flush;

    // --------------------------------------------------------

    core_if_stage #(
        .XLEN           (32),
        .RESET_PC       (32'h4000_0000)
    ) core_IF (
        .i_clk          (i_clk),
        .i_rst_n        (i_rst_n),
        .i_pc_write     (pc_write),
        .i_branch_taken (branch_taken),
        .i_pc_branch    (pc_branch),
        .o_pc_curr      (pc_curr),
        .o_pc_instr     (pc_instr)
    );

    // Instruction memory
    logic [XLEN-1:0] instr;
    assign o_instr_addr = (branch_taken) ? pc_branch : pc_curr;
    assign pc_write = 1'b1;
    assign instr = i_instr_data;

    // --------------------------------------------------------

    assign if_flush = (branch_taken) ? 1 : 0;

    // IF/ID pipeline register
    always_ff @(posedge i_clk or negedge i_rst_n) begin
        if (~i_rst_n) begin
            id <= '0;
        end else begin
            if (if_flush) begin
                id <= '0;
            end else begin
                id.pc <= pc_instr;
                id.instr <= instr;
            end
        end
    end

    // --------------------------------------------------------

    core_id_stage #(
        .XLEN(32)
    ) core_ID (
        .i_clk          (i_clk),
        .i_instr        (id.instr),
        .i_rd_din       (rd_din),
        .i_wb_rd        (wb.rd),
        .i_wb_reg_write (wb.reg_write),
        .o_opcode       (opcode),
        .o_rd           (rd),
        .o_funct3       (funct3),
        .o_rs1          (rs1),
        .o_rs2          (rs2),
        .o_funct7       (funct7),
        .o_imm          (imm),
        .o_mem_write    (mem_write),
        .o_reg_write    (reg_write),
        .o_mem_to_reg   (mem_to_reg),
        .o_d_size       (d_size),
        .o_d_unsigned   (d_unsigned),
        .o_csr_op       (csr_op),
        .o_csr_imm      (csr_imm),
        .o_csr_write    (csr_write),
        .o_rs1_dout     (rs1_dout),
        .o_rs2_dout     (rs2_dout)
    );

    // --------------------------------------------------------

    
    assign id_flush = (branch_taken) ? 1 : 0;


    floating_point_unit #(
        .XLEN               (32),
        .FLEN               (32)
    ) fpu (
        .i_clk              (i_clk),
        .i_rst_n            (i_rst_n),
        .i_id_flush         (id_flush),
        .i_opcode           (opcode),
        .i_wb_rd            (wb.rd),
        .i_funct3           (funct3),
        .i_rs1              (rs1),
        .i_rs2              (rs2),
        .i_funct7           (funct7),
        .i_int_forward_rs1  (int_forward_rs1),
        .i_fp_rd_din        (rd_din),
        .i_wb_reg_write     (wb.reg_write),
        .i_wb_fp_reg_write  (wb.fp_reg_write),
        .i_frm              (frm),
        .o_fp_forward_in2   (fp_wr_data),
        .o_fflags           (fflags),
        .o_fp_result        (fpu_result),
        .o_fp_reg_write     (fp_reg_write)
    );

    // --------------------------------------------------------

    always_ff @(posedge i_clk or negedge i_rst_n) begin
        if (~i_rst_n) begin
            ex <= '0;
        end else begin
            if (id_flush) begin
                ex <= '0;
            end else begin
                ex.pc <= id.pc;
                ex.opcode <= opcode;
                ex.rd <= rd;
                ex.funct3 <= funct3;
                ex.rs1 <= rs1;
                ex.rs2 <= rs2;
                ex.funct7 <= funct7;
                ex.imm <= imm;
                ex.mem_write <= mem_write;
                ex.reg_write <= reg_write;
                ex.mem_to_reg <= mem_to_reg;
                ex.d_size <= d_size;
                ex.d_unsigned <= d_unsigned;
                ex.csr_op <= csr_op;
                ex.csr_imm <= csr_imm;
                ex.csr_write <= csr_write;
                ex.rs1_dout <= rs1_dout;
                ex.rs2_dout <= rs2_dout;
            end
        end
    end

    // --------------------------------------------------------

    core_ex_stage #(
        .XLEN(32)
    ) core_EX (
        .i_clk          (i_clk),
        .i_rst_n        (i_rst_n),
        .i_pc           (ex.pc),
        .i_opcode       (ex.opcode),
        .i_rd           (ex.rd),
        .i_funct3       (ex.funct3),
        .i_rs1          (ex.rs1),
        .i_rs2          (ex.rs2),
        .i_funct7       (ex.funct7),
        .i_rs1_dout     (ex.rs1_dout),
        .i_rs2_dout     (ex.rs2_dout),
        .i_imm          (ex.imm),
        .i_rd_din       (rd_din),
        .i_csr_op       (ex.csr_op),
        .i_csr_imm      (ex.csr_imm),
        .i_csr_write    (ex.csr_write),
        .i_fflags       (fflags),
        .i_wb_rd        (wb.rd),
        .i_wb_reg_write (wb.reg_write),
        .o_alu_result   (alu_result),
        .o_csr_data     (csr_data),
        .o_mul_result   (mul_result),
        .o_branch_taken (branch_taken),
        .o_pc_branch    (pc_branch),
        .o_forward_in1  (int_forward_rs1),
        .o_forward_in2  (forward_in2),
        .o_frm          (frm)
    );

    assign ex_mem_write = ((alu_result == 32'h80000008) && (ex.opcode[6:2] == 5'b01000) && (!branch_taken)) ? 1'b0 : ex.mem_write;
    
    assign wr_data = (ex.opcode == OPCODE_FSW) ? fp_wr_data : forward_in2;
    
    //UART IO    
    logic [7:0] data_in_q;
    logic data_in_valid_q;
    logic data_out_ready_q;

    always_ff @(posedge i_clk) begin
        data_in_q <= ((alu_result == 32'h80000008) && (ex.opcode[6:2] == 5'b01000) && (!branch_taken)) ? wr_data[7:0] : data_in_q;
        data_in_valid_q <= ((alu_result == 32'h80000008) && (ex.opcode[6:2] == 5'b01000) && (!branch_taken));
        data_out_ready_q <= ((alu_result == 32'h80000004) && (ex.opcode[6:2] == 5'b00000) && (!branch_taken));
    end

    assign o_data_in = data_in_q;
    assign o_data_in_valid = data_in_valid_q;
    assign o_data_out_ready = data_out_ready_q;

    // data interface set
    assign o_data_addr = alu_result;
    assign o_data_wr_data = wr_data;
    assign o_data_mask = ex.d_size;
    assign o_data_wr_en = ex_mem_write;

    // --------------------------------------------------------

    always_ff @(posedge i_clk or negedge i_rst_n) begin
        if (~i_rst_n) begin
            wb <= '0;
        end else begin
            wb.pc_plus_4 <= ex.pc + 4;
            wb.rd <= ex.rd;
            wb.imm <= ex.imm;
            wb.alu_result <= alu_result;
            wb.csr_data <= csr_data;
            wb.mul_result <= mul_result;
            wb.fpu_result <= fpu_result;
            wb.reg_write <= ex.reg_write;
            wb.fp_reg_write <= fp_reg_write;
            wb.mem_to_reg <= ex.mem_to_reg;
            wb.d_size <= ex.d_size;
            wb.d_unsigned <= ex.d_unsigned;
        end
    end

    // --------------------------------------------------------

    core_wb_stage #(
        .XLEN(32)
    ) core_WB (
        .i_d_size       (wb.d_size),
        .i_d_unsigned   (wb.d_unsigned),
        .i_mem_to_reg   (wb.mem_to_reg),
        .i_data_rd_data (i_data_rd_data),
        .i_imm          (wb.imm),
        .i_pc_plus_4    (wb.pc_plus_4),
        .i_alu_result   (wb.alu_result),
        .i_csr_data     (wb.csr_data),
        .i_mul_result   (wb.mul_result),
        .i_fpu_result   (wb.fpu_result),
        .o_rd_din       (rd_din)
    );

    // --------------------------------------------------------

endmodule