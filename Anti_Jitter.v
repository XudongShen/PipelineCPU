module Anti_Jitter(input wire clk,
	input wire button,
	output reg pbreg
	);
   
	reg [7:0] pbshift;
	wire clk_1ms;
	timer_1ms m0(clk, clk_1ms);
	
	always@(posedge clk_1ms) begin
		pbshift = pbshift << 1;//左移 1 位
		pbshift[0] = button;
		if (pbshift == 0)
			pbreg = 0;
		if (pbshift == 8'hFF)// pbshift 八位全为 1
			pbreg = 1;
	end//防抖动函数

endmodule

module timer_1ms(
	input wire clk,
	output reg clk_1ms
	);

	reg [15:0] cnt;
	
	initial begin
		cnt [15:0] <= 0;
		clk_1ms <= 0;
	end
	
	always@(posedge clk)
	if(cnt >= 25000) begin
		cnt <= 0;
		clk_1ms <= ~clk_1ms;
	end
	else begin
		cnt <= cnt+1;
	end//分频的1ms的时钟
	
endmodule
