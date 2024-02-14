
module core_id_stage #(
    parameter XLEN = 32
) (
    input                       i_clk,
    input           [XLEN-1:0]  i_instr,
    input           [XLEN-1:0]  i_rd_din,
    input           [4:0]       i_wb_rd,
    input                       i_wb_reg_write,
    output  logic   [6:0]       o_opcode,
    output  logic   [4:0]       o_rd,
    output  logic   [2:0]       o_funct3,
    output  logic   [4:0]       o_rs1,
    output  logic   [4:0]       o_rs2,
    output  logic   [6:0]       o_funct7,
    output  logic               o_mem_read,
    output  logic               o_mem_write,
    output  logic               o_reg_write,
    output  logic   [2:0]       o_mem_to_reg,
    output  logic   [1:0]       o_d_size,
    output  logic               o_d_unsigned,
    output  logic   [1:0]       o_csr_op,
    output  logic               o_csr_imm,
    output  logic               o_csr_write,
    output  logic   [XLEN-1:0]  o_imm,
    output  logic   [XLEN-1:0]  o_rs1_dout,
    output  logic   [XLEN-1:0]  o_rs2_dout
);

    // instruction parsing
    assign o_opcode = i_instr[6:0];
    assign o_rd = i_instr[11:7];
    assign o_funct3 = i_instr[14:12];
    assign o_rs1 = i_instr[19:15];
    assign o_rs2 = i_instr[24:20];
    assign o_funct7 = i_instr[31:25];
    
    // Main control unit
    main_control_unit ctrl_u (
        .i_opcode       (o_opcode),
        .i_rd           (o_rd),
        .i_funct3       (o_funct3),
        .i_rs1          (o_rs1),
        .i_funct7       (o_funct7),
        .o_mem_read     (o_mem_read),
        .o_mem_write    (o_mem_write),
        .o_reg_write    (o_reg_write),
        .o_mem_to_reg   (o_mem_to_reg),
        .o_d_size       (o_d_size),
        .o_d_unsigned   (o_d_unsigned),
        .o_csr_op       (o_csr_op),
        .o_csr_imm      (o_csr_imm),
        .o_csr_write    (o_csr_write)
    );

    // Immrdiate generator
    immediate_generator imm_gen (
        .i_opcode   (o_opcode),
        .i_rd       (o_rd),
        .i_funct3   (o_funct3),
        .i_rs1      (o_rs1),
        .i_rs2      (o_rs2),
        .i_funct7   (o_funct7),
        .o_imm      (o_imm)
    );
    
    register_file #(
        .XLEN           (XLEN)
    ) rf (
        .i_clk          (i_clk),
        .i_rs1          (o_rs1),
        .i_rs2          (o_rs2),
        .i_rd           (i_wb_rd),
        .i_rd_din       (i_rd_din),
        .i_reg_write    (i_wb_reg_write),
        .o_rs1_dout     (o_rs1_dout),
        .o_rs2_dout     (o_rs2_dout)
    );

endmodule