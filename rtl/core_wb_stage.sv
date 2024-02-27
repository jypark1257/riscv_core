
module core_wb_stage #(
    parameter XLEN = 32
) (
    input           [1:0]       i_d_size,
    input                       i_d_unsigned,
    input           [2:0]       i_mem_to_reg,
    input           [XLEN-1:0]  i_data_rd_data,
    input           [XLEN-1:0]  i_imm,
    input           [XLEN-1:0]  i_pc_plus_4,
    input           [XLEN-1:0]  i_alu_result,
    input           [XLEN-1:0]  i_csr_data,
    input           [XLEN-1:0]  i_mul_result,
    output  logic   [XLEN-1:0]  o_rd_din
);
    // REGISTER SOURCE
    localparam SRC_ALU = 3'b000;
    localparam SRC_DMEM = 3'b001;
    localparam SRC_PC_PLUS_4 = 3'b010;
    localparam SRC_IMM = 3'b011;
    localparam SRC_CSR = 3'b100;
    localparam SRC_MUL = 3'b101;     // data from multiplier

    logic [31:0] dmem_dout;
    logic [31:0] dmem_dout_sized;

    assign dmem_dout = i_data_rd_data;

    always @(*) begin
        case (i_d_size)
            2'b00: begin    // BYTE
                if (i_d_unsigned) begin
                    dmem_dout_sized = {24'b0, dmem_dout[7:0]};
                end else begin
                    dmem_dout_sized = $signed(dmem_dout << 24) >>> 24;
                end
            end
            2'b01: begin    // HALF WORD
                if (i_d_unsigned) begin
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
        case(i_mem_to_reg)
            SRC_ALU:
                o_rd_din = i_alu_result;    // alu result
            SRC_DMEM:
                o_rd_din = dmem_dout_sized; // memory read
            SRC_PC_PLUS_4: 
                o_rd_din = i_pc_plus_4;     // pc + 4
            SRC_IMM:
                o_rd_din = i_imm;           // immediate
            SRC_CSR:
                o_rd_din = i_csr_data;
            SRC_MUL:
                o_rd_din = i_mul_result;
            default: 
                o_rd_din = i_alu_result;
        endcase 
    end

endmodule