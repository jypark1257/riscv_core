module alu #(
    parameter XLEN = 32
) (
    input           [XLEN-1:0]  i_alu_in1,
    input           [XLEN-1:0]  i_alu_in2,
    input           [4:0]       i_alu_control,
    output  logic   [XLEN-1:0]  o_alu_result,
    output  logic               o_alu_zero
);

    // ALU controls
    localparam ALU_ADD = 5'b0_0000;
    localparam ALU_AND = 5'b0_0001;
    localparam ALU_OR = 5'b0_0010;
    localparam ALU_XOR = 5'b0_0011;
    localparam ALU_SLL = 5'b0_0100;
    localparam ALU_SRL = 5'b0_0101;
    localparam ALU_SRA = 5'b0_0110;
    localparam ALU_SUB = 5'b1_0000;
    localparam ALU_SLTU = 5'b1_1000;
    localparam ALU_SLT = 5'b1_0111;

    always_comb begin
        case (i_alu_control)
            ALU_ADD: begin
                o_alu_result = i_alu_in1 + i_alu_in2;
            end
            ALU_AND: begin
                o_alu_result = i_alu_in1 & i_alu_in2;
            end
            ALU_OR: begin
                o_alu_result = i_alu_in1 | i_alu_in2;
            end
            ALU_XOR: begin
                o_alu_result = i_alu_in1 ^ i_alu_in2;
            end
            ALU_SLL: begin
                o_alu_result = i_alu_in1 << i_alu_in2;
            end
            ALU_SRL: begin
                o_alu_result = i_alu_in1 >> i_alu_in2;
            end
            ALU_SRA: begin
                o_alu_result = $signed(i_alu_in1) >>> i_alu_in2;
            end
            ALU_SUB: begin
                o_alu_result = i_alu_in1 - i_alu_in2;
            end
            ALU_SLTU: begin
                o_alu_result = (i_alu_in1 < i_alu_in2) ? 1 : 0;
            end
            ALU_SLT: begin
                o_alu_result = ($signed(i_alu_in1) < $signed(i_alu_in2)) ? 1 : 0;
            end 
            default: begin
                o_alu_result = i_alu_in1 + i_alu_in2;       // default operation
            end
        endcase
    end

    assign o_alu_zero = (o_alu_result == '0) ? 1 : 0;

endmodule