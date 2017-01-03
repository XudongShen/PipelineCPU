module Reg_ID_EXE(clk, rst, wreg, m2reg, wmem, aluc, shift, aluimm,  data_a, data_b, data_imm,
                    id_regrt,id_rt,id_rd,//inputs
                    ewreg,em2reg,   ewmem,ealuc, eshift, ealuimm, odata_a,odata_b, odata_imm,
                    e_regrt,e_rt,e_rd,
                    ID_ins_type, ID_ins_number, EXE_ins_type, EXE_ins_number);  //outputs
    input clk, rst;
    input wreg, m2reg, wmem, shift, aluimm;
    input [3:0]     aluc;
    input [31:0]    data_a, data_b, data_imm;
    input id_regrt;
    input [4:0]id_rt;
    input [4:0]id_rd;
    input[3:0]  ID_ins_type;
    input[3:0]  ID_ins_number;

    output  ewreg,  em2reg, ewmem,  eshift, ealuimm;
    output [3:0]    ealuc;
    output [31:0]   odata_a,odata_b,odata_imm;
    output e_regrt;
    output [4:0] e_rt;
    output [4:0] e_rd;
    output[3:0] EXE_ins_type;
    output[3:0] EXE_ins_number;
    
    reg[3:0] EXE_ins_type;
    reg[3:0] EXE_ins_number;
    reg     ewreg,  em2reg, ewmem,  eshift, ealuimm;
    reg [3:0]   ealuc;
    reg [31:0]  odata_a,odata_b,odata_imm;
    reg e_regrt;
    reg [4:0] e_rt;
    reg [4:0] e_rd;
    
    always@(posedge clk or posedge rst) begin
        if (rst) begin
            ewreg <= 0;
            em2reg <= 0;
            ewmem <= 0;
            eshift <= 0;
            ealuimm <= 0;
            ealuc <= 0;
            odata_a <= 0;
            odata_b <= 0;
            odata_imm <= 0;
            EXE_ins_type <= 0;
            EXE_ins_number <= 0;
            e_regrt <= 0;
            e_rt <= 0;
            e_rd <= 0;
        end
        else begin
            ewreg <= wreg;
            em2reg <= m2reg;
            ewmem <= wmem;
            eshift <= shift;
            ealuimm <= aluimm;
            ealuc <= aluc;
            odata_a <= data_a;
            odata_b <= data_b;
            odata_imm <= data_imm;
            EXE_ins_type <= ID_ins_type;
            EXE_ins_number <= ID_ins_number;
            e_regrt <= id_regrt;
            e_rt <= id_rt;
            e_rd <= id_rd;
        end
    end
endmodule

