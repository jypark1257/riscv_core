
module core_ex_stage #(
    parameter XLEN = 32
) (
    input                       i_clk,
    input                       i_rst_n,
    input           [XLEN-1:0]  i_pc,
    input           [6:0]       i_opcode,
    input           [4:0]       i_rd,
    input           [2:0]       i_funct3,
    input           [4:0]       i_rs1,
    input           [4:0]       i_rs2,
    input           [6:0]       i_funct7,
    input           [XLEN-1:0]  i_rs1_dout,
    input           [XLEN-1:0]  i_rs2_dout,
    input           [XLEN-1:0]  i_imm,
    input           [XLEN-1:0]  i_rd_din,
    input           [1:0]       i_csr_op,
    input                       i_csr_imm,
    input                       i_csr_write,
    input           [4:0]       i_fflags,
    input           [4:0]       i_wb_rd,
    input                       i_wb_reg_write,
    output  logic   [XLEN-1:0]  o_alu_result,
    output  logic   [XLEN-1:0]  o_csr_data,
    output  logic   [XLEN-1:0]  o_mul_result,
    output  logic               o_branch_taken,
    output  logic   [XLEN-1:0]  o_pc_branch,
    output  logic   [XLEN-1:0]  o_forward_in1,
    output  logic   [XLEN-1:0]  o_forward_in2,
    output  logic   [2:0]       o_frm
);

    logic [1:0] forward_a;
    logic [1:0] forward_b;

    logic [4:0] alu_control;
    logic       alu_zero;

    logic [11:0] csr_addr;
    logic [XLEN-1:0] csr_source;


    // ALU control unit
    alu_control_unit alu_ctrl_u (
        .i_opcode       (i_opcode),
        .i_funct7       (i_funct7),
        .i_funct3       (i_funct3),
        .o_alu_control  (alu_control)
    );

    // Forwarding unit
    localparam OPCODE_R = 7'b0110011;
    localparam OPCODE_STORE = 7'b0100011;
    localparam OPCODE_BRANCH = 7'b1100011;
    localparam OPCODE_AUIPC = 7'b0010111;
    forwarding_unit f_u (
        .i_opcode           (i_opcode),
        .i_rs1              (i_rs1),
        .i_rs2              (i_rs2),
        .i_wb_reg_write     (i_wb_reg_write),
        .i_wb_rd            (i_wb_rd),
        .o_forward_a        (forward_a),
        .o_forward_b        (forward_b)
    );

    // forward rs1
    // always_comb
    always @(*) begin
        if (forward_a == 2'b10) begin   // WB STAGE
            o_forward_in1 = i_rd_din;
        end else begin
            if (i_opcode == OPCODE_AUIPC) begin
                o_forward_in1 = i_pc;
            end else begin
                o_forward_in1 = i_rs1_dout;
            end
        end
    end

    // forward rs2
    always @(*) begin
        if (forward_b == 2'b10) begin   // WB STAGE
            o_forward_in2 = i_rd_din;
        end else begin
            if ((i_opcode == OPCODE_R) || (i_opcode == OPCODE_STORE) || (i_opcode == OPCODE_BRANCH)) begin
                o_forward_in2 = i_rs2_dout;
            end else begin
                o_forward_in2 = i_imm;
            end
        end
    end

    logic [31:0] alu_in2;

    always @(*) begin
        if (i_opcode == OPCODE_STORE) begin
            alu_in2 = i_imm;
        end else if (i_opcode == OPCODE_R) begin
            if ((i_funct3 == 3'h1) || (i_funct3 == 3'h5)) begin
                alu_in2 = {27'b0, o_forward_in2[4:0]};
            end else begin
                alu_in2 = o_forward_in2;
            end
        end else begin
            alu_in2 = o_forward_in2;
        end
    end

    //assign alu_in2 = (i_opcode == OPCODE_STORE) ? i_imm : o_forward_in2;

    // Arithmetic logic unit
    alu #(
        .XLEN           (XLEN)
    ) alu (
        .i_alu_in1      (o_forward_in1),
        .i_alu_in2      (alu_in2),
        .i_alu_control  (alu_control),
        .o_alu_result   (o_alu_result),
        .o_alu_zero     (alu_zero)
    );
    
    // cs registers
    assign csr_addr = {i_funct7, i_rs2};
    assign csr_source = (i_csr_imm) ? {27'b0, i_rs1} : o_forward_in1;

    cs_registers csr (
        .i_clk          (i_clk),
        .i_rst_n        (i_rst_n),
        .i_csr_addr     (csr_addr), 
        .i_csr_op       (i_csr_op),
        .i_csr_write    (i_csr_write),
        .i_fflags       (i_fflags),
        .i_wr_data      (csr_source),  
        .o_rd_data      (o_csr_data),
        .o_frm          (o_frm)
    );

    // multiplier and divider
    multiplier_unit #(
        .XLEN(32)
    ) m_u (
        .i_mult_in1 (o_forward_in1),
        .i_mult_in2 (o_forward_in2),
        .i_opcode   (i_opcode),
        .i_funct3   (i_funct3),
        .i_funct7   (i_funct7),
        .o_result   (o_mul_result),
        .o_muldiv   ()
    );

    // Branch unit
    branch_unit #(
        .XLEN           (XLEN)
    ) b_u (
        .i_opcode       (i_opcode),
        .i_funct3       (i_funct3),
        .i_alu_zero     (alu_zero),
        .i_pc           (i_pc),
        .i_rs1_dout     (o_forward_in1),
        .i_imm          (i_imm),
        .o_branch_taken (o_branch_taken),
        .o_pc_branch    (o_pc_branch)
    );


endmodule