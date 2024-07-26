module floating_point_rf #(
    parameter FLEN = 32
) (
    input                       i_clk,
    input           [4:0]       i_rs1,
    input           [4:0]       i_rs2,
    input           [4:0]       i_rs3,
    input           [4:0]       i_rd,
    input           [FLEN-1:0]  i_rd_din,
    input                       i_reg_write,
    output          [FLEN-1:0]  o_rs1_dout,
    output          [FLEN-1:0]  o_rs2_dout,
    output          [FLEN-1:0]  o_rs3_dout
);

    logic [FLEN-1:0] rf_data[0:31];

    always_ff @(posedge i_clk) begin
        if (i_reg_write) begin
            rf_data[i_rd] <= i_rd_din;
        end else begin
            rf_data[i_rd] <= rf_data[i_rd];
        end
    end

    // output logic for rs1
    assign o_rs1_dout = (i_reg_write && (i_rs1 == i_rd)) ? i_rd_din : rf_data[i_rs1];

    // output logic for rs2
    assign o_rs2_dout = (i_reg_write && (i_rs2 == i_rd)) ? i_rd_din : rf_data[i_rs2];
    
    // output logic for rs3
    assign o_rs3_dout = (i_reg_write && (i_rs3 == i_rd)) ? i_rd_din : rf_data[i_rs3];

    // regs
    logic   [FLEN-1:0]  reg_x0;
    logic   [FLEN-1:0]  reg_x1;
    logic   [FLEN-1:0]  reg_x2;
    logic   [FLEN-1:0]  reg_x3;
    logic   [FLEN-1:0]  reg_x4;
    logic   [FLEN-1:0]  reg_x5;
    logic   [FLEN-1:0]  reg_x6;
    logic   [FLEN-1:0]  reg_x7;
    logic   [FLEN-1:0]  reg_x8;
    logic   [FLEN-1:0]  reg_x9;
    logic   [FLEN-1:0]  reg_x10;
    logic   [FLEN-1:0]  reg_x11;
    logic   [FLEN-1:0]  reg_x12;
    logic   [FLEN-1:0]  reg_x13;
    logic   [FLEN-1:0]  reg_x14;
    logic   [FLEN-1:0]  reg_x15;
    logic   [FLEN-1:0]  reg_x16;
    logic   [FLEN-1:0]  reg_x17;
    logic   [FLEN-1:0]  reg_x18;
    logic   [FLEN-1:0]  reg_x19;
    logic   [FLEN-1:0]  reg_x20;
    logic   [FLEN-1:0]  reg_x21;
    logic   [FLEN-1:0]  reg_x22;
    logic   [FLEN-1:0]  reg_x23;
    logic   [FLEN-1:0]  reg_x24;
    logic   [FLEN-1:0]  reg_x25;
    logic   [FLEN-1:0]  reg_x26;
    logic   [FLEN-1:0]  reg_x27;
    logic   [FLEN-1:0]  reg_x28;
    logic   [FLEN-1:0]  reg_x29;
    logic   [FLEN-1:0]  reg_x30;
    logic   [FLEN-1:0]  reg_x31;

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