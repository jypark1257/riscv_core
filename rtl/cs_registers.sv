
module cs_registers #(
    parameter XLEN = 32
) (
    input                       i_clk,
    input                       i_rst_n,
    input           [11:0]      i_csr_addr,    
    input           [1:0]       i_csr_op,   
    input                       i_csr_write,
    input           [4:0]       i_fflags,
    input           [XLEN-1:0]  i_wr_data,  // Reg[rs1] or zext(rs1)
    output  logic   [XLEN-1:0]  o_rd_data,
    output          [2:0]       o_frm
);
    // FCSR COMPONENTS
    localparam FFLAGS   = 12'h001;
    localparam FRM      = 12'h002;
    localparam FCSR     = 12'h003;

    // CSR OPERATIONS
    localparam CSR_RW = 2'b00;
    localparam CSR_RS = 2'b01;
    localparam CSR_RC = 2'b10;

    logic [XLEN-1:0] wr_data;

    /* Floating-Point Control and Status Register */
    logic [7:0] fcsr;
    logic [2:0] frm;    // rounding mode
    struct packed {
        /* fflags */
        logic nv;   // Invalid Operation
        logic dz;   // Divide by zero
        logic of;   // overflow
        logic uf;   // underflow
        logic nx;   // inexact
    } fflags;

    assign fcsr = {frm, fflags};

    /* CSR READ */ 
    always_comb begin
        case (i_csr_addr)
            FFLAGS: begin
                o_rd_data = {27'b0, fflags};
            end
            FRM: begin
                o_rd_data = {29'b0, frm};
            end 
            FCSR: begin
                o_rd_data = {24'b0, fcsr};
            end
            default: begin
                o_rd_data = '0;
            end
        endcase
    end

    always_comb begin
        case (i_csr_op)
            CSR_RW: begin
                wr_data = i_wr_data;
            end
            CSR_RS: begin   // i_wr_data is a set mask
                wr_data = o_rd_data | i_wr_data;
            end
            CSR_RC: begin   // i_wr_data is a clear mask
                wr_data = o_rd_data & (~i_wr_data);
            end 
            default: begin
                wr_data = i_wr_data;
            end
        endcase
    end

    /* CSR WRITE */
    always_ff @(posedge i_clk or negedge i_rst_n) begin
        if (~i_rst_n) begin
            frm <= 3'b000;  // default: round to nearest, ties to even
            fflags <= '0;   // default: no flags raised
        end else begin
            if (i_csr_write) begin
                if (|i_fflags) begin
                    frm <= frm;
                    fflags <= fflags | i_fflags;
                end else begin
                    case (i_csr_addr)
                        FFLAGS: begin
                            fflags <= wr_data[4:0];
                        end
                        FRM: begin
                            frm <= wr_data[2:0];
                        end 
                        FCSR: begin
                            frm <= wr_data[7:5];
                            fflags <= wr_data[4:0];
                        end
                        default: begin
                            frm <= frm;
                            fflags <= fflags;
                        end
                    endcase
                end
            end
        end
    end

    assign o_frm = frm;

    // DEBUG
    logic [31:0] debug_fcsr;
    logic [31:0] debug_frm;
    logic [31:0] debug_fflags;

    always_comb begin
        debug_fcsr = {24'b0, fcsr};
        debug_frm = {29'b0, frm};
        debug_fflags = {27'b0, fflags};
    end



endmodule