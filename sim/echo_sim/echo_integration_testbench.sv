module uart_com #(
    parameter XLEN = 32,
    parameter CPU_CLOCK_FREQ = 1_000_000,
    parameter RESET_PC = 32'h4000_0000,
    parameter BAUD_RATE = 115200
) (
    input i_clk,
    input i_rst_n
);
    // UART Signals between the on-chip and off-chip UART
    logic SERIAL_RX, SERIAL_TX;

    // Off-chip UART Ready/Valid interface
    logic   [7:0] data_in;
    logic         data_in_valid;
    logic         data_in_ready;
    logic   [7:0] data_out;
    logic         data_out_valid;
    logic         data_out_ready;

    core_top #(
        .CPU_CLOCK_FREQ(CPU_CLOCK_FREQ)
    ) top (
        .i_clk(i_clk),
        .i_rst_n(i_rst_n),
        .SERIAL_RX(SERIAL_RX),
        .SERIAL_TX(SERIAL_TX)
    );

    // Instantiate the off-chip UART
    uart # (
        .CLOCK_FREQ(CPU_CLOCK_FREQ)
    ) off_chip_uart (
        .clk(i_clk),
        .reset(!i_rst_n),
        .data_in(data_in),
        .data_in_valid(data_in_valid),
        .data_in_ready(data_in_ready),
        .data_out(data_out),
        .data_out_valid(data_out_valid),
        .data_out_ready(data_out_ready),
        .serial_in(SERIAL_TX),
        .serial_out(SERIAL_RX)
    );

endmodule
