
module floating_point_f_u #(
    parameter FLEN = 32
) (
    input           [6:0]       i_opcode,
    input           [6:0]       i_funct7,
    input           [4:0]       i_rs1,
    input           [4:0]       i_rs2,
    input           [4:0]       i_rs3,
    input           [4:0]       i_wb_rd,
    input                       i_wb_reg_write,
    input                       i_wb_fp_reg_write,
    output  logic   [1:0]       o_forward_a,
    output  logic   [1:0]       o_forward_b,
    output  logic   [1:0]       o_forward_c
);

    //OPCODE
    localparam OPCODE_FLW = 7'b0000111;
    localparam OPCODE_FSW = 7'b0100111;
    localparam OPCODE_FMADD = 7'b1000011;
    localparam OPCODE_FMSUB = 7'b1000111;
    localparam OPCODE_FNMSUB = 7'b1001011;
    localparam OPCODE_FNMADD = 7'b1001111;
    localparam OPCODE_FP = 7'b1010011;

    //FUNCT7
    localparam FP_ADD = 7'b0000000;
    localparam FP_SUB = 7'b0000100;
    localparam FP_MUL = 7'b0001000;
    localparam FP_DIV = 7'b0001100;
    localparam FP_SQRT = 7'b0101100;
    localparam FP_MINMAX = 7'b0010100;
    localparam FP_COMP = 7'b1010000;
    localparam FP_CLASS = 7'b1110000;
    localparam FP_CVT_WS = 7'b1100000;
    localparam FP_CVT_SW = 7'b1101000;
    localparam FP_SGNJ = 7'b0010000;
    localparam FP_MVWX = 7'b1111000;

    localparam RF_DATA = 2'b01;
    localparam WB_DATA = 2'b10;

    // RS1
    always_comb begin
        o_forward_a = RF_DATA;
        if ((i_wb_fp_reg_write || i_wb_reg_write) && (i_wb_rd == i_rs1)) begin
            if ((i_opcode != OPCODE_FLW) && (i_opcode != OPCODE_FSW)) begin
                if ((i_opcode == OPCODE_FP) && ((i_funct7 == FP_CVT_SW) || (i_funct7 == FP_MVWX))) begin   
                    o_forward_a = RF_DATA;
                end else begin
                    o_forward_a = WB_DATA;
                end
            end else begin
                o_forward_a = RF_DATA;
            end
        end else begin
            o_forward_a = RF_DATA;
        end
    end

    // RS2
    always_comb begin
        o_forward_b = RF_DATA;
        if (i_wb_fp_reg_write && (i_wb_rd == i_rs2)) begin
            case (i_opcode)
                OPCODE_FSW: begin
                    o_forward_b = WB_DATA;
                end
                OPCODE_FMADD: begin
                    o_forward_b = WB_DATA;
                end
                OPCODE_FMSUB: begin
                    o_forward_b = WB_DATA;
                end
                OPCODE_FNMSUB: begin
                    o_forward_b = WB_DATA;
                end
                OPCODE_FNMADD: begin
                    o_forward_b = WB_DATA;
                end
                OPCODE_FP: begin
                    case (i_funct7)
                        FP_ADD: begin
                            o_forward_b = WB_DATA;
                        end
                        FP_SUB: begin
                            o_forward_b = WB_DATA;
                        end
                        FP_MUL: begin
                            o_forward_b = WB_DATA;
                        end
                        FP_DIV: begin
                            o_forward_b = WB_DATA;
                        end
                        FP_SGNJ: begin
                            o_forward_b = WB_DATA;
                        end
                        FP_MINMAX: begin
                            o_forward_b = WB_DATA;
                        end
                        FP_COMP: begin
                            o_forward_b = WB_DATA;
                        end
                        default: begin
                            o_forward_b = RF_DATA;
                        end
                    endcase
                end
                default: begin
                    o_forward_b = RF_DATA;
                end
            endcase
        end
    end

    // RS3
    always_comb begin
        o_forward_c = RF_DATA;
        if (i_wb_fp_reg_write && (i_wb_rd == i_rs3)) begin
            case (i_opcode)
                OPCODE_FMADD: begin
                    o_forward_c = WB_DATA;
                end
                OPCODE_FMSUB: begin
                    o_forward_c = WB_DATA;
                end
                OPCODE_FNMSUB: begin
                    o_forward_c = WB_DATA;
                end
                OPCODE_FNMADD: begin
                    o_forward_c = WB_DATA;
                end
                default: begin
                    o_forward_c = RF_DATA;
                end
            endcase
        end
    end
    
endmodule