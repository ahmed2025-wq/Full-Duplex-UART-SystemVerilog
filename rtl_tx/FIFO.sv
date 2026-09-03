module FIFO #(parameter Data_Path = 8 , parameter Depth = 4 )
(
    input logic clk,
    input logic rst_n,

    input logic [Data_Path-1:0]tx_data_in,
    input logic tx_wr_en,
    input logic rd_en,

    output logic full,  // if 4 byte is full by data
    output logic [Data_Path-1:0]tx_data_out,
    output logic empty  // if empty = 0 this mean  memory have data ;
);

logic [Data_Path-1:0] Memory_Arr;

logic is_full;

assign full  =is_full;
assign empty = ~is_full;

assign tx_data_out = Memory_Arr;

always_ff @(posedge clk or negedge rst_n) begin
   
    if (~rst_n) begin
        is_full  <= 1'b0;
        Memory_Arr <= 0;
    end
    else begin
        if (rd_en && tx_wr_en && ~full && ~empty) begin
            if (is_full) begin
                Memory_Arr <= tx_data_in;
            end else begin
                Memory_Arr <= tx_data_in;
                is_full  <= 1'b1;
            end
        end
        else if (tx_wr_en && ~is_full) begin
            Memory_Arr <= tx_data_in;
            is_full  <= 1'b1;
        end
        else if (rd_en && is_full) begin
            is_full  <= 1'b0;
        end
    end
end
endmodule