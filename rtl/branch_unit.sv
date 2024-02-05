module branch_unit #(
    parameter XLEN = 32
) (
    input           [6:0]       i_opcode,
    input           [2:0]       i_funct3,
    input                       i_alu_zero,
    input           [XLEN-1:0]  i_pc,
    input           [31:0]      i_rs1_dout,
    input           [31:0]      i_imm,
    output  logic               o_branch_taken,
    output  logic   [XLEN-1:0]  o_pc_branch
);

    // OPCODES
    localparam OPCODE_JALR = 7'b1100111;
    localparam OPCODE_JAL = 7'b1101111;
    localparam OPCODE_BRANCH = 7'b1100011;

    // FUNCT3
    localparam BRANCH_BEQ = 3'b000;
    localparam BRANCH_BNE = 3'b001;
    localparam BRANCH_BLT = 3'b100;
    localparam BRANCH_BGE = 3'b101;
    localparam BRANCH_BLTU = 3'b110;
    localparam BRANCH_BGEU = 3'b111;

    always_comb begin
        o_branch_taken = '0;
        o_pc_branch = '0;

        case (i_opcode)
            OPCODE_JAL: begin
                o_branch_taken = 1'b1;
                o_pc_branch = i_pc + i_imm;
            end
            OPCODE_JALR: begin
                if (i_funct3 == 3'h0) begin
                    o_branch_taken = 1'b1;
                    o_pc_branch = i_rs1_dout + i_imm;
                end else begin
                    o_branch_taken = 1'b0;
                    // invalid branch pc
                end
            end
            OPCODE_BRANCH: begin
                o_pc_branch = i_pc + i_imm;
                case (i_funct3)
                    BRANCH_BEQ: begin
                        o_branch_taken = (i_alu_zero) ? 1'b1 : 1'b0;
                    end
                    BRANCH_BNE: begin
                        o_branch_taken = (!i_alu_zero) ? 1'b1 : 1'b0;
                    end
                    BRANCH_BLT: begin
                        o_branch_taken = (!i_alu_zero) ? 1'b1 : 1'b0;
                    end
                    BRANCH_BGE: begin
                        o_branch_taken = (i_alu_zero) ? 1'b1 : 1'b0;
                    end
                    BRANCH_BLTU: begin
                        o_branch_taken = (!i_alu_zero) ? 1'b1 : 1'b0;
                    end
                    BRANCH_BGEU: begin
                        o_branch_taken = (i_alu_zero) ? 1'b1 : 1'b0;
                    end 
                    default: begin
                        o_branch_taken = 1'b0;
                    end
                endcase
            end 
            default: begin
                o_branch_taken = 1'b0;
            end
        endcase
    end

endmodule