module control(in,regdest,alusrc,memtoreg,regwrite,memread,memwrite,branch,aluop1,aluop2,link31,jump,balrz,bltz,jm,extend,sllv);
input [5:0] in;
input wire balrz,sllv;
output regdest,alusrc,memtoreg,regwrite,memread,memwrite,branch,aluop1,aluop2,link31,jump,bltz,jm,extend;
wire rformat,lw,sw,beq,jal,balrzSig,bltzSig,jmSig,extendSig,ahmet;
assign rformat=~|in;
assign lw=in[5]& (~in[4])&(~in[3])&(~in[2])&in[1]&in[0];
assign sw=in[5]& (~in[4])&in[3]&(~in[2])&in[1]&in[0];
assign beq=~in[5]& (~in[4])&(~in[3])&in[2]&(~in[1])&(~in[0]);
assign jal=(~in[5])&(~in[4])&(~in[3])&(~in[2])&(in[1])&(in[0]);
assign bltzSig = (~in[5])&(~in[4])&(~in[3])&(~in[2])&(~in[1])&(in[0]); // 0 0 0 0 0 1 opcode=1
assign jmSig = (~in[5])&(in[4])&(~in[3])&(~in[2])&(~in[1])&(~in[0]); // 0 1 0 0 0 0 opcode=16
assign extendSig = (~in[5])&(~in[4])&in[3]&in[2]&(~in[1])&in[0]; // 0 0 1 1 0 1 nori

assign extend = extendSig;
assign regdest=rformat;
assign alusrc=lw|sw| extendSig | jmSig; //noride alusrc 1*
assign memtoreg =lw | extendSig | sllv | balrz; //nori de memtoreg var 1  *
assign regwrite=rformat|lw | extendSig | jal | balrz; //noride regwrite 1 //jal için regwrite 1 olacak
assign memread=lw | jmSig;
assign memwrite=sw;
assign branch=beq;
assign aluop1=rformat | extendSig; //nori için 11 aluop *
assign aluop2=beq | bltzSig | extendSig; //bltzsig de alu op 01 yazmışız. *
assign link31= jal|balrz;
assign jump = jal;
assign bltz = bltzSig;
assign jm = jmSig ;

endmodule
