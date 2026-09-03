module BRG_rx #(
    parameter N = 4,
    parameter count_width = 3
)(
    input  logic i_clk,
    input  logic i_rst,
    input  logic i_enable,
    output logic o_BGR_tick
);

    logic [count_width-1:0] count;

    always_ff @(posedge i_clk or negedge i_rst) begin
        if (!i_rst) begin
            count <= 0;
            o_BGR_tick <= 0;
        end  else if (!i_enable) begin
        count    <=  N/2 ;   
        o_BGR_tick <= 1'b0;
        end else if (count == N - 1) begin
            count <= 0;
            o_BGR_tick <= 1;      
        end 
        else begin
            count <= count + 1'b1;
            o_BGR_tick <= 0;
    end
end
endmodule