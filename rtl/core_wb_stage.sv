
module core_wb_stage #(
    parameter XLEN = 32
) (
    input           [1:0]       i_d_size,
    input                       i_d_unsigned,
    input           [1:0]       i_mem_to_reg,
    input           [XLEN-1:0]  i_data_rd_data,
    input           [XLEN-1:0]  i_imm,
    input           [XLEN-1:0]  i_pc_plus_4,
    input           [XLEN-1:0]  i_alu_result,
    output  logic   [XLEN-1:0]  o_rd_din
);

    logic [31:0] dmem_dout;
    logic [31:0] dmem_dout_sized;

    assign dmem_dout = i_data_rd_data;

    always @(*) begin
        case (i_d_size)
            2'b00: begin    // BYTE
                if (i_d_unsigned) begin
                    dmem_dout_sized = {24'b0, dmem_dout[7:0]};
                end else begin
                    dmem_dout_sized = $signed(dmem_dout << 27) >>> 27;
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
            2'b00:
                o_rd_din = i_alu_result;
            2'b01:
                o_rd_din = dmem_dout_sized;
            2'b10: 
                o_rd_din = i_pc_plus_4;
            2'b11:
                o_rd_din = i_imm;
            default: 
                o_rd_din = i_alu_result;
        endcase 
    end

endmodule