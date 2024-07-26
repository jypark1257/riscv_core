module dp_ram #(
    parameter MEM_DEPTH = 4096,
    parameter MEM_ADDR_WIDTH = 12
) (
    input                                   i_clk,

    input           [MEM_ADDR_WIDTH-1:0]    i_addr_a,
    input                                   i_we_a,
    input           [1:0]                   i_size_a,
    input           [31:0]                  i_din_a,
    output  logic   [31:0]                  o_dout_a,

    input           [MEM_ADDR_WIDTH-1:0]    i_addr_b,
    input                                   i_we_b,
    input           [1:0]                   i_size_b,
    input           [31:0]                  i_din_b,
    output  logic   [31:0]                  o_dout_b
);

    localparam SIZE_BYTE        = 2'b00;
    localparam SIZE_HALF_WORD   = 2'b01;

    //initial begin
    //    $readmemh("/home/pjy-wsl/riscv_core/rtl/mem.hex", temp_mem);
    //    for(int i = 0; i < (MEM_DEPTH>>2); i=i+1) begin 
    //        {mem[(i*4)+3], mem[(i*4)+2], mem[(i*4)+1], mem[(i*4)]} = temp_mem[i];
    //    end
    //end


    logic [7:0] mem[MEM_DEPTH];
    logic [31:0] temp_mem[MEM_DEPTH>>2];
    // read operation
    always_ff @(posedge i_clk) begin
        o_dout_a <= {mem[i_addr_a+3], mem[i_addr_a+2], mem[i_addr_a+1], mem[i_addr_a]};
        o_dout_b <= {mem[i_addr_b+3], mem[i_addr_b+2], mem[i_addr_b+1], mem[i_addr_b]};
    end

    logic [31:0] din_a_sized;
    logic [31:0] din_b_sized;

    always @(*) begin   
        case (i_size_a)
            SIZE_BYTE: begin
                din_a_sized = {24'b0, i_din_a[7:0]}; 
            end 
            SIZE_HALF_WORD: begin
                din_a_sized = {16'b0, i_din_a[15:0]}; 
             end
            default: begin
                din_a_sized = i_din_a;
            end
        endcase   
        case (i_size_b)
            SIZE_BYTE: begin
                din_b_sized = {24'b0, i_din_b[7:0]}; 
            end 
            SIZE_HALF_WORD: begin
                din_b_sized = {16'b0, i_din_b[15:0]}; 
             end
            default: begin
                din_b_sized = i_din_b;
            end
        endcase
    end

    // write operation
    always_ff @(posedge i_clk) begin
        if (i_we_a) begin
            case (i_size_a)
                SIZE_BYTE: begin
                    mem[i_addr_a] <= i_din_a[7:0]; 
                end 
                SIZE_HALF_WORD: begin
                    mem[i_addr_a+1] <= i_din_a[15:8]; 
                    mem[i_addr_a] <= i_din_a[7:0];
                 end
                default: begin
                    mem[i_addr_a+3] <= i_din_a[31:24]; 
                    mem[i_addr_a+2] <= i_din_a[23:16];
                    mem[i_addr_a+1] <= i_din_a[15:8]; 
                    mem[i_addr_a] <= i_din_a[7:0];
                end
            endcase
        end else begin
            mem[i_addr_a+3] <= mem[i_addr_a+3]; 
            mem[i_addr_a+2] <= mem[i_addr_a+2];
            mem[i_addr_a+1] <= mem[i_addr_a+1]; 
            mem[i_addr_a] <= mem[i_addr_a];
        end
        if (i_we_b) begin
            case (i_size_b)
                SIZE_BYTE: begin
                    mem[i_addr_b] <= i_din_b[7:0]; 
                end 
                SIZE_HALF_WORD: begin
                    mem[i_addr_b+1] <= i_din_b[15:8]; 
                    mem[i_addr_b] <= i_din_b[7:0];
                 end
                default: begin
                    mem[i_addr_b+3] <= i_din_b[31:24]; 
                    mem[i_addr_b+2] <= i_din_b[23:16];
                    mem[i_addr_b+1] <= i_din_b[15:8]; 
                    mem[i_addr_b] <= i_din_b[7:0];
                end
            endcase
        end else begin
            mem[i_addr_b+3] <= mem[i_addr_b+3]; 
            mem[i_addr_b+2] <= mem[i_addr_b+2];
            mem[i_addr_b+1] <= mem[i_addr_b+1]; 
            mem[i_addr_b] <= mem[i_addr_b];
        end
    end
endmodule