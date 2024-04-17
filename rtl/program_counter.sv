
module program_counter #(
    parameter XLEN = 32,
    parameter RESET_PC = 32'h4000_0000
) (
    input                       i_clk,
    input                       i_reset_n,
    input                       i_pc_write,
    input           [XLEN-1:0]  i_pc_next,
    output  logic   [XLEN-1:0]  o_pc_curr
);

    always_ff @(posedge i_clk or negedge i_reset_n) begin
        if (~i_reset_n) begin
            o_pc_curr <= RESET_PC;
        end else begin
            if (i_pc_write) begin
                o_pc_curr <= i_pc_next;
            end else begin
                o_pc_curr <= o_pc_curr;
            end
        end
    end

endmodule
