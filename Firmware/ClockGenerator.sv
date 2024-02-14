/*
 * Делитель частоты для формирования сигнала опроса джойстика Sega
 */
module ClockGenerator (
	input wire clk,		  // Input clock
	input wire reset,
	output reg sj_clk		  // Clock for sega joystick
);

	reg [5:0] clk_ctr;
	localparam [5:0] divisor = 34;
	//assign sj_clk = clk_ctr[7];
	
	always_ff @ (posedge clk, posedge reset)
     
   if (reset) begin
			clk_ctr <= 6'h00;
			sj_clk <= 1'b0;
      end
		else begin
			if (clk_ctr == divisor) begin
				clk_ctr <= 6'h00;
				sj_clk <= !sj_clk;
			end
			else clk_ctr <= clk_ctr + 1'b1;
		end

endmodule
