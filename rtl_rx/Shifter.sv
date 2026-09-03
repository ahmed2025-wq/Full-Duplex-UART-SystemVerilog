module Shifter #(
    parameter DATA_WIDTH = 8
)(
    input logic i_clk,
    input logic i_rst,
    input logic i_rx_in,
    input logic i_shift_en,
    output logic [DATA_WIDTH-1:0] o_rx_out
);

    logic [DATA_WIDTH-1:0] shift_reg;
    always_ff @(posedge i_clk or negedge i_rst) begin
        if (!i_rst) begin
            shift_reg <= 0;
            o_rx_out <= {DATA_WIDTH{1'b0}};
        end else if (i_shift_en) begin
            shift_reg <= {i_rx_in, shift_reg[DATA_WIDTH-1:1]};
            //o_rx_out <= shift_reg;
            o_rx_out <= {i_rx_in, shift_reg[DATA_WIDTH-1:1]};
        end 
    end 

endmodule