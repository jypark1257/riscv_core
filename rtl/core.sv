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
    logic           mem_read;
    logic           mem_write;
    logic           reg_write;
    logic   [1:0]   mem_to_reg;
    logic   [1:0]   d_size;
    logic           d_unsigned;
    logic   [31:0]  rs1_dout;
    logic   [31:0]  rs2_dout;
} pipe_id_ex;

// Pipe reg: MEM/WB
typedef struct packed {
    logic   [31:0]  pc_plus_4;
    logic   [4:0]   rd;
    logic   [31:0]  imm;
    logic   [31:0]  alu_result;
    logic           reg_write;
    logic   [1:0]   mem_to_reg;
    logic   [1:0]   d_size;
    logic           d_unsigned;
    logic   [31:0]  rd_din;
} pipe_ex_wb;

module core #(
    parameter XLEN = 32
) (
    input                       i_clk,
    input                       i_rst_n,
    // instruction interface
    output  logic   [XLEN-1:0]  o_instr_addr,
    input           [XLEN-1:0]  i_instr_data,
    output  logic               o_instr_req,
    input                       i_instr_ack,
    // data interface
    output  logic   [XLEN-1:0]  o_data_addr,
    input           [XLEN-1:0]  i_data_rd_data,
    output  logic   [XLEN-1:0]  o_data_wr_data,
    output  logic   [1:0]       o_data_mask,
    output  logic               o_data_wr_en,
    output  logic               o_data_req,
    input                       i_data_ack
);

    // pipline registers
    pipe_if_id      id;
    pipe_id_ex      ex;
    pipe_ex_wb      wb;

    // --------------------------------------------------------

    // Program counter
    logic pc_write;
    logic [XLEN-1:0] pc_curr;
    logic [XLEN-1:0] pc_next;
    logic [XLEN-1:0] pc_plus_4;
    logic [XLEN-1:0] pc_branch_plus_4;
    logic branch_taken;
    logic [XLEN-1:0] pc_branch;

    assign pc_plus_4 = pc_curr + 4;
    assign pc_branch_plus_4 = pc_branch + 4;

    assign pc_next = (branch_taken) ? pc_branch_plus_4 : pc_plus_4;

    program_counter #(
        .XLEN       (XLEN)
    ) pc (
        .i_clk      (i_clk),
        .i_reset_n  (i_rst_n),
        .i_pc_write (pc_write),
        .i_pc_next  (pc_next),
        .o_pc_curr  (pc_curr)
    );

    // --------------------------------------------------------

    logic [XLEN-1:0] pc_instr;
    always_ff @(posedge i_clk or negedge i_rst_n) begin
        if (~i_rst_n) begin
            pc_instr <= '0;
        end else begin
            if (branch_taken) begin
                pc_instr <= pc_branch;
            end else begin
                pc_instr <= pc_curr;
            end
        end
    end

    // Instruction memory
    logic [XLEN-1:0] instr;
    assign o_instr_addr = (branch_taken) ? pc_branch : pc_curr;
    assign o_instr_req = 1'b1;
    assign pc_write = 1'b1;
    assign instr = (i_instr_ack) ? i_instr_data : '0;


    // --------------------------------------------------------

    logic if_flush;

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

    logic [6:0] opcode;
    logic [4:0] rd;
    logic [2:0] funct3;
    logic [4:0] rs1;
    logic [4:0] rs2;
    logic [6:0] funct7;

    logic mem_read;
    logic mem_write;
    logic reg_write;
    logic [1:0] mem_to_reg;
    logic is_branch;
    logic [1:0] d_size;
    logic d_unsigned;

    logic [XLEN-1:0] imm;

    // instruction parsing
    assign opcode = id.instr[6:0];
    assign rd = id.instr[11:7];
    assign funct3 = id.instr[14:12];
    assign rs1 = id.instr[19:15];
    assign rs2 = id.instr[24:20];
    assign funct7 = id.instr[31:25];
    
    // Main control unit
    main_control_unit ctrl_u (
        .i_opcode       (opcode),
        .i_funct3        (funct3),
        .o_mem_read      (mem_read),
        .o_mem_write     (mem_write),
        .o_reg_write     (reg_write),
        .o_mem_to_reg    (mem_to_reg),
        .o_d_size        (d_size),
        .o_d_unsigned    (d_unsigned)
    );

    // Immrdiate generator
    immediate_generator imm_gen (
        .i_opcode  (opcode),
        .i_rd       (rd),
        .i_funct3   (funct3),
        .i_rs1      (rs1),
        .i_rs2      (rs2),
        .i_funct7   (funct7),
        .o_imm      (imm)
    );

    // register file
    logic [XLEN-1:0] rd_din;
    logic [XLEN-1:0] rs1_dout;
    logic [XLEN-1:0] rs2_dout;
    
    register_file #(
        .XLEN           (XLEN)
    ) rf (
        .i_clk          (i_clk),
        .i_rs1          (rs1),
        .i_rs2          (rs2),
        .i_rd           (wb.rd),
        .i_rd_din       (rd_din),
        .i_reg_write    (wb.reg_write),
        .o_rs1_dout     (rs1_dout),
        .o_rs2_dout     (rs2_dout)
    );

    // --------------------------------------------------------
    
    logic id_flush;

    assign id_flush = (branch_taken) ? 1 : 0;

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
                ex.mem_read <= mem_read;
                ex.mem_write <= mem_write;
                ex.reg_write <= reg_write;
                ex.mem_to_reg <= mem_to_reg;
                ex.d_size <= d_size;
                ex.d_unsigned <= d_unsigned;
                ex.rs1_dout <= rs1_dout;
                ex.rs2_dout <= rs2_dout;
            end
        end
    end

    // --------------------------------------------------------


    logic [XLEN-1:0] forward_in1;
    logic [XLEN-1:0] forward_in2;

    logic [1:0] forward_a;
    logic [1:0] forward_b;

    logic [4:0] alu_control;
    logic [XLEN-1:0] alu_result;
    logic       alu_zero;

    // ALU control unit
    alu_control_unit alu_ctrl_u (
        .i_opcode      (ex.opcode),
        .i_funct7       (ex.funct7),
        .i_funct3       (ex.funct3),
        .o_alu_control  (alu_control)
    );

    // Forwarding unit
    localparam OPCODE_R = 7'b0110011;
    localparam OPCODE_STORE = 7'b0100011;
    localparam OPCODE_BRANCH = 7'b1100011;
    localparam OPCODE_AUIPC = 7'b0010111;
    forwarding_unit f_u (
        .i_opcode           (ex.opcode),
        .i_rs1              (ex.rs1),
        .i_rs2              (ex.rs2),
        .i_wb_reg_write     (wb.reg_write),
        .i_wb_rd            (wb.rd),
        .o_forward_a        (forward_a),
        .o_forward_b        (forward_b)
    );

    // forward rs1
    // always_comb
    always @(*) begin
        if(forward_a == 2'b10) begin   // WB STAGE
            forward_in1 = rd_din;
        end else begin
            if (ex.opcode == OPCODE_AUIPC) begin
                forward_in1 = ex.pc;
            end else begin
                forward_in1 = ex.rs1_dout;
            end
        end
    end

    // forward rs2
    always @(*) begin
        if(forward_b == 2'b10) begin   // WB STAGE
            forward_in2 = rd_din;
        end else begin
            if((ex.opcode == OPCODE_R) || (ex.opcode == OPCODE_STORE) || (ex.opcode == OPCODE_BRANCH)) begin
                forward_in2 = ex.rs2_dout;
            end else begin
                forward_in2 = ex.imm;
            end
        end
    end

    logic [31:0] alu_in2;

    assign alu_in2 = (ex.opcode == OPCODE_STORE) ? ex.imm : forward_in2;

    // Arithmetic logic unit
    alu #(
        .XLEN           (XLEN)
    ) alu (
        .i_alu_in1      (forward_in1),
        .i_alu_in2      (alu_in2),
        .i_alu_control  (alu_control),
        .o_alu_result   (alu_result),
        .o_alu_zero     (alu_zero)
    );
    
    // Branch unit
    branch_unit #(
        .XLEN           (XLEN)
    ) b_u (
        .i_opcode       (ex.opcode),
        .i_funct3       (ex.funct3),
        .i_alu_zero     (alu_zero),
        .i_pc           (ex.pc),
        .i_rs1_dout     (forward_in1),
        .i_imm          (ex.imm),
        .o_branch_taken (branch_taken),
        .o_pc_branch    (pc_branch)
    );

    // data interface set
    assign o_data_addr = alu_result;
    assign o_data_wr_data = forward_in2;
    assign o_data_mask = ex.d_size;
    assign o_data_wr_en = ex.mem_write;
    assign o_data_req =  1'b1;


    // --------------------------------------------------------

    always_ff @(posedge i_clk or negedge i_rst_n) begin
        if (~i_rst_n) begin
            wb <= '0;
        end else begin
            wb.pc_plus_4 <= ex.pc + 4;
            wb.rd <= ex.rd;
            wb.imm <= ex.imm;
            wb.alu_result <= alu_result;
            wb.reg_write <= ex.reg_write;
            wb.mem_to_reg <= ex.mem_to_reg;
            wb.d_size <= ex.d_size;
            wb.d_unsigned <= ex.d_unsigned;
        end
    end

    // --------------------------------------------------------

    logic [31:0] dmem_dout;
    logic [31:0] dmem_dout_sized;

    assign dmem_dout = i_data_rd_data;

    always @(*) begin
        case (wb.d_size)
            2'b00: begin    // BYTE
                if (wb.d_unsigned) begin
                    dmem_dout_sized = {24'b0, dmem_dout[7:0]};
                end else begin
                    dmem_dout_sized = $signed(dmem_dout << 27) >>> 27;
                end
            end
            2'b01: begin    // HALF WORD
                if (wb.d_unsigned) begin
                    dmem_dout_sized = {16'b0, dmem_dout[15:0]};
                end else begin
                    dmem_dout_sized = $signed(dmem_dout << 16) >>> 16;
                end
            end
            2'b11: begin    // WORD
                dmem_dout_sized = dmem_dout;
            end
            default: begin
                dmem_dout_sized = dmem_dout;
            end
        endcase
    
    end

    always @(*) begin
        case(wb.mem_to_reg)
            2'b00:
                rd_din = wb.alu_result;
            2'b01:
                rd_din = dmem_dout_sized;
            2'b10: 
                rd_din = wb.pc_plus_4;
            2'b11:
                rd_din = wb.imm;
            default: 
                rd_din = wb.alu_result;
        endcase 
    end

    // --------------------------------------------------------

endmodule