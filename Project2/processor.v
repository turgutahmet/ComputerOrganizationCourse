module processor;
reg [31:0] pc; //32-bit prograom counter
reg clk,statusReg; //clock
reg [7:0] datmem[0:31],mem[0:31]; //32-size data and instruction memory (8 bit(1 byte) for each location)
wire [31:0] 
dataa,	//Read data 1 output of Register File
datab,	//Read data 2 output of Register File
out2,		//Output of mux with ALUSrc control-mult2
out3,		//Output of mux with MemToReg control-mult3
out4,		//Output of mux with (Branch&ALUZero) control-mult4
jalAddress, //TR pc 25:0 adresi 32 ye çekilen kablo.
out6, 		//TR 6.mux için out5
out7,		//TR 7.mux bltz balrz muxu
out8,		//TR 8.mux bltz nout and gate muxu
out9,		//TR 9.mux out8 den pc ye 
out10,		//TR 10.mux link31
out11,		//TR 11.mux extend
sum,		//ALU result
extad,	//Output of sign-extend unit
zeroextended, //TR zero extend için 
adder1out,	//Output of adder which adds PC and 4-add1
adder2out,	//Output of adder which adds PC+4 and 2 shifted sign-extend result-add2
sextad;	//Output of shift left 2 unit


wire [5:0] inst31_26;	//31-26 bits of instruction
wire [4:0]
inst25_21,	//25-21 bits of instruction
inst20_16,	//20-16 bits of instructions
inst15_11,	//15-11 bits of instruction
out1,
out5;		//Write data input of Register File

wire [15:0] inst15_0;	//15-0 bits of instruction

wire [31:0] instruc,	//current instruction
dpack;	//Read data output of memory (data read from memory)

wire [2:0] gout;	//Output of ALU control unit

wire zout,	//Zero output of ALU
pcsrc,	//Output of AND gate with Branch and ZeroOut inputs
balrzorbltz, //TR balrz bltz OR gate eklendi.
nout,//TR nout signali negatif için eklendi.
negbltz, //TR nout & bltz gate i için.
balrzStatus, //TR balrz ve status gate i
jmStatusBalrz,
//Control signals
regdest,alusrc,memtoreg,regwrite,memread,memwrite,branch,aluop1,aluop0,link31,jump,balrz,bltz,jm,extend,sllv;

//32-size register file (32 bit(1 word) for each register)
reg [31:0] registerfile[0:31];

integer i;

// datamemory connections

always @(posedge clk)
//write data to memory
if (memwrite)
begin
//sum stores address,datab stores the value to be written
datmem[sum[4:0]+3]=datab[7:0];
datmem[sum[4:0]+2]=datab[15:8];
datmem[sum[4:0]+1]=datab[23:16];
datmem[sum[4:0]]=datab[31:24];
end

//instruction memory
//4-byte instruction
 assign instruc={mem[pc[4:0]],mem[pc[4:0]+1],mem[pc[4:0]+2],mem[pc[4:0]+3]};
 assign inst31_26=instruc[31:26];
 assign inst25_21=instruc[25:21];
 assign inst20_16=instruc[20:16];
 assign inst15_11=instruc[15:11];
 assign inst15_0=instruc[15:0];

wire [25:0] jumpWire; //TR Yukarıdaki 25-0 lık kablomuz
assign jumpWire = instruc[25:0]; //TR 25-0 instructiondan aldık

