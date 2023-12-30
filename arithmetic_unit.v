// Code your testbench here
// or browse Examples

module alu(input[3:0]operation,
                              input[7:0]IN,
                              input Loadresult,
                              input Clear,Clock,reset,
                              input  ldA,ldB,Start,
                              output reg[7:0]R,
										output reg Halt,
										output reg [7:0]resultone,
										output reg [7:0]resulttwo,
										output [15:0]multiresult,
										output [7:0]addsubresult,
										output [7:0]divisionQresult,
										output [7:0]divisionRresult,
										output reg[7:0]INaddsub,
										output reg [7:0]INmultiply,
										output reg[7:0]INdivision,
										output [7:0]Aout,Bout);

reg addsub;
wire OVR,Zero,Neg;
wire [15:0]Product;

wire [3:0]CCout;
wire Done,done;

always@(posedge Clock)

case(operation)

4'b1000:begin INaddsub<=IN;addsub<=1'b1;resultone<=8'b00000000;resulttwo<=addsubresult;R<=8'b00000000;end

4'b0100:begin INaddsub<=IN;addsub<=1'b0;resultone<=8'b00000000;resulttwo<=addsubresult;R<=8'b00000000;end

4'b0010:begin INmultiply<=IN;resultone<=multiresult[15:8];resulttwo<=multiresult[7:0];R<=8'b00000000;Halt<=done;end

4'b0001:begin INdivision<={8'b00000000,IN[7:0]};resultone<=8'b00000000;resulttwo<=divisionQresult;R<=divisionRresult;Halt<=Done;end

endcase
  
adder_sub adder_sub(.IN(INaddsub),
                .Add_subtract(addsub),
                .lnA(ldA),
                .lnB(ldB),
                .out(Loadresult),
                .Clear(Clear),
                .Rout(addsubresult),
                .OVR(OVR),
                .Zero(Zero),
                .Neg(Neg),
                .CCout(CCout),
                .Aout(Aout),
                .Bout(Bout));
  
multiplier multiplier(.clock(Clock),
                .Reset(reset),
                .ldM(ldA),
                .ldQ(ldB),
                .ldR(Loadresult),
                .IN(INmultiply),
                .calculation(Start),
                .Product(Product), 
                .Halt(done),
                .out(multiresult));
  
Divider Divider(.IN(INdivision),
                .ldoneA(1'b1), 
                .ldB(ldb),
                .ldtwoA(ldA),
                .ldR(Loadresult),
                .clock(Clock),
                .start(Start),
                .reset(reset),
                .answer(divisionQresult),
                .remains(divisionRresult),
                .done(Done));
  
endmodule

