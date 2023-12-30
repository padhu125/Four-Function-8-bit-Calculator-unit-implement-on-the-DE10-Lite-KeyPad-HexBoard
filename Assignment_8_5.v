module Assignment_8_5 (input enter_top,
									  clock_top,
									  add_subtract_top,
									  clear_top,
							  input add,sub,mul,div,equ,
							  input [3:0] row_top,
							  output[3:0] col_top,
							  output [6:0] hex0, hex1, hex2, hex3,
							  output sign);
							  
							  
 wire [7:0] input_unit_out, arithmetic_unit_out, mux_out ;
 wire clock_slow, edge_out, IU_AU, LnA, LnB, LnR, LnOU ;
 wire add_tmp,sub_tmp,equ_tmp;
 wire add1, sub1, mul1, div1, equ1;
 
 
 	clock_div #(32,2500000) clock_div_inst
	(
	 .clk(clock_top) , // input clk_sig
	 .reset(~clear_top) , // input reset_sig
	 .clk_out(clock_slow) // output clk_out_sig
	); 
	
	EdgeDetect EdgeDetect (.in(enter_top),
								  .clock(clock_slow),
								  .out(edge_out));
								  
	finite_state finite_state(.clear(clear_top), 
									  .enter(edge_out),
									  .add(add1),
									  .sub(sub1),
									  .mul(mul1),
									  .div(div1),
									  .equ(equ1) 
									  .LdA_cu_t(LnA), 
									  .LdB_cu_t(LnB), 
									  .equ(LnR), 
									  .reset_cu_t(IU_AU),
									  .LnOU(LnOU));							  

  input_unit input_unit    (.clk(clock_slow), 
									 .reset(clear_top),
									 .row_top(row_top), 
									 .col_top(col_top), 
									 .out(input_unit_out),
									 .add(add1),
									 .sub(sub1),
									 .mul(mul1),
									 .div(div1),
									 .equ(equ1));
									 
  alu arithmetic_unit (.clk(clock_slow),
							  .in(input_unit_out),
							  .ldA(LdA_cu_t),
							  .ldB(LdB_cu_t),
							  .add(add),
							  .sub(sub),
							  .mul(mul),
							  .div(div),
							  .equ(equ),
							  .result(arithmetic_unit_out));

											  												
  mux2_1(input_unit_out, arithmetic_unit_out, LnOU, mux_out);
			
  output_unit calculatorOU(clock_top,mux_out,HEX0,HEX1,HEX2,HEX3,sign); 

endmodule

// MUX

module mux2_1(input [7:0] in1, in2, input select, output [7:0] out);

 assign out = select ? in2 : in1;
  
endmodule

// Edge Detector

module EdgeDetect( input in, clock,
                   output out);
  
reg in_delay;
  
always @ (posedge clock)
in_delay <= in;
assign out = in & ~in_delay;
  
endmodule

module finite_state(input clock,clearall,clearentery,add,sub,mult,div,Done,enter,
                   input [7:0] A,B,
                   output[3:0]operation,
                   output reg LoadA,LoadB,Loadresult,LoadOU,IUAU,start);
  
  parameter S0=3'b001,S1=3'b010,S2=3'b011,S3=3'b100,S4=3'b101,S5=3'b110;
  
  reg[2:0] states;
  
assign operation={add,sub,mult,div};

always@(posedge clock, posedge clearall)
  case(states)
    S0: if(enter)states<=Enteroperation;
				  else states<=EnterA;
    S1:if(add==1||sub==1||mult==1||div==1)states<=EnterB;
    else if (clearall)states<=EnterA;
							else states<=Enteroperation;
    S2: if(enter)states<=Start;
    else if (clearall)states<=EnterA;
				  else states<=EnterB;
    S3: if(add==1||sub==1) states<=Storeresult;
    else if (Done==1) states<=Storeresult;
    else if (clearall)states<=EnterA;
				 else states<=Start;
    S4:if (clearall)states<=EnterA;
    else if (enter)states<=Displayresult;
    S5:if (clearall)states<=EnterA; 
	 else states<=Displayresult;
	endcase
  
always@(states)
begin
	case(states)
		S0:         begin LoadA=1'b0;LoadB=1'b1;start=1'b0;IUAU=1'b0;end
		S1:         begin LoadA=1'b1;LoadB=1'b1;start=1'b0;IUAU=1'b0;end
		S2:         begin LoadA=1'b1;LoadB=1'b0;start=1'b0;IUAU=1'b0;end
		S3:         begin LoadA=1'b1;LoadB=1'b1;start=1'b1;IUAU=1'b0;end
		S4:         begin LoadA=1'b1;LoadB=1'b1;start=1'b0;IUAU=1'b0;end
		S5:         begin LoadA=1'b1;LoadB=1'b1;start=1'b0;IUAU=1'b1;end
	endcase 
end
  
endmodule
				
	   
		
