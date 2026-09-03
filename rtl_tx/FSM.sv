module FSM (
    input logic clk,
    input logic rst_n,
    input logic baud_tick,
    input logic fifo_empty,
    input logic bit_done,
    input logic Parity_en, 

    output logic load_re_shift,
    output logic fifo_rd_en,
    output logic shift_en,
    output logic [1:0]mux_sel,
    output logic busy
);

    localparam [2:0] 
        RST   = 3'b000,
        START  = 3'b001,
        DATA   = 3'b010,
        PARITY = 3'b011,
        STOP   = 3'b100;

    logic [2:0] state, next_state;

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= RST;
        end else begin
            state <= next_state;
        end
    end

    always_comb begin
        next_state = state;
        fifo_rd_en = 1'b0;
        shift_en = 1'b0;
        mux_sel    = 2'b00;
        busy    = 1'b1;
        load_re_shift = 1'b0; 

        case (state)
            RST: begin
                busy = 1'b0;
                mux_sel = 2'b11; 
                if (!fifo_empty) begin
                    load_re_shift = 1'b1;
                    fifo_rd_en = 1'b1;
                    next_state = START;
                end
            end
            START: begin
                mux_sel = 2'b00; 
                if (baud_tick) begin
                    next_state = DATA;
                end
            end
            DATA: begin
                mux_sel  = 2'b01; 
                shift_en = baud_tick;
                if (baud_tick && bit_done && Parity_en ) begin
                    next_state = PARITY;
                end
                else if(baud_tick && bit_done ) begin
                    next_state = STOP;
                end
            end
            PARITY: begin
                mux_sel = 2'b10; 
                if (baud_tick) begin
                    next_state = STOP;
                end
            end
            STOP: begin
                mux_sel = 2'b11; 
                if (baud_tick) begin
                    if (!fifo_empty) begin
                        load_re_shift = 1'b1;
                        fifo_rd_en = 1'b1;
                        next_state = START;
                    end else begin
                        next_state = RST;
                    end
                end
            end
            default: next_state = RST;
        endcase
    end

endmodule