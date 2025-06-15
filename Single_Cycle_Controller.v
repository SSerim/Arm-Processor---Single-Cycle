module Controller(
    input [31:0] Debug_out,
    input Zero_Flag,
    input [3:0] COND,
    input [1:0] OP,
    input [5:0] FUNCT,
    input [3:0] RD__,
    output reg shift_type_sel,
    output reg PCsrc,
    output reg Regfile_write_en,
    output reg ALU_src,
    output reg datamem_write_en,
    output reg resultmux_select,
    output reg [1:0]R14_select_address,
    output reg R14_data_select,
    output reg [1:0] shifter_select,
    output reg [1:0] Regsrc,
    output reg [1:0] Immsrc,
    output reg [3:0] ALUcontrol
);
    // Check the conditions
reg condition_met;

always @(*) begin
    case (COND)
        4'b0000: condition_met = (Zero_Flag == 1); // EQ (Equal)
        4'b0001: condition_met = (Zero_Flag == 0); // NE (Not Equal)
        4'b1110: condition_met = 1;               // AL (Always)
        default: condition_met = 0;
    endcase
end
always @(*) begin
PCsrc = 0;
Regfile_write_en = 0;
ALU_src = 0;
datamem_write_en = 0;
resultmux_select = 0;
R14_select_address = 0;
R14_data_select = 0;
shifter_select = 2'b0;
Regsrc = 2'b0;
Immsrc = 2'b0;
ALUcontrol = 4'b0;
shift_type_sel = 1'b0;

