module Single_cycle_datapath(
    input clk,
    input reset,
    input PCsrc,
    input Regfile_write_en,
    input ALU_src,
    input datamem_write_en,
    input resultmux_select,
    input [1:0]R14_select_address,
    input R14_data_select,
    input shift_type_sel,
    input [1:0]shifter_select,
    input [1:0] Regsrc,
    input [1:0] Immsrc,
    input [3:0] ALUcontrol,
    input [3:0] Debug_in,
    output [31:0] Debug_out,
    output Zero_Flag,
    output wire [3:0] COND,
    output wire [1:0] OP,
    output wire [5:0] FUNCT,
    output wire [3:0] RD__,
    output [31:0] pc_out
    );

assign pc_out = PC_;
    //Wire declares
wire [31:0] PCplus4, PCplus8, resultante, PC_, PC_prime;
wire [31:0] Inst;
wire [3:0] RA1, RA2;
wire [31:0] RD1, RD2;
wire [31:0] Extended_imm;

wire [31:0] SRCB;

wire [4:0] shift_amount;
wire [31:0] shift_out;

wire [31:0] ALUresult;

wire [31:0] Readdata;

wire [3:0] R14_or_address;

wire [31:0] res_or_plus4;

assign RD__ = Inst[15:12];
assign FUNCT = Inst[25:20];
assign OP = Inst[27:26];
assign COND = Inst[31:28];


    //MUX of PC---- Chooses PC source
Mux_2to1 #(.WIDTH(32))mux_PC_Source(
    .select(PCsrc),
    .input_0(PCplus4),
    .input_1(resultante),
    .output_value(PC_prime)
);
    // Program Counter
Register_reset #(.WIDTH(32)) Program_Counter(
    .clk(clk),
    .reset(reset),
    .DATA(PC_prime),
    .OUT(PC_)
);
    // Instruction memory
Instruction_memory Inst_mem(
    .ADDR(PC_),
    .RD(Inst)
);
    //PC adder 1
Adder adder1(
    .DATA_A(PC_),
    .DATA_B(32'd4),
    .OUT(PCplus4)
);
    //PC adder 2
Adder adder2(
    .DATA_A(PCplus4),
    .DATA_B(32'd4),
    .OUT(PCplus8)
);
    //Register Source MUXes
Mux_2to1 Mux_regsrc_1 (
    .select(Regsrc[0]),
    .input_0(Inst[19:16]),
    .input_1(4'b1111),
    .output_value(RA1)
);
Mux_2to1 Mux_regsrc_2 (
    .select(Regsrc[1]),
    .input_0(Inst[3:0]),
    .input_1(Inst[15:12]),
    .output_value(RA2)
);

Mux_4to1 MUX_R14 (
    .select(R14_select_address),
    .input_0(Inst[15:12]),
    .input_1(4'b1110),  //R14
    .input_2(),
    .input_3(4'b1111),
    .output_value(R14_or_address)
);

Mux_2to1 #(.WIDTH(32))PC_plus_4_or_result (
    .select(R14_data_select),
    .input_0(resultante),
    .input_1(PCplus4),  
    .output_value(res_or_plus4)
);

    // Register file
Register_file Reg_file(
    .clk(clk),
    .write_enable(Regfile_write_en),
    .reset(reset),
    .Source_select_0(RA1),
    .Source_select_1(RA2),
    .Debug_Source_select(Debug_in),
    .Destination_select(R14_or_address),
    .DATA(res_or_plus4),
    .Reg_15(PCplus8),
    .out_0(RD1),
    .out_1(RD2),
    .Debug_out(Debug_out)
);
    // Extender
Extender extender(
    .DATA(Inst[23:0]),
    .select(Immsrc),
    .Extended_data(Extended_imm)
);

    //MUX of ALU source B
Mux_2to1 #(.WIDTH(32)) ALU_mux (
    .select(ALU_src),
    .input_0(RD2),
    .input_1(Extended_imm),
    .output_value(SRCB)
);
    //MUX of Shifter --- shamt of shifter
Mux_4to1 #(.WIDTH(5)) shift_amount_mux (
    .select(shifter_select),
    .input_0(5'b00000),
    .input_1(5'b00001),
    .input_2(Inst[11:7]),
    .input_3(),
    .output_value(shift_amount)
);
    //MUX OF Shifter ---- Shift Select

wire [1:0] shift_type;

Mux_2to1 #(.WIDTH(2)) shift_select_mux (
    .select(shift_type_sel),
    .input_0(Inst[6:5]),
    .input_1(2'b11),
    .output_value(shift_type)
);

    //Shifter
shifter #(.WIDTH(32)) shifter(
    .control(shift_type),            //Buraya MUX gerekicek rotate için MOV operasyonunda
    .shamt(shift_amount),
    .DATA(SRCB),
    .OUT(shift_out)
);
    // ALU
ALU #(.WIDTH(32)) alu(
    .control(ALUcontrol),
    .CI(),
    .DATA_A(RD1),
    .DATA_B(shift_out),
    .OUT(ALUresult),
    .CO(),
    .OVF(),
    .N(),
    .Z(Zero_Flag)
);

    // Data Memory
Memory data_memory(
    .clk(clk),
    .WE(datamem_write_en),
    .ADDR(ALUresult),
    .WD(RD2),
    .RD(Readdata)
);  
    //MUX of Result
Mux_2to1 #(.WIDTH(32)) result_mux (
    .select(resultmux_select),
    .input_0(ALUresult),
    .input_1(Readdata),
    .output_value(resultante)
);


endmodule