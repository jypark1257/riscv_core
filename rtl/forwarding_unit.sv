module forwarding_unit (
    input           [6:0]   i_opcode,
    input           [4:0]   i_rs1,
    input           [4:0]   i_rs2,
    input                   i_wb_reg_write,
    input           [4:0]   i_wb_rd,
    output  logic   [1:0]   o_forward_a,
    output  logic   [1:0]   o_forward_b
);
    // OPCODES 
    localparam OPCODE_R = 7'b0110011;
    localparam OPCODE_STORE = 7'b0100011;
    localparam OPCODE_BRANCH = 7'b1100011;
    localparam OPCODE_JAL = 7'b1101111;
    localparam OPCODE_AUIPC = 7'b0010111;
    localparam OPCODE_LUI = 7'b0110111;

    localparam RF_DATA = 2'b01;
    localparam WB_DATA = 2'b10;

    always_comb begin
        o_forward_a = RF_DATA;
        if ((i_opcode != OPCODE_JAL) && (i_opcode != OPCODE_LUI) && (i_opcode != OPCODE_AUIPC)) begin
            if (i_wb_reg_write && (i_wb_rd == i_rs1)) begin
                o_forward_a = WB_DATA;
            end else begin
                o_forward_a = RF_DATA;
            end
        end else begin
            o_forward_a = RF_DATA;
        end
    end

    always_comb begin
        o_forward_b = RF_DATA;
        if ((i_opcode == OPCODE_R) || (i_opcode == OPCODE_STORE) || (i_opcode == OPCODE_BRANCH)) begin
            if (i_wb_reg_write && (i_wb_rd == i_rs2)) begin
                o_forward_b = WB_DATA;
            end else begin
                o_forward_b = RF_DATA;
            end
        end else begin
            o_forward_b = RF_DATA;
        end
    end


endmodule