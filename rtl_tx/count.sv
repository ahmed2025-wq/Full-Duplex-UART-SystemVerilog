/*module count 
(
    input logic clk,
    input logic rst,
    input logic shift_en,
    output reg bit_done
);

reg [2:0]count;

always @(posedge clk or negedge rst) begin
    
    if(~rst) begin 
        count <= 3'b000;
        bit_done <= 1'b0;
    end
    else if(shift_en) begin
        count <= count + 1'b1;
        if (count == 7)begin
            bit_done <= 1'b1;
        end
        else begin
            bit_done <= 1'b0;
        end
    end
    else begin
        bit_done <= 1'b0;
    end
end
endmodule*/
module count (
    input  logic clk,
    input  logic rst,
    input  logic shift_en, 
    output logic bit_done  
);

    logic [2:0] count;

    always_ff @(posedge clk or negedge rst) begin
        if (!rst) begin
            count <= 3'b000;
        end else begin
            if (shift_en) begin
                count <= count + 1'b1;
            end
        end
    end

    assign bit_done = (count == 3'b111);

endmodule

