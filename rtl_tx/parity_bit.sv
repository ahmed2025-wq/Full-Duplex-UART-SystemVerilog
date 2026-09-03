module parityBit #(parameter Data_Path = 8 )
(
    input logic [Data_Path-1:0] tx_data_fifo ,
    input logic parityBit_state,
    output logic parity_bit
);


assign parity_bit = (parityBit_state) ?  (~^tx_data_fifo) : (^tx_data_fifo);
    
endmodule