module main_control_unit (
    input           [6:0]   i_opcode,
    input           [4:0]   i_rd,
    input           [2:0]   i_funct3,
    input           [4:0]   i_rs1,
    input           [6:0]   i_funct7,
    // Regiser File control 
    output  logic           o_reg_write,
    // DMEM Read/Write Control
    output  logic           o_mem_read,
    output  logic   [1:0]   o_d_size,
    output  logic           o_d_unsigned,
    output  logic   [2:0]   o_mem_to_reg,
    output  logic           o_mem_write,
    // CSR Read/Write Control 
    output  logic   [1:0]   o_csr_op,
    output  logic           o_csr_imm,
    output  logic           o_csr_write
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
    localparam OPCODE_SYSTEM = 7'b11_100_11;    // CSRXX, ECALL (NOT IMPLEMENTED), EBREAK (NOT IMPLEMENTED)
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

    // CSR related FUNCT3
    localparam FUNCT3_CSRRW = 3'b001;
    localparam FUNCT3_CSRRS = 3'b010;
    localparam FUNCT3_CSRRC = 3'b011;
    localparam FUNCT3_CSRRWI = 3'b101;
    localparam FUNCT3_CSRRSI = 3'b110;
    localparam FUNCT3_CSRRCI = 3'b111;

    // ARITHMETIC and MULTIPLIER related FUNCT7
    localparam FUNCT7_MUL = 7'h01;

    // SIZES
    localparam SIZE_HALF = 2'b01;
    localparam SIZE_WORD = 2'b10;

    // REGISTER SOURCE
    localparam SRC_ALU = 3'b000;
    localparam SRC_DMEM = 3'b001;
    localparam SRC_PC_PLUS_4 = 3'b010;
    localparam SRC_IMM = 3'b011;
    localparam SRC_CSR = 3'b100;
    localparam SRC_MUL = 3'b101;     // data from multiplier

    // CSR OPERATIONS
    localparam CSR_RW = 2'b00;
    localparam CSR_RS = 2'b01;
    localparam CSR_RC = 2'b10;



    always_comb begin
        o_mem_read = '0;
        o_mem_write = '0;
        o_reg_write = '0;
        o_d_size = '0;
        o_d_unsigned = '0;
        o_mem_to_reg = '0;
        o_csr_op = '0;
        o_csr_imm = '0;
        o_csr_write = '0;

        case (i_opcode)
            OPCODE_R: begin
                o_reg_write = 1'b1;
                if (i_funct7 == FUNCT7_MUL) begin   // multiplication instructions
                    o_mem_to_reg = SRC_MUL;
                end else begin
                    o_mem_to_reg = SRC_ALU;         // arithmetic instructions
                end
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
            OPCODE_SYSTEM: begin
                o_mem_to_reg = SRC_CSR;
                case (i_funct3)
                    FUNCT3_CSRRW: begin
                        o_csr_op = CSR_RW;
                        o_csr_write = 1'b1;
                        if (i_rd != '0) begin
                            o_reg_write = 1'b1;
                        end else begin
                            o_reg_write = 1'b0;
                        end
                    end
                    FUNCT3_CSRRS: begin
                        o_csr_op = CSR_RS;
                        o_reg_write = 1'b1;
                        if (i_rs1 != '0) begin
                            o_csr_write = 1'b1;
                        end else begin
                            o_csr_write = 1'b0;
                        end
                    end 
                    FUNCT3_CSRRC: begin
                        o_csr_op = CSR_RC;
                        o_reg_write = 1'b1;
                        if (i_rs1 != '0) begin
                            o_csr_write = 1'b1;
                        end else begin
                            o_csr_write = 1'b0;
                        end
                    end
                    FUNCT3_CSRRWI: begin
                        o_csr_op = CSR_RW;
                        o_csr_imm = 1'b1;
                        o_csr_write = 1'b1;
                        if (i_rd != '0) begin
                            o_reg_write = 1'b1;
                        end else begin
                            o_reg_write = 1'b0;
                        end
                    end
                    FUNCT3_CSRRSI: begin
                        o_csr_op = CSR_RS;
                        o_csr_imm = 1'b1;
                        o_reg_write = 1'b1;
                        if (i_rs1 != '0) begin
                            o_csr_write = 1'b1;
                        end else begin
                            o_csr_write = 1'b0;
                        end
                    end 
                    FUNCT3_CSRRCI: begin
                        o_csr_op = CSR_RC;
                        o_csr_imm = 1'b1;
                        o_reg_write = 1'b1;
                        if (i_rs1 != '0) begin
                            o_csr_write = 1'b1;
                        end else begin
                            o_csr_write = 1'b0;
                        end
                    end 
                    default: begin
                        o_csr_op = CSR_RW;
                        o_csr_imm = '0;
                        o_reg_write = '0;
                        o_csr_write = '0;
                    end
                endcase
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
                o_csr_write = '0;
            end
        endcase
    end

endmodule