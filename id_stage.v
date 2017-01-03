module id_stage (clk, rst, if_inst, if_pc4, wb_destR, wb_dest,wb_wreg,ex_aluR,mem_aluR,mem_mdata,
    cu_wreg, cu_m2reg, cu_wmem, cu_aluc, cu_shift, cu_aluimm, cu_branch, cu_bpc,
    id_inA_new, id_inB_new, id_imm, cu_regrt, rt, rd, wpcir,
    IF_ins_type, IF_ins_number, ID_ins_type, ID_ins_number, which_reg, reg_content);
    
    input clk;
    input rst;
    input [31:0] if_inst;
    input [31:0] if_pc4;
    
    input [4:0] wb_destR;
    input [31:0] wb_dest;
    input wb_wreg;

    input [31:0] ex_aluR,mem_aluR,mem_mdata;

    input[3:0] IF_ins_type;
    input[3:0]  IF_ins_number;
    
    input [4:0] which_reg;
    output [31:0] reg_content;
    
    output cu_branch;
    output cu_wreg;
    output cu_m2reg;
    output cu_wmem;
    output [3:0] cu_aluc;
    output cu_shift;
    output cu_aluimm;
    output [31:0] cu_bpc;
    output [31:0] id_inA_new;
    output [31:0] id_inB_new;
    output [31:0] id_imm;
    output cu_regrt;
    output [4:0] rd;
    output [4:0] rt;
    output wpcir;
    
    output[3:0] ID_ins_type;
    output[3:0] ID_ins_number;
    
    wire cu_sext;
    wire cu_regrt;
    wire cu_branch;
    wire rsrtequ;
    wire cu_jump;
	 wire cu_jal;
	 wire cu_jr;
	 
	 wire [31:0]id_inA;
	 wire [31:0]id_inB;
    
    reg [31:0] reg_inst;
    reg [31:0] pc4;
    
    wire [31:0] rdata_A;
    wire [31:0] rdata_B;
    wire [4:0] rt;
    wire [4:0] rd;
    wire [15:0] imm;
    wire [31:0] id_imm;
    wire [1:0] id_FWA, id_FWB;
    
    wire [31:0] id_pc4;
    
    reg[3:0] ID_ins_type;
    reg[3:0] ID_ins_number;
    
    assign imm = reg_inst[15:0];
    assign rt = cu_jal ? 5'd31 : reg_inst[20:16];
    assign rd = cu_jal ? 5'd31 : reg_inst[15:11];
    assign id_imm = cu_sext?( imm[15]?{16'hffff,imm}:{16'b0,imm}):{16'b0,imm};
    assign cu_bpc = cu_jr ? id_inA : (cu_jump ? {pc4[31:26], reg_inst[25:0]} : pc4 + id_imm);
    
    always @ (posedge clk or posedge rst)
        if (rst) begin
            reg_inst <= 0;
            pc4 <= 0;
            ID_ins_type <= 0;
            ID_ins_number <= 0;
        end
        else if (wpcir) begin
            reg_inst <= if_inst;
            pc4 <= if_pc4;
            ID_ins_type <= IF_ins_type;
            ID_ins_number <= IF_ins_number;
        end
        else begin
            reg_inst <= 0;
            pc4 <= 0;
            ID_ins_type <= 0;
            ID_ins_number <= 0;
        end
    
    regfile x_regfile(clk, rst, reg_inst[25:21], reg_inst[20:16], wb_destR, wb_dest, wb_wreg, rdata_A, rdata_B,
        which_reg, reg_content);
    ctrl_unit x_ctrl_unit(clk, rst, if_inst[31:0], reg_inst[31:0], rsrtequ,
        cu_branch, cu_wreg, cu_m2reg, cu_wmem, cu_aluc, cu_shift, cu_aluimm, cu_sext,cu_regrt,wpcir,
        id_FWA,id_FWB,cu_jump,cu_jal,cu_jr);
    
    assign id_inA = (id_FWA == 2'b00) ? rdata_A : (id_FWA == 2'b01) ? ex_aluR : (id_FWA == 2'b10) ? mem_aluR : mem_mdata;
    assign id_inB = (id_FWB == 2'b00) ? rdata_B : (id_FWB == 2'b01) ? ex_aluR : (id_FWB == 2'b10) ? mem_aluR : mem_mdata;
	 
	 assign id_inA_new = cu_jal ? pc4 : id_inA;
	 assign id_inB_new = cu_jal ? 0 : id_inB;
	 
    assign rsrtequ = id_inA == id_inB;

endmodule

