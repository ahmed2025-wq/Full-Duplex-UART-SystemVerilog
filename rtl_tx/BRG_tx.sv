module BRG #(
    parameter N = 4,
    parameter count_width = 3
)(
    input  logic clk,
    input  logic rst_n,
    input  logic i_enable,
    output logic  BGR_tick
);

    logic [count_width-1:0] count;

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            count    <= 0;
            BGR_tick <= 0;
        end
        else if (!i_enable) begin
          
            count    <= 0;
            BGR_tick <= 1'b0;
        end
        else if (count == N - 1) begin
            count    <= 0;
            BGR_tick <= 1;
        end
        else begin
            count    <= count + 1'b1;
            BGR_tick <= 0;
        end
    end
endmodule
