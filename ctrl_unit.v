`include "macro.vh"

module ctrl_unit(clk, rst, if_instr, instr, rsrtequ, 
    cu_branch, cu_wreg, cu_m2reg, cu_wmem, cu_aluc, cu_shift, cu_aluimm, cu_sext,cu_regrt, wpcir,
    id_FWA, id_FWB, cu_jump,cu_jal,cu_jr);
    
    input clk;
    input rst;
    input [31:0] instr;
    input [31:0] if_instr;
    input rsrtequ;
    
    output cu_branch;
    output cu_wreg;
    output cu_m2reg;
    output cu_wmem;
    output [3:0] cu_aluc;
    output cu_shift;
    output cu_aluimm;
    output cu_sext;
    output cu_regrt;
    output wpcir;
    output [1:0] id_FWA, id_FWB;
    output cu_jump;
	 output cu_jal;
	 output cu_jr;
    
    wire [5:0] func;
    wire [5:0] opcode;
    wire [4:0] rs;
    wire [4:0] rt;
    wire [4:0] rd;
    
    wire [5:0] if_func;
    wire [5:0] if_opcode;
    wire [4:0] if_rs;
    wire [4:0] if_rt;
    wire [4:0] if_rd; 
    
    wire [4:0] ex_rs;
    wire [4:0] ex_rt;
    wire [4:0] ex_rd;
    wire [4:0] mem_rt;
    wire [4:0] mem_rd;
    wire [4:0] wb_rd;
    wire [4:0] wb_rt;
    wire [5:0] ex_op;
    wire [5:0] mem_op;
    wire [5:0] wb_op;

    reg [31:0] ex_instr;
    reg [31:0] mem_instr;
    reg [31:0] wb_instr;
    reg [3:0] cu_aluc;
    
    assign opcode[5:0] = instr[31:26];
    assign rs[4:0] = instr[25:21];
    assign rt[4:0] = instr[20:16];
    assign rd[4:0] = instr[15:11];
    assign func[5:0] = instr[5:0];
    
    assign if_opcode[5:0] = if_instr[31:26];
    assign if_rs[4:0] = if_instr[25:21];
    assign if_rt[4:0] = if_instr[20:16];
    assign if_rd[4:0] = if_instr[15:11];
    assign if_func[5:0] = if_instr[5:0];
    
    assign ex_rs[4:0] = ex_instr[25:21];
    assign ex_rt[4:0] = ex_instr[20:16];
    assign ex_rd[4:0] = ex_instr[15:11];
    assign mem_rt[4:0] = mem_instr[20:16];
    assign mem_rd[4:0] = mem_instr[15:11];
    assign wb_rd[4:0] = wb_instr[15:11];
    assign wb_rt[4:0] = wb_instr[20:16];
    assign ex_op[5:0] = ex_instr[31:26];
    assign mem_op[5:0] = mem_instr[31:26];
    assign wb_op[5:0] = wb_instr[31:26];
    
    assign cu_branch = ((opcode == `OP_BEQ) & rsrtequ ) | ((opcode == `OP_BNE) & ~rsrtequ) | cu_jump; //if instr type == BEQ then 1 else 0
    assign cu_regrt = opcode != `OP_ALUOp; //if instr type = R type then 0 else 1;
    assign cu_sext = (opcode == `OP_LW) || (opcode == `OP_SW) || (opcode == `OP_BEQ) || (opcode == `OP_BNE) || (opcode == `OP_ADDI) || (opcode == `OP_ADDIU); //when need to sign extend?
    
    assign cu_wreg = (opcode == `OP_LW) || (opcode == `OP_ALUOp) || (opcode == `OP_ADDI) || (opcode == `OP_ANDI) || (opcode == `OP_ORI) || (opcode == `OP_ADDIU) || (opcode == `OP_XORI) || (opcode == `OP_LUI) || (opcode == `OP_SLTI) || (opcode == `OP_SLTIU) || (opcode == `OP_JAL); //when need to write reg?
    assign cu_m2reg = opcode == `OP_LW; //when need to write mem to reg ?
    assign cu_wmem = opcode == `OP_SW; //when need to enable write mem?
    assign cu_shift = ((opcode == `OP_ALUOp) && (func[5:2] == 4'b0))? 1 : 0;
    assign cu_aluimm = (opcode == `OP_LW) || (opcode == `OP_SW) || (opcode == `OP_ADDI) || (opcode == `OP_ANDI) || (opcode == `OP_ORI) || (opcode == `OP_XORI);
    assign cu_jump = (opcode == `OP_JMP) || cu_jal || cu_jr;
	 assign cu_jal = (opcode == `OP_JAL);
	 assign cu_jr = ((opcode == `OP_ALUOp) && (func == `FUNC_JR));
	 
	 wire AIfromEx = (rs == ex_rt) & (rs != 0) & ((ex_op == `OP_ADDI)||(ex_op == `OP_ANDI)||(ex_op == `OP_ORI)||(ex_op == `OP_ADDIU)||(ex_op == `OP_XORI)||(ex_op == `OP_LUI)||(ex_op == `OP_SLTI)||(ex_op == `OP_SLTIU));
	 wire BIfromEx = (rt == ex_rt) & (rt != 0) & ((ex_op == `OP_ADDI)||(ex_op == `OP_ANDI)||(ex_op == `OP_ORI)||(ex_op == `OP_ADDIU)||(ex_op == `OP_XORI)||(ex_op == `OP_LUI)||(ex_op == `OP_SLTI)||(ex_op == `OP_SLTIU));
    wire AfromEx = ((rs == ex_rd) & (rs != 0) & (ex_op == `OP_ALUOp)) | AIfromEx;
    wire BfromEx = ((rt == ex_rd) & (rt != 0) & (ex_op == `OP_ALUOp)) | BIfromEx;
	 wire AIfromMem = (rs == mem_rt) & (rs != 0) & ((mem_op == `OP_ADDI)|(mem_op == `OP_ANDI)|(mem_op == `OP_ORI)|(mem_op == `OP_ADDIU)|(mem_op == `OP_XORI)|(mem_op == `OP_LUI)|(mem_op == `OP_SLTI)|(mem_op == `OP_SLTIU));
	 wire BIfromMem = (rt == mem_rt) & (rt != 0) & ((mem_op == `OP_ADDI)|(mem_op == `OP_ANDI)|(mem_op == `OP_ORI)|(mem_op == `OP_ADDIU)|(mem_op == `OP_XORI)|(mem_op == `OP_LUI)|(mem_op == `OP_SLTI)|(mem_op == `OP_SLTIU));
    wire AfromMem = ((rs == mem_rd) & (rs != 0) & (mem_op == `OP_ALUOp)) | AIfromMem;
    wire BfromMem = ((rt == mem_rd) & (rt != 0) & (mem_op == `OP_ALUOp)) | BIfromMem;
    wire AfromExLW = (if_rs == rt) & (if_rs != 0) & (opcode == `OP_LW);
    wire BfromExLW = (if_rt == rt) & (if_rt != 0) & (opcode == `OP_LW);
    wire AfromMemLW = (rs == mem_rt) & (rs != 0) & (mem_op == `OP_LW);
    wire BfromMemLW = (rt == mem_rt) & (rt != 0) & (mem_op == `OP_LW);
    wire stall = AfromExLW || BfromExLW || cu_branch ;
    assign wpcir = ~stall;
    assign id_FWA = AfromEx ? 2'b01 : AfromMem ? 2'b10 : AfromMemLW ? 2'b11 : 2'b00;
    assign id_FWB = BfromEx ? 2'b01 : BfromMem ? 2'b10 : BfromMemLW ? 2'b11 : 2'b00;

    always @ (posedge clk or posedge rst)
        if(rst) begin
            wb_instr[31:0] <= 0;
            mem_instr[31:0] <= 0;
            ex_instr[31:0] <= 0;
        end
        else begin
            wb_instr[31:0] <= mem_instr[31:0];
            mem_instr[31:0] <= ex_instr[31:0];
            ex_instr[31:0] <= instr[31:0];
        end

    initial begin
        cu_aluc = 0;
    end

    always @(opcode or func) begin
            case(opcode)
                `OP_ADDI: begin
                    cu_aluc <= `ALU_ADD;
                end
                `OP_ANDI: begin
                    cu_aluc <= `ALU_AND;
                end
                `OP_ORI: begin
                    cu_aluc <= `ALU_OR;
                end
                `OP_LW: begin
                    cu_aluc <= `ALU_ADD;
                end
                `OP_SW: begin
                    cu_aluc <= `ALU_ADD;
                end
					 `OP_JAL: begin
                    cu_aluc <= `ALU_ADD;
                end
                `OP_BEQ: begin
                    cu_aluc <= `ALU_SUB;
                end
					 `OP_BNE: begin
                    cu_aluc <= `ALU_SUB;
                end
					 `OP_ADDIU: begin
					     cu_aluc <= `ALU_ADDU;
					 end
					 `OP_XORI: begin
						  cu_aluc <= `ALU_XOR;
					 end
					 `OP_LUI: begin
					     cu_aluc <= `ALU_LUI;
					 end
					 `OP_SLTI: begin
						  cu_aluc <= `ALU_SLT;
					 end
					 `OP_SLTIU: begin
						  cu_aluc <= `ALU_SLTU;
					 end
                `OP_ALUOp: begin
                    case(func)
                        `FUNC_ADD: begin
                            cu_aluc <= `ALU_ADD;
                        end
								`FUNC_ADDU: begin
									 cu_aluc <= `ALU_ADDU;
								end
                        `FUNC_SUB: begin
                            cu_aluc <= `ALU_SUB;
                        end
								`FUNC_SUBU: begin
									 cu_aluc <= `ALU_SUBU;
								end
                        `FUNC_AND: begin
                            cu_aluc <= `ALU_AND;
                        end
                        `FUNC_OR: begin
                            cu_aluc <= `ALU_OR;
                        end
								`FUNC_XOR: begin
									 cu_aluc <= `ALU_XOR;
								end
                        `FUNC_NOR: begin
                            cu_aluc <= `ALU_NOR;
                        end
                        `FUNC_SLT: begin
                            cu_aluc <= `ALU_SLT;
                        end
								`FUNC_SLTU: begin
									 cu_aluc <= `ALU_SLTU;
								end
                        `FUNC_SLL: begin
                            cu_aluc <= `ALU_SLL;
                        end
                        `FUNC_SRL: begin
                            cu_aluc <= `ALU_SRL;
                        end
                        `FUNC_SRA: begin
                            cu_aluc <= `ALU_SRA;
                        end
								`FUNC_SLLV: begin
									 cu_aluc <= `ALU_SLL;
								end
								`FUNC_SRLV: begin
                            cu_aluc <= `ALU_SRL;
                        end
                        `FUNC_SRAV: begin
                            cu_aluc <= `ALU_SRA;
                        end
                    endcase
                end
                default: begin
                    cu_aluc <= 0;
                end
            endcase
        end
endmodule

