
module output_unit_test(input clk, rst,
                   input [15:0]A,
                   output [0:6] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5,
                   output reg sign);
  
  wire [15:0] B;
  wire [3:0] ONES, TENS, HUNDREDS, THOUSANDS, TEN_THOUSANDS;
  wire [19:0] Rout;
  
  assign ONES          = Rout[3:0];
  assign TENS          = Rout[7:4];
  assign HUNDREDS      = Rout[11:8];
  assign THOUSANDS     = Rout[15:12];
  assign TEN_THOUSANDS = Rout[18:16];
  
  twos_comp T1 (A,B);
  
  binary2bcd b1 (B,Rout);
 
  binary2seven  hex0(ONES, HEX0);
  binary2seven  hex1(TENS, HEX1);
  binary2seven  hex2(HUNDREDS, HEX2);
  binary2seven  hex3(THOUSANDS, HEX3);
  binary2seven2 hex4(TEN_THOUSANDS, HEX4);
 
  always @(negedge clk) begin
    if (A[15] == 1'b1) sign <= 1'b0;
    else sign <= 1'b1;
  end

  assign HEX5[6] = sign;
  
endmodule

module ha (input a,b,output s, cout);

 assign s = a^b;
 assign cout = a&b;

endmodule

module twos_comp_sign_mag (input [15:0] a, output [15:0] b);

wire [15:0] c;

ha ha0 (a[0]^a[15], a[15], b[0], c[0]);
ha ha1 (a[1]^a[15], c[0], b[1], c[1]);
ha ha2 (a[2]^a[15], c[1], b[2], c[2]);
ha ha3 (a[3]^a[15], c[2], b[3], c[3]);
ha ha4 (a[4]^a[15], c[3], b[4], c[4]);
ha ha5 (a[5]^a[15], c[4], b[5], c[5]);
ha ha6 (a[6]^a[15], c[5], b[6], c[6]);
ha ha7 (a[7]^a[15], c[6], b[7], c[7]);
ha ha8 (a[8]^a[15], c[7], b[8], c[8]);
ha ha9 (a[9]^a[15], c[8], b[9], c[9]);
ha ha10(a[10]^a[15], c[9], b[10],c[10]);
ha ha11(a[11]^a[15], c[10],b[11],c[11]);
ha ha12(a[12]^a[15], c[11],b[12],c[12]);
ha ha13(a[13]^a[15], c[12],b[13],c[13]);
ha ha14(a[14]^a[15], c[13],b[14],c[14]);

ha ha15(a[15], 0, b[15], c[15]);

endmodule


module add3(input [3:0] in,output reg [3:0] out);

 always @ (in)

 case (in)
 4'b0000: out = 4'b0000;
 4'b0001: out = 4'b0001;
 4'b0010: out = 4'b0010;
 4'b0011: out = 4'b0011;
 4'b0100: out = 4'b0100;
 4'b0101: out = 4'b1000;
 4'b0110: out = 4'b1001;
 4'b0111: out = 4'b1010;
 4'b1000: out = 4'b1011;
 4'b1001: out = 4'b1100;
 default: out = 4'b0000;
 endcase

endmodule

module binary2bcd(input [7:0] A, output [3:0] ONES, TENS,output [1:0] HUNDREDS);

wire [3:0] c1,c2,c3,c4,c5,c6,c7;
wire [3:0] d1,d2,d3,d4,d5,d6,d7;

assign d1 = {1'b0,A[7:5]};
assign d2 = {c1[2:0],A[4]};
assign d3 = {c2[2:0],A[3]};
assign d4 = {c3[2:0],A[2]};
assign d5 = {c4[2:0],A[1]};
assign d6 = {1'b0,c1[3],c2[3],c3[3]};
assign d7 = {c6[2:0],c4[3]};
assign ONES = {c5[2:0],A[0]};
assign TENS = {c7[2:0],c5[3]};
assign HUNDREDS = {c6[3],c7[3]};

//instantiations
add3 m1(d1,c1);
add3 m2(d2,c2);
add3 m3(d3,c3);
add3 m4(d4,c4);
add3 m5(d5,c5);
add3 m6(d6,c6);
add3 m7(d7,c7);

endmodule



// Divide by N counter with M state variables

module divideXn #(parameter N=5, parameter M=3)(input CLOCK, CLEAR,output reg [M-1:0] COUNT,output reg OUT);

always @ (negedge CLOCK, negedge CLEAR)

 if (CLEAR == 1'b0)
  COUNT<=0;
  else 
  
  begin
  
  if (COUNT == N-2'd2) begin OUT<= 1'b1; COUNT <= N-1'd1; end
  else
  if (COUNT == N-1'd1) begin OUT <= 1'b0; COUNT <= 0; end
  else begin OUT <= 1'b0; COUNT <= COUNT + 1'b1; end
  
  end
  
  endmodule
  
 // n bit binary counter
 
 module NbitBinCount # (parameter N = 8)
  ( input COUNT, CLEAR,
    output reg[N-1:0] y);
	 
  always @ (posedge COUNT, negedge CLEAR)
  if (CLEAR == 1'b0) y<=0;
  else y<=y+1'b1;
  
  endmodule
  
  module OneHzClock (input clock, reset, output OneHz);
  
   wire TenHz, OneMHz, OneKHz;
	
	divideXn # (3'd5, 3'd3) div5
	(.CLOCK(clock),
	 .CLEAR(reset),
	 .OUT(TenMHz),
	 .COUNT(count));
	 
	 divideXn #(4'd10, 4'd4) div10
	 (
	  .CLOCK(TenMHz),
	  .CLEAR(reset),
	  .OUT(OneMHZ),
	  .COUNT(count));
	  
	  divideXn #(10'd1000, 4'd10) div1000L
	  (
	   .CLOCK(OneMHz),
		.CLEAR(reset),
		.OUT(OneKHz),
		.COUNT(count));
		
		divideXn #(10'd1000, 4'd10) div1000H
	  (
	   .CLOCK(OneMHz),
		.CLEAR(reset),
		.OUT(OneHz),
		.COUNT(count));
	  
  endmodule
  
  module binary2seven (
input [3:0] BIN,
output reg [0:6] SEV);

always @ (BIN)

case ({BIN[3:0]})

4'b0000: {SEV[0:6]} = 7'b0000001;//0
4'b0001: {SEV[0:6]} = 7'b1001111;//1
4'b0010: {SEV[0:6]} = 7'b0010010;//2
4'b0011: {SEV[0:6]} = 7'b0000110;//3
4'b0100: {SEV[0:6]} = 7'b1001100;//4
4'b0101: {SEV[0:6]} = 7'b0100100;//5
4'b0110: {SEV[0:6]} = 7'b0100000;//6
4'b0111: {SEV[0:6]} = 7'b0001111;//7
4'b1000: {SEV[0:6]} = 7'b0000000;//8
4'b1001: {SEV[0:6]} = 7'b0001100;//9
4'b1010: {SEV[0:6]} = 7'b0001000;//A
4'b1011: {SEV[0:6]} = 7'b1100000;//b
4'b1100: {SEV[0:6]} = 7'b0110001;//C
4'b1101: {SEV[0:6]} = 7'b1000010;//d
4'b1110: {SEV[0:6]} = 7'b0110000;//E
4'b1111: {SEV[0:6]} = 7'b0111000;//F

endcase

endmodule