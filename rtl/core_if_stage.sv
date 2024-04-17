
module core_if_stage #(
    parameter XLEN = 32,
    parameter RESET_PC = 32'h4000_0000
) (
    input                       i_clk,
    input                       i_rst_n,
    input                       i_pc_write,
    input                       i_branch_taken,
    input   [XLEN-1:0]          i_pc_branch,
    output  logic   [XLEN-1:0]  o_pc_curr,
    output  logic   [XLEN-1:0]  o_pc_instr
);

    // Program counter
    logic [XLEN-1:0] pc_next;
    logic [XLEN-1:0] pc_plus_4;
    logic [XLEN-1:0] pc_branch_plus_4;

    assign pc_plus_4 = o_pc_curr + 4;
    assign pc_branch_plus_4 = i_pc_branch + 4;

    assign pc_next = (i_branch_taken) ? pc_branch_plus_4 : pc_plus_4;

    program_counter #(
        .XLEN       (XLEN),
        .RESET_PC   (RESET_PC)
    ) pc (
        .i_clk      (i_clk),
        .i_reset_n  (i_rst_n),
        .i_pc_write (i_pc_write),
        .i_pc_next  (pc_next),
        .o_pc_curr  (o_pc_curr)
    );

    // --------------------------------------------------------

    always_ff @(posedge i_clk or negedge i_rst_n) begin
        if (~i_rst_n) begin
            o_pc_instr <= '0;
        end else begin
            if (i_branch_taken) begin
                o_pc_instr <= i_pc_branch;
            end else begin
                o_pc_instr <= o_pc_curr;
            end
        end
    end

endmodule