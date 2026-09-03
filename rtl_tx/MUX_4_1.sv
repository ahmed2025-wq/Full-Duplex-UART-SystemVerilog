module MUX_4_1 
(
    input logic DATA,
    input logic PARITY,

    input logic [1:0]mux_sel,

    output logic TX_OUT
);


always_comb begin

   

    if(mux_sel == 2'b00)  TX_OUT = 1'b0;  
    else if(mux_sel == 2'b01) TX_OUT = DATA;
    else if(mux_sel == 2'b10) TX_OUT = PARITY;
    else if(mux_sel == 2'b11) TX_OUT = 1'b1;
    else TX_OUT = 1'b1;

end

    
endmodule