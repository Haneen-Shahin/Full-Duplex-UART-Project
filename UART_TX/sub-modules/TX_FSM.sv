module TX_FSM #(
    //input size
    parameter DATA_W = 8
)( 
    //inputs
    input logic i_valid,
    input logic i_par_en,
    input logic i_clk,i_rst_n,
    input logic ser_done,
    //outputs
    output logic load,
    output logic ser_en,
    output logic [1:0]mux_sel,
    output logic o_busy

);
 //states
    typedef enum logic [2:0]{ IDLE,START,DATA,PARITY,STOP } state_e;
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
    o_busy =1;
    load=0;
    ser_en=0;
    mux_sel=2'b11;
    case(cs)
    IDLE:begin //IDLE
        o_busy = 0;
        mux_sel =2'b11;
        if(i_valid == 1)begin
            ns = START;
            load = 1;
        end
        else begin
            ns = IDLE;
        end
    end
    START:begin //START
            ns = DATA;
            mux_sel =2'b00;
    end
    DATA:begin //DATA
        ser_en=1;
        mux_sel =2'b01;
        if(ser_done)begin
            if(i_par_en)begin
               ns = PARITY;
            end
            else begin
               ns = STOP;
            end
        end
        else begin
            ns = DATA;
        end
    end
    PARITY:begin //PARITY
        ns = STOP;
        mux_sel =2'b10;
    end
    STOP:begin //STOP
        mux_sel =2'b11;
        if(i_valid == 1)begin
            ns = START;
            load = 1;
        end
        else begin
            ns = IDLE;
        end
    end
    default : begin
        ns = IDLE;
        o_busy =0;
        load=0;
        ser_en=0;
        mux_sel=2'b11;
    end
    endcase
end
endmodule
