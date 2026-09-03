module uart_tx #(
    parameter DATA_W = 8
    )(
    input logic [DATA_W-1:0]i_data,
    input logic i_valid,
    input logic i_clk,
    input logic i_rst_n,
    input logic i_par_en,
    input logic i_par_odd,
    output logic o_tx,
    output logic o_busy
);
    logic ser_done;
    logic load;
    logic ser_en;
    logic [1:0] mux_sel;
    logic serial_bit;
    logic parity_bit;
    logic start_bit;
    logic stop_bit;
    logic shift_reg;
    assign  start_bit = 1'b0;
    assign  stop_bit = 1'b1;
    //////////////////////////////////////////////////instantiation/////////////////////////////////////////////////////////////////////

    TX_FSM #(.DATA_W(DATA_W)) 
            u_fsm(.i_valid(i_valid),
                    .i_par_en(i_par_en),
                    .i_clk(i_clk),
                    .i_rst_n(i_rst_n),
                    .ser_done(ser_done),
                    .o_busy(o_busy),
                    .load(load),
                    .ser_en(ser_en),
                    .mux_sel(mux_sel));

    Serializer #(.DATA_W(DATA_W)) 
                u_ser(.i_data(i_data),
                        .i_clk(i_clk),
                        .i_rst_n(i_rst_n),
                        .ser_en(ser_en),
                        .load(load),
                        .o_serial_data(serial_bit),
                        .ser_done(ser_done));

    paritybit_calc #(.DATA_W(DATA_W))   
                    u_pc(.i_clk(i_clk), 
                    .i_rst_n(i_rst_n),
                    .i_data(i_data),
                    .load(load),
                    .i_par_odd(i_par_odd),
                    .parity_bit(parity_bit));
                
    mux u_mux(.start_bit(start_bit),
                .serial_bit(serial_bit),
                .parity_bit(parity_bit),
                .stop_bit(stop_bit),
                .mux_sel(mux_sel),
                .o_tx(o_tx));

endmodule
