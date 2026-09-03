//==============================================================================
// Module      : RX_FSM
// Description : UART RX finite-state machine.
//==============================================================================
module RX_FSM #(
    parameter DATA_W = 8
)(
    input logic i_clk,
    input logic i_rst_n,
    input logic i_par_en,
    input logic start_detected,
    input logic done,
    output logic o_busy,
    output logic o_valid,
    output logic shift_en,
    output logic stop_check_en,
    output logic parity_check_en
);
//states
typedef enum logic [2:0]{ IDLE,DATA,PARITY,STOP,VALID } state_e;
//state signals
state_e cs,ns;

//state memory
always_ff @(posedge i_clk or negedge i_rst_n)begin
    if(!i_rst_n)begin
        cs <= IDLE;
    end
    else begin
        cs <= ns;
    end
end

//next_state_logic
always_comb begin
    ns = cs;
    o_busy =1;
    shift_en=0;
    o_valid=0;
    stop_check_en=0;
    parity_check_en=0;
    case(cs)
        IDLE:begin //IDLE
            o_busy = 0;
            if(start_detected)begin
                ns = DATA;
            end
        end
        DATA:begin //DATA
            shift_en=1;
            if(done)begin
                if(i_par_en)begin
                    ns = PARITY;
                end
                else begin
                    ns = STOP;
                end
            end
        end
        PARITY:begin //PARITY
            parity_check_en=1;
            ns = STOP;
        end
        STOP:begin //STOP
            stop_check_en=1;
            ns=VALID;
        end
        VALID:begin
            o_valid = 1;
            stop_check_en=1;
            if(start_detected)begin
                ns = DATA;
            end
            else begin
                ns=IDLE;
            end
        end
        default : begin
            ns = IDLE;
            o_busy =0;
            shift_en=0;
            o_valid=0;
            stop_check_en=0;
            parity_check_en=0;
        end
    endcase
end
endmodule
