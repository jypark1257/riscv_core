module main_control_unit (
    input           [6:0]   i_opcode,
    input           [2:0]   i_funct3,
    output  logic           o_mem_read,
    output  logic           o_mem_write,
    output  logic           o_reg_write,
    output  logic   [1:0]   o_mem_to_reg,
    output  logic   [1:0]   o_d_size,
    output  logic           o_d_unsigned
);

    // OPCODES 
    localparam OPCODE_R = 7'b01_100_11;
    localparam OPCODE_I = 7'b00_100_11;
    localparam OPCODE_STORE = 7'b01_000_11;
    localparam OPCODE_LOAD = 7'b00_000_11;
    localparam OPCODE_JALR = 7'b11_001_11;
    localparam OPCODE_JAL = 7'b11_01111;
    localparam OPCODE_AUIPC = 7'b00_101_11;
    localparam OPCODE_LUI = 7'b01_101_11;
    localparam OPCODE_SYSTEM = 7'b11_100_11;         // ECALL, EBREAK
    localparam OPCODE_CUSTOM_0 = 7'b00_010_11;
    localparam OPCODE_CUSTON_1 = 7'b01_010_11;
    localparam OPCODE_CUSTON_2 = 7'b10_110_11;  // custom / rv128
    localparam OPCODE_CUSTON_3 = 7'b11_110_11;  // custom / rv128

    // SIGNED LOAD, STORE
    localparam FUNCT3_BYTE = 3'b000;
    localparam FUNCT3_HALF = 3'b001;
    localparam FUNCT3_WORD = 3'b010;

    // UNSIGNED LOAD FUNCT3
    localparam FUNCT3_BYTE_U = 3'b100;
    localparam FUNCT3_HALF_U = 3'b101;

    // SIZES
    localparam SIZE_HALF = 2'b01;
    localparam SIZE_WORD = 2'b10;

    // REGISTER SOURCE
    localparam SRC_ALU = 2'b00;
    localparam SRC_DMEM = 2'b01;
    localparam SRC_PC_PLUS_4 = 2'b10;
    localparam SRC_IMM = 2'b11;

    always_comb begin
        o_mem_read = '0;
        o_mem_write = '0;
        o_reg_write = '0;
        o_d_size = '0;
        o_d_unsigned = '0;
        o_mem_to_reg = '0;

        case (i_opcode)
            OPCODE_R: begin
                o_reg_write = 1'b1;
                o_mem_to_reg = SRC_ALU;
            end
            OPCODE_I: begin
                o_reg_write = 1'b1;
                o_mem_to_reg = SRC_ALU;
            end
            OPCODE_STORE: begin
                o_mem_write = 1'b1;
                case (i_funct3)
                    FUNCT3_BYTE: begin
                        o_d_size = 2'b00;
                    end
                    FUNCT3_HALF: begin
                        o_d_size = 2'b01;
                    end
                    FUNCT3_WORD: begin
                        o_d_size = 2'b10;
                    end
                    default: begin
                        o_d_size = '0;
                    end
                endcase
            end
            OPCODE_LOAD: begin
                o_reg_write = 1'b1;
                o_mem_read = 1'b1;
                o_mem_to_reg = SRC_DMEM;
                case (i_funct3)
                    FUNCT3_BYTE: begin
                        o_d_size = 2'b00;
                    end
                    FUNCT3_HALF: begin
                        o_d_size = 2'b01;
                    end
                    FUNCT3_WORD: begin
                        o_d_size = 2'b10;
                    end
                    FUNCT3_BYTE_U: begin
                        o_d_size = 2'b00;
                        o_d_unsigned = 1'b1;
                    end
                    FUNCT3_HALF_U: begin
                        o_d_size = 2'b01;
                        o_d_unsigned = 1'b1;
                    end 
                    default: begin
                        o_d_size = '0;
                        o_d_unsigned = '0;
                    end
                endcase
            end
            OPCODE_JALR: begin
                o_reg_write = 1'b1;
                o_mem_to_reg = SRC_PC_PLUS_4;
            end
            OPCODE_JAL: begin
                o_reg_write = 1'b1;
                o_mem_to_reg = SRC_PC_PLUS_4;
            end
            OPCODE_AUIPC: begin
                o_reg_write = 1'b1;
                o_mem_to_reg = SRC_ALU;
            end
            OPCODE_LUI: begin
                o_reg_write = 1'b1;
                o_mem_to_reg = SRC_IMM;
            end
        //  CUSTOM_INSTRUCTION: begin
        //
        //  end
            default: begin
                o_mem_read = '0;
                o_mem_write = '0;
                o_reg_write = '0;
                o_d_size = '0;
                o_d_unsigned = '0;
                o_mem_to_reg = '0;
            end
        endcase
    end

endmodule