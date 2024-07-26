module floating_point_alu #(
    parameter FLEN = 32
) (
    input           [FLEN-1:0]  i_fp_in1,
    input           [FLEN-1:0]  i_fp_in2,
    input           [FLEN-1:0]  i_fp_in3,
    input           [6:0]       i_opcode,
    input           [4:0]       i_rs2,
    input           [2:0]       i_funct3,
    input           [6:0]       i_funct7,
    input           [2:0]       i_frm,
    output logic    [4:0]       o_fflags,
    output logic    [FLEN-1:0]  o_result,
    output logic                o_fp_reg_write
);

    //OPCODE
    localparam OPCODE_FP = 7'b1010011;
    localparam OPCODE_FMADD = 7'b1000011;
    localparam OPCODE_FMSUB = 7'b1000111;
    localparam OPCODE_FNMSUB = 7'b1001011;
    localparam OPCODE_FNMADD = 7'b1001111;
    localparam OPCODE_LOAD = 7'b0000111;
    localparam OPCODE_STORE =  7'b0100111;

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

    logic [2:0] rnd;

    logic [FLEN-1:0] add_result;
    logic [FLEN-1:0] sub_result;
    logic [FLEN-1:0] mul_result;
    logic [FLEN-1:0] div_result;
    logic [FLEN-1:0] sqrt_result;
    logic [FLEN-1:0] fmadd_result;
    logic [FLEN-1:0] fmsub_result;
    logic [FLEN-1:0] fnmsub_result;
    logic [FLEN-1:0] fnmadd_result;
    logic [FLEN-1:0] max_result;
    logic [FLEN-1:0] min_result;
    logic [FLEN-1:0] cvtsw_result;
    logic [FLEN-1:0] cvtswu_result;
    logic [FLEN-1:0] cvtws_result;
    logic [33-1:0] cvtwus_result;
    logic [FLEN-1:0] fsgnj_result;
    logic [FLEN-1:0] fsgnjn_result;
    logic [FLEN-1:0] fsgnjx_result;
    logic [9:0] calss_result;

    logic [7:0] add_status;
    logic [7:0] sub_status;
    logic [7:0] mul_status;
    logic [7:0] div_status;
    logic [7:0] sqrt_status;
    logic [7:0] fmadd_status;
    logic [7:0] fmsub_status;
    logic [7:0] min_status;
    logic [7:0] max_status;
    logic [7:0] minmax_status;
    logic [7:0] comp_status;
    logic [7:0] cvtsw_status;
    logic [7:0] cvtswu_status;
    logic [7:0] cvtws_status;
    logic [7:0] cvtwus_status;
    logic [7:0] feq_status0;
    logic [7:0] feq_status1;
    logic [7:0] feq_status;

    logic aeqb;
    logic altb;
    logic agtb;
    logic aleb;

    logic [FLEN-1:0] tmp_result;

    logic [FLEN-1:0] tmp_cvtwus_result;
    
    //rounding mode modification
    always_comb begin   
        if (i_funct3 == 3'b010) begin
            rnd = 3'b011;
        end else if (i_funct3 == 3'b011) begin
            rnd = 3'b010;
        end else if (i_funct3 == 3'b101) begin
            rnd = 3'b110;
        end else if (i_funct3 == 3'b111) begin
            rnd = i_frm;
        end else begin
            rnd = i_funct3;
        end
    end

    DW_fp_add #(
        .sig_width              (23),
        .exp_width              (8),
        .ieee_compliance        (1)
    ) fp_add (
        .a                      (i_fp_in1), 
        .b                      (i_fp_in2), 
        .rnd                    (rnd), 
        .z                      (add_result), 
        .status                 (add_status)            
    );
    
    DW_fp_sub #(
        .sig_width              (23),
        .exp_width              (8),
        .ieee_compliance        (1)
    ) fp_sub (
        .a                      (i_fp_in1), 
        .b                      (i_fp_in2), 
        .rnd                    (rnd), 
        .z                      (sub_result), 
        .status                 (sub_status)            
    );

    DW_fp_mult #(
        .sig_width              (23),
        .exp_width              (8),
        .ieee_compliance        (1)
    ) fp_mul (
        .a                      (i_fp_in1), 
        .b                      (i_fp_in2), 
        .rnd                    (rnd), 
        .z                      (mul_result), 
        .status                 (mul_status)            
    );

    DW_fp_div #(
        .sig_width              (23),
        .exp_width              (8),
        .ieee_compliance        (1),
        .faithful_round         (0)
    ) fp_div (
        .a                      (i_fp_in1), 
        .b                      (i_fp_in2), 
        .rnd                    (rnd), 
        .z                      (div_result), 
        .status                 (div_status)            
    );

    DW_fp_sqrt #(
        .sig_width              (23),
        .exp_width              (8),
        .ieee_compliance        (1)
    ) fp_sqrt (
        .a                      (i_fp_in1), 
        .rnd                    (rnd), 
        .z                      (sqrt_result), 
        .status                 (sqrt_status)            
    );

    DW_fp_add #(
        .sig_width              (23),
        .exp_width              (8),
        .ieee_compliance        (1)
    ) fmadd (
        .a                      (mul_result), 
        .b                      (i_fp_in3), 
        .rnd                    (rnd), 
        .z                      (fmadd_result), 
        .status                 (fmadd_status)            
    );

    DW_fp_sub #(
        .sig_width              (23),
        .exp_width              (8),
        .ieee_compliance        (1)
    ) fmsub (
        .a                      (mul_result), 
        .b                      (i_fp_in3), 
        .rnd                    (rnd), 
        .z                      (fmsub_result), 
        .status                 (fmsub_status)            
    );

    fp_cmp #(
        .sig_width              (23),
        .exp_width              (8),
        .ieee_compliance        (1)
    ) fpcomp (
        .a                      (i_fp_in1), 
        .b                      (i_fp_in2), 
        .zctr                   (1'b1), 
        .aeqb                   (aeqb), 
        .altb                   (altb), 
        .agtb                   (agtb), 
        .unordered              (), 
        .z0                     (max_result), 
        .z1                     (min_result), 
        .status0                (max_status), 
        .status1                (min_status), 
        .status0_FEQ            (feq_status0), 
        .status1_FEQ            (feq_status1)          
    );

    floating_point_classify fpclass (
	    .i_fp_in                (i_fp_in1),
	    .o_class                (calss_result)
    );

    DW_fp_flt2i #(
        .sig_width              (23),        
        .exp_width              (8),         
        .isize                  (32),            
        .ieee_compliance        (1)
    ) fpcvt_ws (
        .a                      (i_fp_in1), 
        .rnd                    (rnd), 
        .z                      (cvtws_result), 
        .status                 (cvtws_status)
    );

    DW_fp_flt2i #(
        .sig_width              (23),        
        .exp_width              (8),         
        .isize                  (33),            
        .ieee_compliance        (1)
    ) fpcvt_wus (
        .a                      (i_fp_in1), 
        .rnd                    (rnd), 
        .z                      (tmp_cvtwus_result), 
        .status                 (cvtwus_status)
    );

    DW_fp_i2flt #(
        .sig_width              (23),        
        .exp_width              (8),         
        .isize                  (32),            
        .isign                  (0)
    ) fpcvt_swu (
        .a                      (i_fp_in1), 
        .rnd                    (rnd), 
        .z                      (cvtswu_result), 
        .status                 (cvtswu_status)
    );

    DW_fp_i2flt #(
        .sig_width              (23),        
        .exp_width              (8),         
        .isize                  (32),            
        .isign                  (1)
    ) fpcvt_sw (
        .a                      (i_fp_in1), 
        .rnd                    (rnd), 
        .z                      (cvtsw_result), 
        .status                 (cvtsw_status)
    );

    assign fnmsub_result[30:0] = fmsub_result[30:0];
    assign fnmsub_result[31] = ~fmsub_result[31];
    assign fnmadd_result[30:0] = fmadd_result[30:0];
    assign fnmadd_result[31] = ~fmadd_result[31];

    assign aleb = (aeqb || altb) ? 1 : 0 ;

    assign cvtwus_result = i_fp_in1[31] ? 33'b0 : tmp_cvtwus_result ;
    //assign cvtwus_status = cvtws_status ;

    assign fsgnj_result = {i_fp_in2[31], i_fp_in1[30:0]};
    assign fsgnjn_result = {(~i_fp_in2[31]), i_fp_in1[30:0]};
    assign fsgnjx_result = {(i_fp_in2[31]^i_fp_in1[31]), i_fp_in1[30:0]};

    assign minmax_status = min_status & max_status;
    assign comp_status = min_status | max_status;
    assign feq_status = feq_status0 | feq_status1;

    //always_comb begin
    always @(*) begin
        if (i_opcode == OPCODE_FMADD) begin
            tmp_result = fmadd_result;
            o_fflags = {fmadd_status[2], fmadd_status[7], fmadd_status[4], fmadd_status[3], fmadd_status[5]};
            o_fp_reg_write = 1;
        end else if (i_opcode == OPCODE_FMSUB) begin
            tmp_result = fmsub_result;
            o_fflags = {fmsub_status[2], fmsub_status[7], fmsub_status[4], fmsub_status[3], fmsub_status[5]};
            o_fp_reg_write = 1;
        end else if (i_opcode == OPCODE_FNMSUB) begin
            tmp_result = fnmsub_result;
            o_fflags = {fmsub_status[2], fmsub_status[7], fmsub_status[4], fmsub_status[3], fmsub_status[5]}; 
            o_fp_reg_write = 1;
        end else if (i_opcode == OPCODE_FNMADD) begin
            tmp_result = fnmadd_result;
            o_fflags = {fmadd_status[2], fmadd_status[7], fmadd_status[4], fmadd_status[3], fmadd_status[5]}; 
            o_fp_reg_write = 1;
        end else if (i_opcode == OPCODE_FP) begin
            case (i_funct7)
                FP_ADD: begin
                    tmp_result = add_result;
                    o_fflags = {add_status[2], add_status[7], add_status[4], add_status[3], add_status[5]};
                    o_fp_reg_write = 1;
                end
                FP_SUB: begin
                    tmp_result = sub_result;
                    o_fflags = {sub_status[2], sub_status[7], sub_status[4], sub_status[3], sub_status[5]};
                    o_fp_reg_write = 1;
                end
                FP_MUL: begin
                    tmp_result = mul_result;
                    o_fflags = {mul_status[2], mul_status[7], mul_status[4], mul_status[3], mul_status[5]};
                    o_fp_reg_write = 1;
                end
                FP_DIV: begin
                    tmp_result = div_result;
                    o_fflags = {div_status[2], div_status[7], div_status[4], div_status[3], div_status[5]};
                    o_fp_reg_write = 1;
                end
                FP_SQRT: begin
                    tmp_result = sqrt_result;
                    o_fflags = {sqrt_status[2], sqrt_status[7], sqrt_status[4], sqrt_status[3], sqrt_status[5]};
                    o_fp_reg_write = 1;
                end
                FP_MINMAX: begin
                    if (i_funct3 == 3'b000) begin   //min
                        tmp_result = min_result;
                        if (((i_fp_in1[30:23] == 8'hFF) && (i_fp_in1[22] == 1'b0) && (|i_fp_in1[21:0])) || 
                            ((i_fp_in2[30:23] == 8'hFF) && (i_fp_in2[22] == 1'b0) && (|i_fp_in2[21:0]))) begin
                            o_fflags = {1'b1, 1'b0, minmax_status[4], minmax_status[3], minmax_status[5]};
                        end else begin
                            o_fflags = {1'b0, 1'b0, minmax_status[4], minmax_status[3], minmax_status[5]};
                        end
                        o_fp_reg_write = 1;
                    end else begin  //max
                        tmp_result = max_result;
                        if (((i_fp_in1[30:23] == 8'hFF) && (i_fp_in1[22] == 1'b0) && (|i_fp_in1[21:0])) || 
                            ((i_fp_in2[30:23] == 8'hFF) && (i_fp_in2[22] == 1'b0) && (|i_fp_in2[21:0]))) begin
                            o_fflags = {1'b1, 1'b0, minmax_status[4], minmax_status[3], minmax_status[5]};
                        end else begin
                            o_fflags = {1'b0, 1'b0, minmax_status[4], minmax_status[3], minmax_status[5]};
                        end
                        o_fp_reg_write = 1;
                    end
                end
                FP_COMP: begin
                    if (i_funct3 == 3'b010) begin   //FEQ
                        tmp_result = {31'b0, aeqb};
                        o_fp_reg_write = 0;
                        o_fflags = {feq_status[2], 1'b0, feq_status[4], feq_status[3], feq_status[5]};
                        if ((i_fp_in1[22] == 1'b0) && (|i_fp_in1[21:0])) begin
                            o_fflags = {feq_status[2], 1'b0, feq_status[4], feq_status[3], feq_status[5]};
                        end else begin
                            o_fflags = {1'b0, 1'b0, feq_status[4], feq_status[3], feq_status[5]};
                        end
                    end else if (i_funct3 == 3'b001) begin  //FLT
                        tmp_result = {31'b0, altb};
                        o_fflags = {comp_status[2], 1'b0, comp_status[4], comp_status[3], comp_status[5]};
                        o_fp_reg_write = 0;
                    end else begin      //FLE
                        tmp_result = {31'b0, aleb};
                        o_fflags = {comp_status[2], 1'b0, comp_status[4], comp_status[3], comp_status[5]};
                        o_fp_reg_write = 0;
                    end
                end
                // jiyong: i_fp_in2 -> i_rs2
                FP_CVT_SW: begin
                    if (i_rs2 == 5'b0) begin    //FCVT.S.W
                        tmp_result = cvtsw_result;
                        o_fflags = {cvtsw_status[2], 1'b0, cvtsw_status[4], cvtsw_status[3], cvtsw_status[5]};
                        o_fp_reg_write = 1;
                    end else begin    //FCVT.S.WU
                        tmp_result = cvtswu_result;
                        o_fflags = cvtswu_status;
                        o_fp_reg_write = 1;
                    end
                end
                FP_CVT_WS: begin
                    if (i_rs2 == 5'b0) begin    //FCVT.W.S
                    
                        if ((i_fp_in1[30:23] == 8'hFF) && (|i_fp_in1[21:0])) begin
                            tmp_result = 32'h7FFFFFFF;
                        end else begin
                            tmp_result = cvtws_result;
                        end

                        if (cvtws_status[6]) begin
                            o_fflags = {cvtws_status[6], 4'b0};
                        end else begin
                            o_fflags = {4'b0, cvtws_status[5]};
                        end
                        
                        // TEMP
                        // if (cvtws_status[6] & cvtws_status[5]) begin
                        //     o_fflags = {1'b1, 1'b0, cvtws_status[4], cvtws_status[3], 1'b0};
                        // end else begin
                        //     o_fflags = {cvtws_status[2], 1'b0, cvtws_status[4], cvtws_status[3], cvtws_status[5]};
                        // end
                        o_fp_reg_write = 0;
                    end else begin      //FCVT.WU.S
                        if ((i_fp_in1[30:23] == 8'hFF) && (|i_fp_in1[21:0])) begin
                            tmp_result = 32'hFFFFFFFF;
                        end else begin
                            tmp_result = cvtwus_result[31:0];
                        end
                        if (i_fp_in1[31]) begin
                            if (cvtwus_status[6]) begin
                                o_fflags = {i_fp_in1[31], 4'b0};
                            end else if (cvtwus_status[0] & cvtwus_status[5]) begin
                                o_fflags = {4'b0, 1'b1};
                            end else begin
                                o_fflags = {i_fp_in1[31], 4'b0};
                            end
                        end else begin
                            o_fflags = {4'b0, cvtwus_status[5]};
                        end
                        // TEMP ??
                        // if (i_fp_in1[31]) begin
                        //     o_fflags = {1'b1, 1'b0, cvtwus_status[4], cvtwus_status[3], 1'b0};
                        // end else begin
                        //     o_fflags = {cvtwus_status[2], 1'b0, cvtwus_status[4], cvtwus_status[3], cvtwus_status[5]};
                        // end
                        o_fp_reg_write = 0;
                    end
                end
                FP_SGNJ: begin
                    if (i_funct3 == 3'b000) begin   //FSGNJ
                        tmp_result = fsgnj_result;
                        o_fflags = 5'b0;
                        o_fp_reg_write = 1;
                    end else if (i_funct3 == 3'b001) begin      //FSGNJN
                        tmp_result = fsgnjn_result;
                        o_fflags = 5'b0;
                        o_fp_reg_write = 1;
                    end else begin      //FSGNJX
                        tmp_result = fsgnjx_result;   
                        o_fflags = 5'b0;
                        o_fp_reg_write = 1;
                    end
                end
                FP_CLASS: begin
                    if(i_funct3 == 3'b001) begin   //classify
                        tmp_result = calss_result;
                        o_fflags = 5'b0;
                        o_fp_reg_write = 0;
                    end else begin  //FMV.X.W
                        tmp_result = i_fp_in1;
                        o_fflags = 5'b0;
                        o_fp_reg_write = 0;
                    end
                end
                FP_MVWX: begin      //FMV.W.X
                    tmp_result = i_fp_in1;
                    o_fflags = 5'b0;
                    o_fp_reg_write = 1;
                end
            endcase
        end else if (i_opcode == OPCODE_LOAD) begin
            tmp_result = 32'b0;
            o_fflags = 5'b0;
            o_fp_reg_write = 1;
        end else if (i_opcode == OPCODE_STORE) begin
            tmp_result = 32'b0;
            o_fflags = 5'b0;
            o_fp_reg_write = 0;
        end else begin
            tmp_result = 32'b0;
            o_fflags = 5'b0;
            o_fp_reg_write = 0;
        end  

        //canonical NaN으로 변환
        if ((tmp_result[30:23] === 8'b11111111) && (tmp_result[22:0] !== 0)) begin
            case (i_funct7)
                // the payloads of non-canonical NaNs are preserved when MV
                FP_CLASS: begin
                    o_result = tmp_result;
                end
                FP_MVWX: begin
                    o_result = tmp_result;
                end
                FP_CVT_WS: begin
                    o_result = tmp_result;
                end
                FP_CLASS: begin         // FP_CLASS 중복
                    o_result = tmp_result;
                end
                // canonical-NaN
                default: begin
                    o_result = 32'h7fc00000;
                end
            endcase
        end else begin
            o_result = tmp_result;
        end
    end






















endmodule