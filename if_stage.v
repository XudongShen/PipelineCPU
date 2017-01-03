`include "macro.vh"
module if_stage (clk, rst, nextpc, branch_pc, ctrl_branch, wpc,
    if_pc, if_pc4, if_inst, IF_ins_type,IF_ins_number);
                
    input clk;
    input rst;
    input [31:0] nextpc;
    input [31:0] branch_pc;
    input ctrl_branch;
    input wpc;
    
    output [31:0] if_pc;
    output [31:0] if_pc4;
    output [31:0] if_inst;
    output [3:0] IF_ins_number;
    output [3:0] IF_ins_type;
    
    wire clk;
    wire rst;
    wire ctrl_branch;
    wire [31:0] nextpc;
    wire [31:0] branch_pc;
    wire [31:0] if_pc;
    wire [31:0] if_pc4;
    wire [31:0] if_inst;
    wire [31:0] inst_m;
    wire [31:0] npc;
    reg [31:0] pc;
    reg run;
    reg [3:0] IF_ins_type;
    reg [3:0] IF_ins_number;

    assign if_pc = pc;
    assign if_pc4 = pc + 1;
    assign npc = ctrl_branch ? branch_pc : nextpc;
    assign if_inst[31:0] = (pc[7:0] == 8'hffff) ? 0 : inst_m[31:0];

    initial begin
        pc = 32'hffffffff;
        IF_ins_number = 4'b0000;
        IF_ins_type = 4'b0000;
    end

    always @ (posedge clk or posedge rst) begin
        if (rst) begin
            pc[31:0] <= 32'hffffffff;
            run <= 1'b0;
        end
        else if (wpc | ctrl_branch) begin
            pc[31:0] <= npc[31:0];
            run <= 1'b1;
        end
    end

    always @ (if_inst or pc) begin
        if (run == 1'b0) begin
            IF_ins_type[3:0] <= 4'b0000;
            IF_ins_number[3:0] <= 4'b0000;
        end
        else begin
			IF_ins_number[3:0] <= pc[3:0];
			case (if_inst[31:26])
				`OP_ALUOp: begin        //R-type
					case(if_inst[5:0])
						`FUNC_ADD: begin
							IF_ins_type <= `INST_TYPE_ADD;
							end
						`FUNC_SUB: begin
							IF_ins_type <= `INST_TYPE_SUB;
							end
						`FUNC_AND: begin
							IF_ins_type <= `INST_TYPE_AND;
							end
						`FUNC_OR: begin
							IF_ins_type <= `INST_TYPE_OR;
							end
						`FUNC_NOR: begin
							IF_ins_type <= `INST_TYPE_NOR;
							end
						`FUNC_SLT: begin
							IF_ins_type <= `INST_TYPE_SLT;
							end
						`FUNC_SLL: begin
							IF_ins_type <= `INST_TYPE_SLL;
							end
						`FUNC_SRL: begin
							IF_ins_type <= `INST_TYPE_SRL;
							end
						`FUNC_SRA: begin
							IF_ins_type <= `INST_TYPE_SRA;
							end
						`FUNC_SLLV: begin
							IF_ins_type <= `INST_TYPE_SLL;
							end
						`FUNC_SRLV: begin
							IF_ins_type <= `INST_TYPE_SRL;
							end
						`FUNC_SRAV: begin
							IF_ins_type <= `INST_TYPE_SRA;
							end
						default: begin
							IF_ins_type <= `INST_TYPE_NONE;
						end
					endcase
				end
				`OP_ADDI: begin
					IF_ins_type <= `INST_TYPE_ADD;
				end
				`OP_ANDI: begin
					IF_ins_type <= `INST_TYPE_AND;
				end
				`OP_ORI: begin
					IF_ins_type <= `INST_TYPE_OR;
				end
				`OP_LW: begin
					IF_ins_type <= `INST_TYPE_LW;
				end
				`OP_SW: begin
					IF_ins_type <= `INST_TYPE_SW;
				end
				`OP_BEQ: begin
					IF_ins_type <= `INST_TYPE_BEQ;
				end
				`OP_JMP: begin
					IF_ins_type <= `INST_TYPE_JMP;
				end
				`OP_BNE: begin
					IF_ins_type <= `INST_TYPE_BNE;
				end
				default: begin
					IF_ins_type <= `INST_TYPE_NONE;
				end
			endcase
        end
    end

    instr_mem x_inst_mem(~clk, pc[7:0], inst_m);

endmodule

