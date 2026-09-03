module FSM_Count_ParityCheck #( parameter DATA_WIDTH = 8)
(
    input logic i_clk,
    input logic i_rst,
    input logic i_rx_in,
    input logic i_parity_en,
    input logic i_Parity_type,
    input logic i_Baud_Tick,
    input logic [DATA_WIDTH-1:0] i_rx_out,
    
    output logic o_shift_en,
    output logic o_BRG_en,
    output logic o_parity_error,
    output logic o_fram_error,
    output logic o_Busy,
    output logic o_rx_valid
);

    typedef enum logic [2:0] 
    { IDLE,
     CHECK_START,
     CHECK_DATA , 
     CHECK_PARITY, 
     CHECK_STOP 
    } state;

    state current_state, next_state;

    logic [3:0] count_data;

    logic pe_reg;
    logic fe_reg;

    always_ff @(posedge i_clk or negedge i_rst) begin
        if (!i_rst) begin
            current_state <= IDLE;
            count_data <= 0;
            pe_reg        <= 1'b0;
            fe_reg        <= 1'b0;

        end else begin
            current_state <= next_state;

            if (current_state == IDLE) begin
                count_data <= 0;
                pe_reg        <= 1'b0;
                fe_reg        <= 1'b0;
            end 
            else if (current_state == CHECK_DATA && i_Baud_Tick) begin
                count_data <= count_data + 1'b1;
            end 
            else if (current_state == CHECK_PARITY && i_Baud_Tick) begin
                logic expected_parity;
                expected_parity = (i_Parity_type == 1'b0) ? ^i_rx_out : ~(^i_rx_out);
                if (i_rx_in != expected_parity) pe_reg <= 1'b1;
            end 
            else if (current_state == CHECK_STOP && i_Baud_Tick) begin
                if (i_rx_in == 1'b0) fe_reg <= 1'b1;
            end
        end
    end

    assign o_parity_error = pe_reg;
    assign o_fram_error  = fe_reg;

    always_comb begin

        next_state   = current_state;
        o_BRG_en = 1'b1;
        o_shift_en = 1'b0;
        o_rx_valid = 1'b0;
        o_Busy = 1'b1;


        case (current_state)
            IDLE: begin
                o_BRG_en = 1'b0;
                o_Busy = 1'b0;
                if (i_rx_in == 1'b0) begin
                    next_state = CHECK_START;
                end
            end
            CHECK_START: begin
                if (i_Baud_Tick ) begin
                    next_state = CHECK_DATA;
                end
            end
            CHECK_DATA: begin
                if (i_Baud_Tick ) begin
                    o_shift_en = 1'b1;
                    if (count_data == DATA_WIDTH-1 ) begin
                        if(i_parity_en) begin next_state = CHECK_PARITY; end
                        else begin next_state = CHECK_STOP;
                         end
                    end 
                 end
                end
            CHECK_PARITY : begin
                //o_parity_error = (^(i_rx_out) == i_rx_in ? 1'b0 : 1'b1 );
                //next_state = CHECK_STOP;
                if (i_Baud_Tick) begin
                    next_state = CHECK_STOP;
                end
            end
            CHECK_STOP: begin
                //o_rx_valid = 1'b1;
                //next_state = IDLE;
                if (i_Baud_Tick) begin
                        o_rx_valid = 1'b1;
                    next_state = IDLE;
                end
            end
            default: next_state = IDLE;
        endcase
    end
endmodule