wire [27:0] shiftLeftJump;
assign shiftLeftJump = {jumpWire, 2'b00};

assign jalAddress = { adder1out[31:28], shiftLeftJump};

// registers

assign dataa=registerfile[inst25_21];//Read register 1
assign datab=registerfile[inst20_16];//Read register 2
always @(posedge clk)
registerfile[out5]= regwrite ? out10:registerfile[out5];//Write data to register

//read data from memory, sum stores address
assign dpack={datmem[sum[5:0]],datmem[sum[5:0]+1],datmem[sum[5:0]+2],datmem[sum[5:0]+3]};


always @(zout or balrz or statusReg)
begin
if (~balrz)
begin
	statusReg = 1'b0;
	if (zout)
		statusReg = 1'b1;
end
end

//multiplexers
//mux with RegDst control
mult2_to_1_5  mult1(out1, instruc[20:16],instruc[15:11],regdest);

//mux with ALUSrc control
mult2_to_1_32 mult2(out2, datab,out11,alusrc);

//mux with MemToReg control
mult2_to_1_32 mult3(out3, sum,dpack,memtoreg);

//mux with (Branch&ALUZero) control
mult2_to_1_32 mult4(out4, adder1out,adder2out,pcsrc);

//TR MUX EKLENDİ 11111 31.REGİSTER
mult2_to_1_5 mult5(out5, out1, 5'b11111,link31);

//TR MUX branchden sonraki ekleniyor
mult2_to_1_32 mult6(out6, out4, jalAddress, jump);

//TR MUX or gate balrz or bltz
mult2_to_1_32 mult7(out7, out2, 32'b0, balrzorbltz);

//TR MUX nout &bltz signali ile kontrol edilen MUX
mult2_to_1_32 mult8(out8, out7, adder2out, negbltz);

//TR MUX out8 & memtoreg muxu en sağ üstteki
mult2_to_1_32 mult9(out9, out8, out3, jmStatusBalrz);

//TR MUX link31 ile kontrol edilen write data outputlu
mult2_to_1_32 mult10(out10, out3, adder1out, link31);

//TR MUX extend ile kontrol edilen mux
mult2_to_1_32 mult11(out11, extad, zeroextended , extend );

// load pc
always @(posedge clk)
pc=out9;

// alu, adder and control logic connections

//ALU unit
alu32 alu1(sum,dataa,out7,zout,nout,gout);

//adder which adds PC and 4
adder add1(pc,32'h4,adder1out);

//adder which adds PC+4 and 2 shifted sign-extend result
adder add2(adder1out,sextad,adder2out);

//Control unit
control cont(instruc[31:26],regdest,alusrc,memtoreg,regwrite,memread,memwrite,branch,
aluop1,aluop0,link31,jump,balrz,bltz,jm,extend,sllv);

//Sign extend unit
signext sext(instruc[15:0],extad);

//Zero extend unit
zeroextend zext(instruc[15:0],zeroextended);

//ALU control unit
alucont acont(aluop1,aluop0,instruc[3],instruc[2], instruc[1], instruc[0], bltz, gout, instruc[4],instruc[5],balrz,sllv);

//Shift-left 2 unit
shift shift2(sextad,out11);

//AND gate
assign pcsrc=branch && zout;

// OR gate balrz | bltz
assign balrzorbltz = balrz | bltz; //TR BALRZ BLTZ OR GATE

// AND gate bltz & nout
assign negbltz = bltz && nout;

//AND gate balrz && status
assign balrzStatus = balrz && statusReg;

//OR gate balrzStatus&&jm
assign jmStatusBalrz = balrzStatus && jm;


//initialize datamemory,instruction memory and registers
//read initial data from files given in hex
initial
begin
$readmemh("initDM.dat",datmem); //read Data Memory
$readmemh("initIM.dat",mem);//read Instruction Memory
$readmemh("initReg.dat",registerfile);//read Register File

	for(i=0; i<31; i=i+1)
	$display("Instruction Memory[%0d]= %h  ",i,mem[i],"Data Memory[%0d]= %h   ",i,datmem[i],
	"Register[%0d]= %h",i,registerfile[i]);
end

initial
begin
pc=0;

end
initial
begin
clk=0;
//40 time unit for each cycle
forever #20  clk=~clk;
end
initial
begin
	$monitor($time,"PC %h",pc,"  SUM %h",sum,"   INST %h",instruc[31:0],
"   REGISTER %h %h %h %h ",registerfile[4],registerfile[5], registerfile[6],registerfile[1] );
end
endmodule

