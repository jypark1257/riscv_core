
// Floating-point pipe reg: ID/EX
typedef struct packed {
    logic   [6:0]   opcode;
    logic   [2:0]   funct3;
    logic   [4:0]   rs1;
    logic   [4:0]   rs2;
    logic   [4:0]   rs3;
    logic   [6:0]   funct7;
    logic   [31:0]  rs1_dout;
    logic   [31:0]  rs2_dout;
    logic   [31:0]  rs3_dout;
    logic   [2:0]   frm;
} pipe_id_ex_fp;


module floating_point_unit #(
    parameter XLEN = 32,
    parameter FLEN = 32
) (
    input                       i_clk,
    input                       i_rst_n,
    input                       i_id_flush,
    input           [6:0]       i_opcode,
    input           [4:0]       i_wb_rd,
    input           [2:0]       i_funct3,
    input           [4:0]       i_rs1,
    input           [4:0]       i_rs2,
    input           [6:0]       i_funct7,
    input           [XLEN-1:0]  i_int_forward_rs1,
    input           [FLEN-1:0]  i_fp_rd_din,
    input                       i_wb_reg_write,
    input                       i_wb_fp_reg_write,
    input           [2:0]       i_frm,
    output          [FLEN-1:0]  o_fp_forward_in2,
    output logic    [4:0]       o_fflags,
    output logic    [FLEN-1:0]  o_fp_result,
    output logic                o_fp_reg_write
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

    pipe_id_ex_fp ex_fp;

    logic [4:0] rs3;

    logic [FLEN-1:0] rs1_dout;
    logic [FLEN-1:0] rs2_dout;
    logic [FLEN-1:0] rs3_dout;

    assign rs3 = i_funct7[6:2];

    floating_point_rf #(
        .FLEN       (32)
    ) fp_rf (
        .i_clk          (i_clk),
        .i_rs1          (i_rs1),
        .i_rs2          (i_rs2),
        .i_rs3          (rs3),
        .i_rd           (i_wb_rd),
        .i_rd_din       (i_fp_rd_din),
        .i_reg_write    (i_wb_fp_reg_write),
        .o_rs1_dout     (rs1_dout),
        .o_rs2_dout     (rs2_dout),
        .o_rs3_dout     (rs3_dout)
    );

    always_ff @(posedge i_clk or negedge i_rst_n) begin
        if (~i_rst_n) begin
            ex_fp <= '0;
        end else begin
            if (i_id_flush) begin
                ex_fp <='0;
            end else begin
                ex_fp.opcode <= i_opcode;
                ex_fp.funct3 <= i_funct3;
                ex_fp.rs1 <= i_rs1;
                ex_fp.rs2 <= i_rs2;
                ex_fp.rs3 <= rs3;
                ex_fp.funct7 <= i_funct7;
                ex_fp.rs1_dout <= rs1_dout;
                ex_fp.rs2_dout <= rs2_dout;
                ex_fp.rs3_dout <= rs3_dout;
                ex_fp.frm <= i_frm;
            end
        end
    end

    logic [FLEN-1:0] fp_in1;

    logic [1:0] fp_forward_a;
    logic [1:0] fp_forward_b;
    logic [1:0] fp_forward_c;
    
    logic [FLEN-1:0] fp_forward_in1;
    logic [FLEN-1:0] fp_forward_in2;
    logic [FLEN-1:0] fp_forward_in3;

    // choosing between integer rs1 and floating-point rs1
    always @(*) begin
        case (ex_fp.opcode)
            OPCODE_FLW: begin
                fp_in1 = i_int_forward_rs1;
            end
            OPCODE_FSW: begin
                fp_in1 = i_int_forward_rs1;
            end
            OPCODE_FP: begin
                if (ex_fp.funct7 == FP_CVT_SW) begin
                    if ((ex_fp.rs2 == 5'h0) || (ex_fp.rs2 == 5'h1)) begin
                        fp_in1 = i_int_forward_rs1;
                    end else begin
                        fp_in1 = ex_fp.rs1_dout;
                    end
                end else if (ex_fp.funct7 == FP_MVWX) begin
                    if (ex_fp.rs2 == 5'h0) begin
                        fp_in1 = i_int_forward_rs1;
                    end else begin
                        fp_in1 = ex_fp.rs1_dout;
                    end
                end else begin
                    fp_in1 = ex_fp.rs1_dout;
                end
            end
            default: begin
                fp_in1 = ex_fp.rs1_dout;
            end
        endcase
    end

    // FORWARDING UNIT
    floating_point_f_u #(
        .FLEN(32)
    ) fp_f_u (
        .i_opcode           (ex_fp.opcode),
        .i_funct7           (ex_fp.funct7),
        .i_rs1              (ex_fp.rs1),
        .i_rs2              (ex_fp.rs2),
        .i_rs3              (ex_fp.rs3),
        .i_wb_rd            (i_wb_rd),
        .i_wb_reg_write     (i_wb_reg_write),
        .i_wb_fp_reg_write  (i_wb_fp_reg_write),
        .o_forward_a        (fp_forward_a),
        .o_forward_b        (fp_forward_b),
        .o_forward_c        (fp_forward_c)
    );

    // RS1 forwarding source
    always_comb begin
        if (fp_forward_a == WB_DATA) begin
            fp_forward_in1 = i_fp_rd_din;
        end else begin
            fp_forward_in1 = fp_in1;
        end
    end

    // RS2 forwarding source
    always @(*) begin
        if (fp_forward_b == WB_DATA) begin
            fp_forward_in2 = i_fp_rd_din;
        end else begin
            fp_forward_in2 = ex_fp.rs2_dout;
        end
    end

    assign o_fp_forward_in2 = fp_forward_in2;

    // RS3 forwarding source
    always @(*) begin
        if (fp_forward_c == WB_DATA) begin
           fp_forward_in3 = i_fp_rd_din;
        end else begin
            fp_forward_in3 = ex_fp.rs3_dout;
        end
    end

    floating_point_alu #(
        .FLEN           (32)
    ) fp_alu (
        .i_fp_in1       (fp_forward_in1),
        .i_fp_in2       (fp_forward_in2),
        .i_fp_in3       (fp_forward_in3),
        .i_opcode       (ex_fp.opcode),
        .i_funct3       (ex_fp.funct3),
        .i_rs2          (ex_fp.rs2),
        .i_funct7       (ex_fp.funct7),
        .i_frm          (ex_fp.frm),
        .o_fflags       (o_fflags),
        .o_result       (o_fp_result),
        .o_fp_reg_write (o_fp_reg_write)
    );


endmodule