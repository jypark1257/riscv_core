module core_top #(
    parameter XLEN = 32
) (
    input i_clk,
    input i_rst_n
);

    logic [XLEN-1:0]    instr_addr;
    logic [XLEN-1:0]    instr_data;
    logic               instr_req;
    logic               instr_ack;

    logic [XLEN-1:0]    data_addr;
    logic [XLEN-1:0]    data_rd_data;
    logic [XLEN-1:0]    data_wr_data;
    logic [1:0]         data_mask;
    logic               data_rd_en;
    logic               data_wr_en;
    logic               data_req;
    logic               data_ack;

    core core_0 (
        .i_clk           (i_clk),
        .i_rst_n         (i_rst_n),

        .o_instr_addr    (instr_addr),
        .i_instr_data    (instr_data),
        .o_instr_req     (instr_req),
        .i_instr_ack     (instr_ack),

        .o_data_addr     (data_addr),
        .i_data_rd_data  (data_rd_data),
        .o_data_wr_data  (data_wr_data),
        .o_data_mask     (data_mask),
        .o_data_wr_en    (data_wr_en),
        .o_data_req      (data_req),
        .i_data_ack      (data_ack)
    );

    ram ram_0 (
        .i_clk            (i_clk),

        .i_instr_addr   (instr_addr),
        .o_instr_data   (instr_data),
        .i_instr_req    (instr_req),
        .o_instr_ack    (instr_ack),

        .i_data_addr    (data_addr),
        .o_data_rd_data (data_rd_data),
        .i_data_wr_data (data_wr_data),
        .i_data_size    (data_mask),
        .i_data_we      (data_wr_en),
        .i_data_req     (data_req),
        .o_data_ack     (data_ack)
    );


endmodule