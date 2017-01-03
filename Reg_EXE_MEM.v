module Reg_EXE_MEM(clk, rst, ewreg,em2reg,ewmem,aluout,edata_b,erdrt, ezero,//inputs
                            mwreg,mm2reg,mwmem,maluout,mdata_b,mrdrt, mzero, 
                            EXE_ins_type, EXE_ins_number, MEM_ins_type, MEM_ins_number);
    input clk,rst,ewreg,em2reg,ewmem;
    input [31:0]    aluout,edata_b;
    input ezero;
    input [4:0]     erdrt;
    
    output mwreg,mm2reg,mwmem;
    output [31:0] maluout,mdata_b;
    output mzero;
    output [4:0] mrdrt;
        
    input[3:0] EXE_ins_type;
    input[3:0]  EXE_ins_number;
    output[3:0] MEM_ins_type;
    output[3:0] MEM_ins_number;

    reg[3:0] MEM_ins_type;
    reg[3:0] MEM_ins_number;    
    reg mwreg,mm2reg,mwmem;
    reg [31:0]  maluout,mdata_b;
    reg [4:0]       mrdrt;
    reg mzero;
 
    always@(posedge clk or posedge rst) begin
        if (rst) begin
            mwreg <= 0;
            mm2reg <= 0;
            mwmem <= 0;
            maluout <= 0;
            mdata_b <= 0;
            mrdrt <= 0;
            mzero <= 0;
            MEM_ins_type <= 0;
            MEM_ins_number <= 0;
        end
        else begin
            mwreg <= ewreg;
            mm2reg <= em2reg;
            mwmem <= ewmem;
            maluout <= aluout;
            mdata_b <= edata_b;
            mrdrt <= erdrt;
            mzero <= ezero;
            MEM_ins_type <= EXE_ins_type;
            MEM_ins_number <= EXE_ins_number;
        end
    end
endmodule

