module Shift_Register #(parameter Data_Width = 8)
(
    input logic clk,
    input logic rst,
    input logic load_data,
    input logic shift_en,
    input logic [Data_Width-1:0]parallel_data_in,

    output logic serial_data_out
);

logic [Data_Width-1:0] Data_Memory;

always_ff @(posedge clk or negedge rst) begin

    if(~rst) begin 
        Data_Memory <= {Data_Width{1'b0}};
    end
    else if(load_data) begin
        Data_Memory <= parallel_data_in;
    end
    else if(shift_en) begin
        Data_Memory <= {1'b0 , Data_Memory[Data_Width-1:1]};
    end
end    

assign serial_data_out = Data_Memory[0];
endmodule