//
// Sprinter
// Интерфейс Sega-джойстиков для ISA шины 
//
module SprinterJoy (
	
	// Сигналы шины ISA
	input wire clk14,			   // 14MHz ISA Clock
	input wire clk50,			   // 50MHz Oscillator Clock
	
	input wire reset,		      // ISA RESET 
	input wire ior_n,		      // ISA -IOR
	
	input wire [15:0] a,		   // ISA A0-A15
	inout wire [7:0] d,		   // ISA D0-D7

	input wire [5:0] sj1,		// Sega Joystick 1
										// 0 - UP
										// 1 - DN
										// 2 - LT
										// 3 - RT
										// 4 - B
										// 5 - C
	output wire sj1_sel,			// Sega Joystick SEL sygnal
   
	input wire [5:0] sj2,		// Sega Joystick 2
	output wire sj2_sel			// Sega Joystick 2 SEL sygnal

);


	reg [11:0] sj1_status;
   reg [1:0] sj1_type;
   
	reg [11:0] sj2_status;
   reg [1:0] sj2_type;
   
   //reg [5:0] sj_dbg;
	
	reg [7:0] d_out;	// выходные данные
	
	assign d[7:0] = (port_r) ? d_out : 8'hzz;

	reg sj_clk;
	reg port_r;
	
	
	ClockGenerator clockGenerator(
	   .clk(clk50),
		.reset(reset),
		.sj_clk(sj_clk)
	);
	
	SegaJoy segaJoy(
	   .clk(sj_clk),
		.reset(reset),
		.sel1(sj1_sel),
		.sel2(sj2_sel),
		.sj1(sj1),
		.sj2(sj2),
		.status1(sj1_status),
		.status2(sj2_status),
      .sj_type1(sj1_type),      
      .sj_type2(sj2_type)      
	); 
	
	
	always_ff @ (posedge clk14, posedge reset)
		if (reset) begin
			port_r <= 0;
			
		end else begin
			if (a[11:2] == 10'b0010010100) begin                        // Выбран порт 0x250..0x253
				
				port_r <= !ior_n;
				if (port_r) begin
					case (a[1:0])
					//2'b00: d_out <= 8'h5D;									      // Порт 250 - 'SD' = Sega Joy, для детекта карты
					2'b00: d_out <= sj1_status[7:0];						         // Порт 250 - Младший байт состояния кнопок
					2'b01: d_out <= {sj1_type, 2'b00, sj1_status[11:8]};		// Порт 251 - Старший байт состояния кнопок (биты 7 и 6 - тип джойстика)
					2'b10: d_out <= sj2_status[7:0];						         // Порт 252 - Младший байт состояния кнопок
					2'b11: d_out <= {sj2_type, 2'b00, sj2_status[11:8]};		// Порт 253 - Старший байт состояния кнопок (биты 7 и 6 - тип джойстика)
					//default:
					//	d_out <= 8'h00;
					endcase;
				end;			
			end else begin
				port_r <= 0;
			end
		end
	
endmodule
