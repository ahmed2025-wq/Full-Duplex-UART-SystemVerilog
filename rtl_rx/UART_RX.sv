module UART_RX #(

parameter N = 4,
parameter count_width = 3,
parameter DATA_WIDTH = 8
)(
input logic i_clk,
input logic i_rst,
input logic i_rx_in,
input logic i_parity_en,
input logic i_Parity_type,

output logic [DATA_WIDTH-1:0] o_rx_out,
output logic o_parity_error,
output logic o_rx_valid,
output logic o_Busy,
output logic o_fram_error
);

logic Baud_Tick_w;
logic shift_en_w;
logic BRG_en_w;



BRG_rx #(.N(N) , .count_width(count_width))
   BRG_ut ( 
        .i_clk(i_clk) , 
        .i_rst(i_rst) , 
        .i_enable(BRG_en_w),
        .o_BGR_tick(Baud_Tick_w)
      ); 

Shifter #(.DATA_WIDTH(DATA_WIDTH))
    shift_ut (
        .i_clk(i_clk),
        .i_rst(i_rst),
        .i_rx_in(i_rx_in),
        .i_shift_en(shift_en_w),
        .o_rx_out( o_rx_out)
        );

FSM_Count_ParityCheck #(.DATA_WIDTH(DATA_WIDTH) )
    FSM_ut (
        .i_clk(i_clk),
        .i_rst(i_rst),
        .i_rx_in(i_rx_in),
        .i_parity_en(i_parity_en),
        .i_Parity_type(i_Parity_type),
        .i_Baud_Tick(Baud_Tick_w),
        .i_rx_out( o_rx_out),
        .o_shift_en(shift_en_w),
        .o_BRG_en(BRG_en_w),
        .o_parity_error(o_parity_error),
        .o_rx_valid(o_rx_valid),
        .o_Busy(o_Busy),
        .o_fram_error(o_fram_error)
        );

endmodule