module top(input wire CCLK, BTN3, BTN2, input wire [3:0]SW, output wire LED, LCDE, LCDRS, LCDRW, output wire [3:0]LCDDAT);

    wire [31:0] if_pc;
    wire [31:0] if_pc4;
    wire [31:0] if_inst;
    
    wire [31:0] id_pc4; 
    wire [31:0] id_inA;
    wire [31:0] id_inB;
    wire [31:0] id_imm;
    wire id_regrt;
    wire [4:0] id_rt;
    wire [4:0] id_rd;
    wire id_branch;
    wire [31:0] id_bpc;
    wire id_wreg;
    wire id_m2reg;
    wire id_wmem;
    wire [3:0] id_aluc;
    wire id_shift;
    wire id_aluimm;
    wire wpc;
    wire [1:0] id_FWA, id_FWB;
    
    wire ex_wreg;
    wire ex_m2reg;
    wire ex_wmem;
    wire[31:0] ex_aluR;
    wire[31:0] ex_inB;
    wire[4:0] ex_destR;
    wire ex_zero;
    
    wire mem_wreg;
    wire mem_m2reg;
    wire[31:0] mem_mdata;
    wire[31:0] mem_aluR;
    wire[4:0] mem_destR;
    
    wire wb_wreg;
    wire[4:0] wb_destR;
    wire[31:0] wb_dest;
    
    wire [3:0] IF_ins_type; 
    wire [3:0] IF_ins_number;
    wire [3:0] ID_ins_type;
    wire [3:0] ID_ins_number;
    wire [3:0] EX_ins_type; 
    wire [3:0] EX_ins_number;
    wire [3:0] MEM_ins_type; 
    wire [3:0] MEM_ins_number;
    wire [3:0] WB_ins_type; 
    wire [3:0] WB_ins_number;
    
    wire [31:0] pc;
    wire [31:0] reg_content;
    wire [3:0] which_reg;
    
    reg [255:0] strdata;
    reg [3:0] SW_old;
    reg [7:0] clk_cnt;
    reg cls;

    wire [3:0] lcdd;
    wire rslcd, rwlcd, elcd;
    wire clk_1ms;

    assign LCDDAT[3]=lcdd[3];
    assign LCDDAT[2]=lcdd[2];
    assign LCDDAT[1]=lcdd[1];
    assign LCDDAT[0]=lcdd[0];
    
    assign LCDRS=rslcd;
    assign LCDRW=rwlcd;
    assign LCDE=elcd;
    
    assign LED=BTN3;
    assign which_reg[3:0] = SW[3:0];

    wire btn3ok;
    //Anti_Jitter antijitter(CCLK, BTN3, btn3ok);
	 assign btn3ok = BTN3;

    initial begin
        strdata <= "01234567 00 0123f01d01e01m01w01 ";
        SW_old = 4'b0;
        clk_cnt <= 8'b0;
        cls <= 1'b0;
    end
    
    display M0 (CCLK, cls, strdata, rslcd, rwlcd, elcd, lcdd);

    always @(posedge CCLK) begin
        //if ((btn3ok == 1'b1) || (BTN2 == 1'b1)) begin
            //first line 8 4-bit Instrution
            if (if_inst[31:28] >= 0 && if_inst[31:28] <= 9)
                strdata[255:248] <= 8'h30 + if_inst[31:28];
            else
                strdata[255:248] <= 8'h41 + if_inst[31:28] - 4'd10;
            if (if_inst[27:24] >= 0 && if_inst[27:24] <= 9)
                strdata[247:240] <= 8'h30 + if_inst[27:24];
            else
                strdata[247:240] <= 8'h41 + if_inst[27:24] - 4'd10;
            if (if_inst[23:20] >= 0 && if_inst[23:20] <= 9)
                strdata[239:232] <= 8'h30 + if_inst[23:20];
            else
                strdata[239:232] <= 8'h41 + if_inst[23:20] - 4'd10;
            if (if_inst[19:16] >= 0 && if_inst[19:16] <= 9)
                strdata[231:224] <= 8'h30 + if_inst[19:16];
            else
                strdata[231:224] <= 8'h41 + if_inst[19:16] - 4'd10;
            if (if_inst[15:12] >= 0 && if_inst[15:12] <= 9)
                strdata[223:216] <= 8'h30 + if_inst[15:12];
            else
                strdata[223:216] <= 8'h41 + if_inst[15:12] - 4'd10;
            if (if_inst[11:8] >= 0 && if_inst[11:8] <= 9)
                strdata[215:208] <= 8'h30 + if_inst[11:8];
            else
                strdata[215:208] <= 8'h41 + if_inst[11:8] - 4'd10;
            if (if_inst[7:4] >= 0 && if_inst[7:4] <= 9)
                strdata[207:200] <= 8'h30 + if_inst[7:4];
            else
                strdata[207:200] <= 8'h41 + if_inst[7:4] - 4'd10;
            if (if_inst[3:0] >= 0 && if_inst[3:0] <= 9)
                strdata[199:192] <= 8'h30 + if_inst[3:0];
            else
                strdata[199:192] <= 8'h41 + if_inst[3:0] - 4'd10;
            //space
            //strdata[191:184] = " ";
            //2 4-bit CLK
            if (clk_cnt[7:4] >= 0 && clk_cnt[7:4] <= 9)
                strdata[183:176] <= 8'h30 + clk_cnt[7:4];
            else
                strdata[183:176] <= 8'h41 + clk_cnt[7:4] - 4'd10;
            if (clk_cnt[3:0] >= 0 && clk_cnt[3:0] <= 9)
                strdata[175:168] <= 8'h30 + clk_cnt[3:0];
            else
                strdata[175:168] <= 8'h41 + clk_cnt[3:0] - 4'd10;
            //space
            //strdata[167:160] = " ";

            //second line
            //strdata[127:120] = "f";
            if (IF_ins_number >= 0 && IF_ins_number <= 9)
                strdata[119:112] <= 8'h30 + IF_ins_number;
            else
                strdata[119:112] <= 8'h41 + IF_ins_number - 4'd10;
            if (IF_ins_type >= 0 && IF_ins_type <= 9)
                strdata[111:104] <= 8'h30 + IF_ins_type;
            else
                strdata[111:104] <= 8'h41 + IF_ins_type - 4'd10;
            //strdata[103:96] = "d";
            if (ID_ins_number >= 0 && ID_ins_number <= 9)
                strdata[95:88] <= 8'h30 + ID_ins_number;
            else
                strdata[95:88] <= 8'h41 + ID_ins_number - 4'd10;
            if (ID_ins_type >= 0 && ID_ins_type <= 9)
                strdata[87:80] <= 8'h30 + ID_ins_type;
            else
                strdata[87:80] <= 8'h41 + ID_ins_type - 4'd10;
            //strdata[79:72] = "e";
            if (EX_ins_number >= 0 && EX_ins_number <= 9)
                strdata[71:64] <= 8'h30 + EX_ins_number;
            else
                strdata[71:64] <= 8'h41 + EX_ins_number - 4'd10;
            if (EX_ins_type >= 0 && EX_ins_type <= 9)
                strdata[63:56] <= 8'h30 + EX_ins_type;
            else
                strdata[63:56] <= 8'h41 + EX_ins_type - 4'd10;
            //strdata[55:48] = "m";
            if (MEM_ins_number >= 0 && MEM_ins_number <= 9)
                strdata[47:40] <= 8'h30 + MEM_ins_number;
            else
                strdata[47:40] <= 8'h41 + MEM_ins_number - 4'd10;
            if (MEM_ins_type >= 0 && MEM_ins_type <= 9)
                strdata[39:32] <= 8'h30 + MEM_ins_type;
            else
                strdata[39:32] <= 8'h41 + MEM_ins_type - 4'd10;
            //strdata[31:24] = "w";
            if (WB_ins_number >= 0 && WB_ins_number <= 9)
                strdata[23:16] <= 8'h30 + WB_ins_number;
            else
                strdata[23:16] <= 8'h41 + WB_ins_number - 4'd10;
            if (WB_ins_type >= 0 && WB_ins_type <= 9)
                strdata[15:8] <= 8'h30 + WB_ins_type;
            else
                strdata[15:8] <= 8'h41 + WB_ins_type - 4'd10;
        //end
        if((btn3ok == 1'b1) || (BTN2 == 1'b1)||(SW_old != SW)) begin
            //first line after CLK and space
            if (reg_content[15:12] >= 0 && reg_content[15:12] <= 9)
                strdata[159:152] <= 8'h30 + reg_content[15:12];
            else
                strdata[159:152] <= 8'h41 + reg_content[15:12] - 4'd10;
            if (reg_content[11:8] >= 0 && reg_content[11:8] <= 9)
                strdata[151:144] <= 8'h30 + reg_content[11:8];
            else
                strdata[151:144] <= 8'h41 + reg_content[11:8] - 4'd10;
            if (reg_content[7:4] >= 0 && reg_content[7:4] <= 9)
                strdata[143:136] <= 8'h30 + reg_content[7:4];
            else
                strdata[143:136] <= 8'h41 + reg_content[7:4] - 4'd10;
            if (reg_content[3:0] >= 0 && reg_content[3:0] <= 9)
                strdata[135:128] <= 8'h30 + reg_content[3:0];
            else
                strdata[135:128] <= 8'h41 + reg_content[3:0] - 4'd10;
            SW_old <= SW;
            cls <= 1;
        end
        else
            cls <= 0;
    end
    
    always @(posedge btn3ok or posedge BTN2) begin
        if (BTN2) clk_cnt <= 0;
        else clk_cnt <= clk_cnt + 1;
    end

    assign pc [31:0] = if_pc4[31:0];
    wire rst = BTN2;


    if_stage x_if_stage(btn3ok, rst, pc, id_bpc, id_branch, wpc,
                        if_pc, if_pc4, if_inst, IF_ins_type, IF_ins_number);

    id_stage x_id_stage(btn3ok, rst, if_inst, if_pc4, wb_destR, wb_dest,wb_wreg, ex_aluR,mem_aluR,mem_mdata,
                        id_wreg, id_m2reg, id_wmem, id_aluc, id_shift, id_aluimm, id_branch, id_bpc,
                        id_inA, id_inB, id_imm, id_regrt,id_rt,id_rd,wpc,
                        IF_ins_type, IF_ins_number, ID_ins_type, ID_ins_number, {1'b0,which_reg}, reg_content);

    ex_stage x_ex_stage(btn3ok, rst, id_imm, id_inA, id_inB, id_wreg, id_m2reg, id_wmem, id_aluc, id_aluimm,id_shift,
                        id_regrt,id_rt,id_rd,
                        ex_wreg, ex_m2reg, ex_wmem, ex_aluR, ex_inB, ex_destR, ex_zero, 
                        ID_ins_type, ID_ins_number, EX_ins_type, EX_ins_number);

    mem_stage x_mem_stage(btn3ok, rst, ex_destR, ex_inB, ex_aluR, ex_wreg, ex_m2reg, ex_wmem, ex_zero,  
                          mem_wreg, mem_m2reg, mem_mdata, mem_aluR, mem_destR,
                          EX_ins_type, EX_ins_number, MEM_ins_type, MEM_ins_number);

    wb_stage x_wb_stage(btn3ok, rst, mem_destR, mem_aluR, mem_mdata, mem_wreg, mem_m2reg, 
                        wb_wreg, wb_dest, wb_destR, MEM_ins_type, MEM_ins_number,WB_ins_type, WB_ins_number);

endmodule

