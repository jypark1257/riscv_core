module fp_cmp # (
	parameter sig_width=23,
	parameter exp_width=8,
	parameter ieee_compliance=1
) (
	input  			[sig_width + exp_width:0] a,b,
	input  			zctr,
	output reg		aeqb, altb, agtb, unordered,
	output reg		[sig_width + exp_width:0] z0, z1,
	output reg		[7:0] status0, status1, status0_FEQ, status1_FEQ
);

	wire aeqb_tmp, altb_tmp, agtb_tmp;
	wire [sig_width + exp_width:0] z0_tmp, z1_tmp;
	wire [7:0] status0_tmp, status1_tmp;

	wire [exp_width-1:0] Ea,Eb;
	wire [sig_width-1:0] Fa,Fb;

	assign Ea = a[((exp_width + sig_width) - 1):sig_width];
    assign Eb = b[((exp_width + sig_width) - 1):sig_width];
    assign Fa = a[(sig_width - 1):0];
    assign Fb = b[(sig_width - 1):0]; 

	DW_fp_cmp #(
        .sig_width              (sig_width),
        .exp_width              (exp_width),
        .ieee_compliance        (ieee_compliance)
    ) DW_fpcomp (
        .a                      (a), 
        .b                      (b), 
        .zctr                   (zctr), 
        .aeqb                   (aeqb_tmp), 
        .altb                   (altb_tmp), 
        .agtb                   (agtb_tmp), 
        .unordered              (unordered), 
        .z0                     (z0_tmp), 
        .z1                     (z1_tmp), 
        .status0                (status0_tmp), 
        .status1                (status1_tmp)          
    );

	always @(*) begin
		aeqb = aeqb_tmp;
		altb = altb_tmp;
		agtb = agtb_tmp;
		z0 = z0_tmp;
		z1 = z1_tmp;
		status0 = status0_tmp;
		status1 = status1_tmp;
		status0_FEQ = status0_tmp;
		status1_FEQ = status1_tmp;

		//a=b=0 일 때  +0과 -0 다르게 설정 (+0>-0)
		if ((a[((exp_width + sig_width) - 1):0] == 0) && (b[((exp_width + sig_width) - 1):0] == 0)) begin
			if (a[(exp_width + sig_width)] == b[(exp_width + sig_width)]) begin
        		aeqb = 1;
    		end else begin
        		if(a[(exp_width + sig_width)] == 0) begin	//a is pos zero a>b
            		agtb = 1;
					z0 = a;
					z1 = b;
					status0 = status1_tmp;
					status1 = status0_tmp;
					status0_FEQ = status1_tmp;
					status1_FEQ = status0_tmp;
        		end else begin		//b is pos zero a<b
            		altb = 1;
					z0 = b;
					z1 = a;
        		end
    		end
		end

		//input이 둘 다 NaN 일 때만 output NaN 으로 수정
		if (unordered)	begin	//a or b is NaN
			if (((Ea === ((((1 << (exp_width-1)) - 1) * 2) + 1) && Fa !== 0)&&		// a and b are NaN.
       			 (Eb === ((((1 << (exp_width-1)) - 1) * 2) + 1) && Fb !== 0)))
    		begin
        		aeqb = 0;
    		end else if (Ea === ((((1 << (exp_width-1)) - 1) * 2) + 1) && Fa !== 0) begin  //a is NaN
    			z0 = b;
				z1 = b;
				status0_FEQ[2] = 1;
				status1_FEQ[2] = 1;
				
    		end else begin    //b is NaN
       			z0 = a;
				z1 = a;
				status0_FEQ[2] = 1;
				status1_FEQ[2] = 1;
    		end
		end

	end

endmodule