//Data Processing Instructions

    if (condition_met) begin
        case (OP)
            2'b00: begin    //Data Processing Instructions
                case (FUNCT)
                    6'b010000: begin        //ADD
                    PCsrc = 1'b0;
                    Regsrc = 2'b00;
                    R14_select_address = 2'b00;
                    R14_data_select = 1'b0;
                    Immsrc = 2'b00;
                    ALU_src = 1'b0;
                    shifter_select = 2'b10;
                    shift_type_sel = 1'b0;
                    ALUcontrol = 4'b0100;
                    datamem_write_en = 1'b0;
                    resultmux_select = 1'b0;
                    Regfile_write_en = 1'b1;
                    end
                    6'b000100: begin        //SUB
                    PCsrc = 1'b0;
                    Regsrc = 2'b00;
                    R14_select_address = 2'b00;
                    R14_data_select = 1'b0;
                    Immsrc = 2'b00;
                    ALU_src = 1'b0;
                    shifter_select = 2'b10;
                    shift_type_sel = 1'b0;
                    ALUcontrol = 4'b0110;
                    datamem_write_en = 1'b0;
                    resultmux_select = 1'b0;
                    Regfile_write_en = 1'b1;
                    end
                    6'b000000: begin        //AND
                    PCsrc = 1'b0;
                    Regsrc = 2'b00;
                    R14_select_address = 2'b00;
                    R14_data_select = 1'b0;
                    Immsrc = 2'b00;
                    ALU_src = 1'b0;
                    shifter_select = 2'b10;
                    shift_type_sel = 1'b0;
                    ALUcontrol = 4'b0000;
                    datamem_write_en = 1'b0;
                    resultmux_select = 1'b0;
                    Regfile_write_en = 1'b1;
                    end
                    6'b011000: begin        //ORR
                    PCsrc = 1'b0;
                    Regsrc = 2'b00;
                    R14_select_address = 2'b00;
                    R14_data_select = 1'b0;
                    Immsrc = 2'b00;
                    ALU_src = 1'b0;
                    shifter_select = 2'b10;
                    shift_type_sel = 1'b0;
                    ALUcontrol = 4'b1100;
                    datamem_write_en = 1'b0;
                    resultmux_select = 1'b0;
                    Regfile_write_en = 1'b1;
                    end
                    6'b011010: begin        //MOV
                    PCsrc = 1'b0;
                    Regsrc = 2'b00;
                    R14_select_address = 2'b00;
                    R14_data_select = 1'b0;
                    Immsrc = 2'b00;
                    ALU_src = 1'b0;
                    shifter_select = 2'b10;
                    shift_type_sel = 1'b0;
                    ALUcontrol = 4'b1101;
                    datamem_write_en = 1'b0;
                    resultmux_select = 1'b0;
                    Regfile_write_en = 1'b1;
                    end
                    6'b111010: begin        //MOV Immediate
                    PCsrc = 1'b0;
                    Regsrc = 2'b00;
                    R14_select_address = 2'b00;
                    R14_data_select = 1'b0;
                    Immsrc = 2'b00;
                    ALU_src = 1'b1;
                    shifter_select = 2'b01;
                    shift_type_sel = 1'b1;
                    ALUcontrol = 4'b1101;
                    datamem_write_en = 1'b0;
                    resultmux_select = 1'b0;
                    Regfile_write_en = 1'b1;
                    end
                    6'b010101: begin        //CMP
                    PCsrc = 1'b0;
                    Regsrc = 2'b00;
                    R14_select_address = 2'b00;
                    R14_data_select = 1'b0;
                    Immsrc = 2'b00;
                    ALU_src = 1'b0;
                    shifter_select = 2'b10;
                    shift_type_sel = 1'b0;
                    ALUcontrol = 4'b0010;
                    datamem_write_en = 1'b0;
                    resultmux_select = 1'b0;
                    Regfile_write_en = 1'b0;
                    end 

                endcase
                end

            2'b01: begin    //memory Instructions
            case(FUNCT) 
                6'b001000: begin        //STR
                    PCsrc = 1'b0;
                    Regsrc = 2'b01;
                    R14_select_address = 2'b00;  
                    R14_data_select = 1'b0;
                    Immsrc = 2'b01;
                    ALU_src = 1'b1;
                    shifter_select = 2'b00;
                    shift_type_sel = 1'b1;
                    ALUcontrol = 4'b0100;
                    datamem_write_en = 1'b1;
                    resultmux_select = 1'b0;
                    Regfile_write_en = 1'b0;
                end
                6'b001001: begin        //STR
                    PCsrc = 1'b0;
                    Regsrc = 2'b01;
                    R14_select_address = 2'b00;  
                    R14_data_select = 1'b0;
                    Immsrc = 2'b01;
                    ALU_src = 1'b1;
                    shifter_select = 2'b00;
                    shift_type_sel = 1'b1;
                    ALUcontrol = 4'b0100;
                    datamem_write_en = 1'b0;
                    resultmux_select = 1'b1;
                    Regfile_write_en = 1'b1;
                end
            endcase
            end
            2'b00: begin
                case (FUNCT)
                6'b000000: begin
                    PCsrc = 1'b1;
                    Regsrc = 2'b10;
                    R14_select_address = 2'b11;  
                    R14_data_select = 1'b0;
                    Immsrc = 2'b10;
                    ALU_src = 1'b1;
                    shifter_select = 2'b00;
                    shift_type_sel = 1'b1;
                    ALUcontrol = 4'b0100;
                    datamem_write_en = 1'b0;
                    resultmux_select = 1'b0;
                    Regfile_write_en = 1'b0;
                end
                6'b11????: begin
                    PCsrc = 1'b1;
                    Regsrc = 2'b10;
                    R14_select_address = 2'b01;  
                    R14_data_select = 1'b0;
                    Immsrc = 2'b10;
                    ALU_src = 1'b1;
                    shifter_select = 2'b00;
                    shift_type_sel = 1'b1;
                    ALUcontrol = 4'b0100;
                    datamem_write_en = 1'b0;
                    resultmux_select = 1'b0;
                    Regfile_write_en = 1'b1;
                end
                6'b010010: begin
                    PCsrc = 1'b1;
                    Regsrc = 2'b00;
                    R14_select_address = 2'b00;  
                    R14_data_select = 1'b0;
                    Immsrc = 2'b10;
                    ALU_src = 1'b0;
                    shifter_select = 2'b00;
                    shift_type_sel = 1'b1;
                    ALUcontrol = 4'b1101;
                    datamem_write_en = 1'b0;
                    resultmux_select = 1'b0;
                    Regfile_write_en = 1'b0;
                end

                endcase
            end
        endcase
    end




end

endmodule