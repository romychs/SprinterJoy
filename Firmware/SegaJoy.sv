/*
 * Модуль опроса джойстиков
 */
module SegaJoy(
	input reg clk,
	input wire reset,
	output reg sel1,
	output reg sel2,
	input wire [5:0] sj1,
	input wire [5:0] sj2,
	output reg [11:0] status1,
	output reg [11:0] status2,
   output reg [1:0] sj_type1,
   output reg [1:0] sj_type2
);

   localparam [7:0] divisor = 180;
	reg [7:0] cycle;
	
	reg [5:0] s0;
	reg [5:0] s1;
	reg [5:0] s4;
	reg [5:0] s5;
	reg [5:0] s6;
	
	reg [11:0] combo;
	
	always_ff @ (posedge clk, posedge reset)
		if (reset) begin
			cycle <= 8'h00;
			sel1 <= 1'b0;
			sel2 <= 1'b0;
			status1 <= 12'h000;
			status2 <= 12'h000;
		end else begin
			case (cycle)
			
         // JOY 1
         
         0: sel1 <= 0;
			1:	s0 <= sj1;
			
			2: sel1 <= 1;
			3: s1 <= sj1;
			
			4: sel1 <= 0;
			//8: s2 <= sj1;
			
			6: sel1 <= 1;
			//11: s3 <= sj1;
			
			8: sel1 <= 0;
			9: s4 <= sj1;
			
			10: sel1 <= 1;
			11: s5 <= sj1;
			
			12: sel1 <= 0;
			13: s6 <= sj1;
			
			
			14: begin
                //sj_dbg <= s4;
                combo <= ~({s5[3:0], s0[5:4], s1});
				    
                if (s4[1:0] == 2'b00 && s6[3:0] == 4'b1111) sj_type1 <= 2'b10;
                else if (s6[3:2] == 2'b00) sj_type1 <= 2'b01;
                else sj_type1 <= 2'b00;
                
				 end
			15: 
				/*  Все значения получены, фиксируем результаты */
				case (sj_type1)
				2'b10: status1 <= combo;
				2'b01: status1 <= {4'b0000, combo[7:0]};
				default:
					status1 <= {6'b000000, combo[5:0]};
				endcase
			
         // JOY 2
         
         16: sel2 <= 0;
			17:	s0 <= sj2;
			
			18: sel2 <= 1;
			19: s1 <= sj2;
			
			20: sel2 <= 0;
			//8: s2 <= sj2;
			
			22: sel2 <= 1;
			//11: s3 <= sj2;
			
			24: sel2 <= 0;
			25: s4 <= sj2;
			
			26: sel2 <= 1;
			27: s5 <= sj2;
			
			28: sel2 <= 0;
			29: s6 <= sj2;
						
			30: begin
                //sj_dbg <= s4;
                combo <= ~({s5[3:0], s0[5:4], s1});
				    
                if (s4[1:0] == 2'b00 && s6[3:0] == 4'b1111) sj_type2 <= 2'b10;
                else if (s6[3:2] == 2'b00) sj_type2 <= 2'b01;
                else sj_type2 <= 2'b00;
                
				 end
			31: 
				/*  Все значения получены, фиксируем результаты */
				case (sj_type2)
				2'b10: status2 <= combo;
				2'b01: status2 <= {4'b0000, combo[7:0]};
				default:
					status2 <= {6'b000000, combo[5:0]};
				endcase
         
         endcase
      
         if (cycle == divisor) cycle <= 8'hff;
         else  cycle <= cycle + 1'b1;
          
		end

endmodule


