
module csr (
    input                       i_clk,
    input                       i_rst_n,
    input           [11:0]      i_csr_addr,       
    input                       i_csr_write,
    input           [31:0]      i_wr_data,  // Reg[rs1] or zext(rs1)
    output  logic   [31:0]      o_rd_data
);

    localparam FFLAGS   = 12'h001;
    localparam FRM      = 12'h002;
    localparam FCSR     = 12'h003;

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

    /* CSR WRITE */
    always_ff @(posedge i_clk or negedge i_rst_n) begin
        if (~i_rst_n) begin
            frm <= 3'b000;  // default: round to nearest, ties to even
            fflags <= '0;   // default: no flags raised
        end else begin
            if (i_csr_write) begin
                case (i_csr_addr)
                    FFLAGS: begin
                        fflags <= i_wr_data[4:0];
                    end
                    FRM: begin
                        frm <= i_wr_data[2:0];
                    end 
                    FCSR: begin
                        frm <= i_wr_data[7:5];
                        fflags <= i_wr_data[4:0];
                    end
                    default: begin
                        frm <= frm;
                        fflags <= fflags;
                    end
                endcase
            end
        end
    end

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

endmodule