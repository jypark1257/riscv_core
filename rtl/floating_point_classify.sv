module floating_point_classify (
	input 	     [32-1:0] i_fp_in,
	output logic [10-1:0] o_class
);

	logic S_in;		
	logic [8-1:0] E_in;
	logic [23-1:0] F_in;

	assign S_in = i_fp_in[31];
	assign E_in = i_fp_in[30:23];
	assign F_in = i_fp_in[22:0];

	//always_comb begin
	always @(*) begin
		o_class = 0;

		if ((E_in == 8'b1111_1111)) begin		
			if ((F_in == 0)) begin
				if (S_in == 0) begin
					o_class[7] = 1;		//pos infinite
				end else begin
					o_class[0] = 1;		//neg infinite
				end
			end else begin
				if (F_in[22] == 1) begin
					o_class[9] = 1;		//quiet NaN
				end else begin
					o_class[8] = 1;		//signaling NaN
				end
			end
		end else if ((E_in == 0)) begin
			if ((F_in == 0)) begin
				if (S_in == 0) begin
					o_class[4] = 1;		//pos zero
				end else begin
					o_class[3] = 1;		//neg zero
				end
			end else begin
				if (S_in == 0) begin
					o_class[5] = 1;		//pos sub
				end else begin
					o_class[2] = 1;		//neg sub
				end
			end
		end else begin
			if (S_in == 0) begin
				o_class[6] = 1;		//pos norm
			end else begin
				o_class[1] = 1;		//neg norm
			end
		end
	end
endmodule
