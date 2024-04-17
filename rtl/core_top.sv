module core_top #(
    parameter XLEN = 32,
    parameter CPU_CLOCK_FREQ = 100_000_000,
    parameter RESET_PC = 32'h4000_0000,
    parameter BAUD_RATE = 115200
) (
    input i_clk,
    input i_rst_n,

    input i_serial_rx,
    output logic o_serial_tx
);

    logic [XLEN-1:0]    instr_addr_q;
    logic [XLEN-1:0]    data_addr_q;

    // MEM I/F
    logic [XLEN-1:0]    instr_addr;
    logic [XLEN-1:0]    instr_data;

    logic [XLEN-1:0]    data_addr;
    logic [XLEN-1:0]    data_rd_data;
    logic [XLEN-1:0]    data_wr_data;
    logic               data_rd_en;
    logic               data_wr_en;
    logic [1:0]         data_mask;

    // RAM I/F
    logic [XLEN-1:0]    ram_instr_data;

    logic [XLEN-1:0]    ram_data_rd_data;
    logic               ram_data_rd_en;

    // ROM I/F
    logic [XLEN-1:0]    rom_instr_data;

    logic [XLEN-1:0]    rom_data_rd_data;
    logic               rom_data_rd_en;

    logic [7:0] data_in;
    logic [7:0] data_out;
    

    core #(
        .RESET_PC       (RESET_PC)
    ) core_0 (
        .i_clk          (i_clk),
        .i_rst_n        (i_rst_n),

        .o_instr_addr   (instr_addr),
        .i_instr_data   (instr_data),

        .o_data_addr    (data_addr),
        .i_data_rd_data (data_rd_data),
        .o_data_wr_data (data_wr_data),
        .o_data_mask    (data_mask),
        .o_data_wr_en   (data_wr_en),

        // UART
        .o_data_out_ready(data_out_ready),
        .o_data_in_valid(data_in_valid),
        .o_data_in(data_in)
    );

    always_ff @(posedge i_clk or negedge i_rst_n) begin
        if (~i_rst_n) begin
            instr_addr_q <= '0;
            data_addr_q <= '0;
        end else begin
            instr_addr_q <= instr_addr;
            data_addr_q <= data_addr;
        end
    end

    // instr. mem map
    always@ (*) begin
        case (instr_addr_q[31:28])
            // ROM
            4'h0: begin
                instr_data = rom_instr_data;
            end
            // RAM
            4'h4: begin
                instr_data = ram_instr_data;
            end
            default: begin
                instr_data = rom_instr_data;
            end
        endcase
    end
    //data read mem map
    always@ (*) begin
        case (data_addr_q[31:28])
            // ROM
            4'h0: begin
                data_rd_data = rom_data_rd_data;
            end
            // RAM
            4'h4: begin
                data_rd_data = ram_data_rd_data;
            end
            // UART
            4'h8: begin
                case (data_addr_q[3:0])
                    //32'h8000_0000, data_out_valid, data_in_ready
                    4'h0: begin
                        data_rd_data = {30'b0, data_out_valid, data_in_ready};
                    end
                    //32'h8000_0004, data_out
                    4'h4: begin
                        data_rd_data = {24'b0, data_out};
                    end
                    default: begin
                        data_rd_data = '0;
                    end
                endcase
            end
            default: begin
                data_rd_data = rom_data_rd_data;
            end
        endcase
    end

    //ram rom_0 (
    //    .i_clk          (i_clk),

    //    .i_instr_addr   (instr_addr),
    //    .o_instr_data   (rom_instr_data),
    //    .i_instr_req    (instr_req),
    //    .o_instr_ack    (rom_instr_ack),

    //    .i_data_addr    (data_addr),
    //    .o_data_rd_data (rom_data_rd_data),
    //    .i_data_wr_data (data_wr_data),
    //    .i_data_size    (data_mask),
    //    .i_data_we      (data_wr_en),
    //    .i_data_req     (data_req),
    //    .o_data_ack     (rom_data_ack)
    //);

    // 4K RAM
    ram #(
        .MEM_DEPTH(4096),
        .MEM_ADDR_WIDTH(12)
    ) ram_0 (
        .i_clk            (i_clk),

        .i_instr_addr   (instr_addr),
        .o_instr_data   (ram_instr_data),

        .i_data_addr    (data_addr),
        .o_data_rd_data (ram_data_rd_data),
        .i_data_wr_data (data_wr_data),
        .i_data_size    (data_mask),
        .i_data_we      (data_wr_en)
    );

    //UART
    uart #(
        .CLOCK_FREQ(CPU_CLOCK_FREQ),
        .BAUD_RATE(BAUD_RATE)
    ) on_chip_uart (
        .clk            (i_clk),
        .reset          (!i_rst_n),

        .data_in        (data_in),
        .data_in_valid  (data_in_valid),
        .data_out_ready (data_out_ready),
        .serial_in      (i_serial_rx),

        .data_in_ready  (data_in_ready),
        .data_out       (data_out),
        .data_out_valid (data_out_valid),
        .serial_out     (o_serial_tx)
    );


endmodule