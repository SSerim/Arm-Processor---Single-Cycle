module Single_Cycle_Computer(
    input clk,
    input reset,
    input [3:0] debug_reg_select,
    output [31:0] debug_reg_out,
    output [31:0] fetchPC 
);
wire PCsrc, Regfile_write_en, ALU_src, datamem_write_en, resultmux_select, R14_data_select, shift_type_sel, Zero_Flag;
wire [1:0] R14_select_address, shifter_select, Regsrc, Immsrc;
wire [3:0] ALUcontrol;

wire [3:0] COND;
wire [1:0] OP;
wire [5:0] FUNCT;
wire [3:0] RD__;

Single_cycle_datapath data_path(
    .clk(clk),
    .reset(reset),
    .PCsrc(PCsrc),
    .Regfile_write_en(Regfile_write_en),
    .ALU_src(ALU_src),
    .datamem_write_en(datamem_write_en),
    .resultmux_select(resultmux_select),
    .R14_select_address(R14_select_address),
    .R14_data_select(R14_data_select),
    .shift_type_sel(shift_type_sel),
    .shifter_select(shifter_select),
    .Regsrc(Regsrc),
    .Immsrc(Immsrc),
    .ALUcontrol(ALUcontrol),
    .Debug_in(debug_reg_select),
    .Debug_out(debug_reg_out),
    .Zero_Flag(Zero_Flag),
    .COND(COND),
    .OP(OP),
    .FUNCT(FUNCT),
    .RD__(RD__),
    .pc_out(fetchPC)
    );

Controller controlcu(
    .Debug_out(),
    .Zero_Flag(Zero_Flag),
    .COND(COND),
    .OP(OP),
    .FUNCT(FUNCT),
    .RD__(RD__),
    .shift_type_sel(shift_type_sel),
    .PCsrc(PCsrc),
    .Regfile_write_en(Regfile_write_en),
    .ALU_src(ALU_src),
    .datamem_write_en(datamem_write_en),
    .resultmux_select(resultmux_select),
    .R14_select_address(R14_select_address),
    .R14_data_select(R14_data_select),
    .shifter_select(shifter_select),
    .Regsrc(Regsrc),
    .Immsrc(Immsrc),
    .ALUcontrol(ALUcontrol)
);


endmodule