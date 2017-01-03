`include "macro.vh"
module Alu(i_r,i_s,i_aluc,o_alu);
    input [31:0] i_r;       //i_r: r input
    input [31:0] i_s;       //i_s: s input
    input [3:0] i_aluc;     //i_aluc: ctrl input
    output [31:0] o_alu;    //o_alu: alu result output
    reg [31:0] o_alu;

    initial begin
        o_alu = 0;
    end

    always @(i_aluc or i_r or i_s) begin
        case (i_aluc)
            `ALU_AND: begin
                o_alu = i_r & i_s;
            end
            `ALU_OR: begin
                o_alu = i_r | i_s;
            end
				`ALU_XOR: begin
					 o_alu = i_r ^ i_s;
				end
            `ALU_NOR: begin
                o_alu = ~(i_r | i_s);
            end
            `ALU_ADD: begin
                o_alu = i_r + i_s;
            end
            `ALU_SUB: begin
                o_alu = i_r - i_s;
            end
				`ALU_ADDU: begin
                o_alu = i_r + i_s;
            end
            `ALU_SUBU: begin
                o_alu = i_r - i_s;
            end
            `ALU_SLT: begin
                if ($signed(i_r) < $signed(i_s))
                    o_alu = 1;
                else
                    o_alu = 0;
            end
				`ALU_SLTU: begin
                if ($unsigned(i_r) < $unsigned(i_s))
                    o_alu = 1;
                else
                    o_alu = 0;
            end
            `ALU_SLL: begin
                o_alu = i_s << i_r;
            end
            `ALU_SRL: begin
                o_alu = $unsigned(i_s) >> i_r;
            end
            `ALU_SRA: begin
                o_alu = $signed(i_s) >>> i_r;
            end
				`ALU_LUI: begin
					 o_alu = i_s << 16;
				end
            default: begin
                o_alu = 0;
            end
        endcase
    end
endmodule

