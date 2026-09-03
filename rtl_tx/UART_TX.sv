module UART_TX 
#(
    parameter Data_Width = 8,
    parameter  Depth = 4 ,
    parameter N  = 4 ,
    parameter count_width = 3
    )
(
    input wire clk,
    input wire rst,
    input wire [Data_Width-1:0]tx_data_in, // done
    input wire parity_en, //done
    input wire parity_bit_state, //done
    input wire wr_en, // done 

    output wire TX_OUT,  // done
    output wire Full, //done 
    output wire Busy // done
);

// wirr for fifo  --> FSM
    wire rd_en; // connectd with FSM
    wire empty ;// connected with FSM
// wire fifo --> shift data
    wire [Data_Width-1:0]fifo_data_out; // connected with shift data 
    
// wire BRG --> fsm
    wire baud_tick; //onnected with FSM

// wire fsm >> mux
    wire [1:0]mux_sel;

// wire fsm >> shift_data >> count
    wire shift_en; //connected to shift and count
    wire load_re_shift; //connected to shift
    wire bit_done; //connected to fsm 

//wire parityBit to mux
    wire parity_bit;

// wire shift_register to MUX
    wire serial_data_out;



FIFO #(  .Data_Path(Data_Width),
    .Depth(Depth)
) u_fifo (
    .clk(clk),
    .rst_n(rst),
    .tx_data_in(tx_data_in),
    .tx_wr_en(wr_en),

    .rd_en(rd_en),
    .full(Full),
    .tx_data_out(fifo_data_out),
    .empty(empty)
);

BRG #(
    .N(N),
    .count_width(count_width)
) u_BRG (
    .clk(clk),
    .rst_n(rst),
    .i_enable(Busy),
    .BGR_tick(baud_tick)
);

count u_count(
    .clk(clk),
    .rst(rst),
    .shift_en(shift_en),
    .bit_done(bit_done)
);

FSM u_fsm (
    .clk(clk),
    .rst_n(rst),
    .baud_tick(baud_tick),
    .fifo_empty(empty),
    .bit_done(bit_done),
    .Parity_en(parity_en),
    .load_re_shift(load_re_shift),
    .fifo_rd_en(rd_en),
    .shift_en(shift_en),
    .mux_sel(mux_sel),
    .busy(Busy)
);

parityBit #( .Data_Path(Data_Width) 
) u_parityBit (
    .tx_data_fifo(fifo_data_out),
    .parityBit_state(parity_bit_state),
    .parity_bit(parity_bit)

);

Shift_Register #(.Data_Width(Data_Width)
) u_Shift_Register (
    .clk(clk),
    .rst(rst),
    .load_data(load_re_shift),
    .shift_en(shift_en),
    .parallel_data_in(fifo_data_out),
    .serial_data_out(serial_data_out)
);

MUX_4_1 u_MUX_4_1 (
    .DATA(serial_data_out),
    .PARITY(parity_bit),
    .mux_sel(mux_sel),
    .TX_OUT(TX_OUT)
);    
endmodule