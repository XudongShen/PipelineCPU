module imm2sa(odata_imm,sa);
    input[31:0] odata_imm;
    output[31:0] sa;
    
    assign sa = {27'b0,odata_imm[10:6]};

endmodule

