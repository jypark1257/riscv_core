module register_file #(
    parameter XLEN = 32
) (
    input                       i_clk,
    input                       i_rst_n,
    input           [4:0]       i_rs1,
    input           [4:0]       i_rs2,
    input           [4:0]       i_rd,
    input           [XLEN-1:0]  i_rd_din,
    input                       i_reg_write,
    output          [XLEN-1:0]  o_rs1_dout,
    output          [XLEN-1:0]  o_rs2_dout
);

    logic [XLEN-1:0] rf_data[0:31];

    int i;
    always_ff @(posedge i_clk or negedge i_rst_n) begin
        if (~i_rst_n) begin
            for (i = 0; i < 32; i = i + 1) begin
                rf_data[i] <= '0;
            end
        end else begin
            if (i_reg_write) begin
                if(i_rd == '0) begin
                    rf_data[i_rd] <= '0;            // hard-wired ZERO
                end else begin
                    rf_data[i_rd] <= i_rd_din;
                end
            end else begin
                rf_data[i_rd] <= rf_data[i_rd];
            end
        end
    end

    // output logic for rs1
    assign o_rs1_dout = (i_reg_write && (i_rs1 == i_rd)) ? i_rd_din : rf_data[i_rs1];

    // output logic for rs2
    assign o_rs2_dout = (i_reg_write && (i_rs2 == i_rd)) ? i_rd_din : rf_data[i_rs2];
    
    // regs
    logic   [XLEN-1:0]  reg_x0;
    logic   [XLEN-1:0]  reg_x1;
    logic   [XLEN-1:0]  reg_x2;
    logic   [XLEN-1:0]  reg_x3;
    logic   [XLEN-1:0]  reg_x4;
    logic   [XLEN-1:0]  reg_x5;
    logic   [XLEN-1:0]  reg_x6;
    logic   [XLEN-1:0]  reg_x7;
    logic   [XLEN-1:0]  reg_x8;
    logic   [XLEN-1:0]  reg_x9;
    logic   [XLEN-1:0]  reg_x10;
    logic   [XLEN-1:0]  reg_x11;
    logic   [XLEN-1:0]  reg_x12;
    logic   [XLEN-1:0]  reg_x13;
    logic   [XLEN-1:0]  reg_x14;
    logic   [XLEN-1:0]  reg_x15;
    logic   [XLEN-1:0]  reg_x16;
    logic   [XLEN-1:0]  reg_x17;
    logic   [XLEN-1:0]  reg_x18;
    logic   [XLEN-1:0]  reg_x19;
    logic   [XLEN-1:0]  reg_x20;
    logic   [XLEN-1:0]  reg_x21;
    logic   [XLEN-1:0]  reg_x22;
    logic   [XLEN-1:0]  reg_x23;
    logic   [XLEN-1:0]  reg_x24;
    logic   [XLEN-1:0]  reg_x25;
    logic   [XLEN-1:0]  reg_x26;
    logic   [XLEN-1:0]  reg_x27;
    logic   [XLEN-1:0]  reg_x28;
    logic   [XLEN-1:0]  reg_x29;
    logic   [XLEN-1:0]  reg_x30;
    logic   [XLEN-1:0]  reg_x31;

    always_comb begin
        reg_x0  = rf_data[0];
        reg_x1  = rf_data[1];
        reg_x2  = rf_data[2];
        reg_x3  = rf_data[3];
        reg_x4  = rf_data[4];
        reg_x5  = rf_data[5];
        reg_x6  = rf_data[6];
        reg_x7  = rf_data[7];
        reg_x8  = rf_data[8];
        reg_x9  = rf_data[9];
        reg_x10 = rf_data[10];
        reg_x11 = rf_data[11];
        reg_x12 = rf_data[12];
        reg_x13 = rf_data[13];
        reg_x14 = rf_data[14];
        reg_x15 = rf_data[15];
        reg_x16 = rf_data[16];
        reg_x17 = rf_data[17];
        reg_x18 = rf_data[18];
        reg_x19 = rf_data[19];
        reg_x20 = rf_data[20];
        reg_x21 = rf_data[21];
        reg_x22 = rf_data[22];
        reg_x23 = rf_data[23];
        reg_x24 = rf_data[24];
        reg_x25 = rf_data[25];
        reg_x26 = rf_data[26];
        reg_x27 = rf_data[27];
        reg_x28 = rf_data[28];
        reg_x29 = rf_data[29];
        reg_x30 = rf_data[30];
        reg_x31 = rf_data[31];
    end


endmodule