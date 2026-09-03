//==============================================================================
// Module      : uart_rx
// Description : Parameterizable UART receiver.
//==============================================================================
module uart_rx #(
    parameter DATA_W = 8
)(
    input logic i_rx,
    input logic i_clk,
    input logic i_rst_n,
    input logic i_par_en,
    input logic i_par_odd,
    output logic [DATA_W-1:0]o_data,
    output logic o_valid,
    output logic o_busy,
    output logic o_parity_err,
    output logic o_frame_err
);
    //internal signals
    logic shift_en;
    logic start_detected;
    logic neg_edge_rx;
    logic done;
    logic stop_check_en;
    logic parity_check_en;

  de_serializer #(.DATA_W(DATA_W)) 
                u_des(.i_clk(i_clk),
                .i_rst_n(i_rst_n),
                .shift_en(shift_en),
                .i_rx(i_rx),
                .o_data(o_data),
                .done(done));

  RX_FSM #(.DATA_W(DATA_W)) 
            u_rx_fsm(.i_clk(i_clk),
            .i_rst_n(i_rst_n),
            .i_par_en(i_par_en),
            .start_detected(start_detected),
            .o_busy(o_busy),
            .o_valid(o_valid),
            .shift_en(shift_en),
            .done(done),
            .stop_check_en(stop_check_en),
            .parity_check_en(parity_check_en));

  start_bit_detector u_start(.i_clk(i_clk),
                            .i_rst_n(i_rst_n),
                            .i_rx(i_rx),
                            .o_busy(o_busy),
                            .neg_edge_rx(neg_edge_rx),
                            .start_detected(start_detected));

  rx_checker #(.DATA_W(DATA_W))  
                u_checker(.i_clk(i_clk),
                .i_rst_n(i_rst_n),
                .i_rx(i_rx),
                .i_par_odd(i_par_odd),
                .o_data(o_data),
                .i_par_en(i_par_en),
                .o_parity_err(o_parity_err),
                .o_frame_err(o_frame_err),
                .stop_check_en(stop_check_en),
                .parity_check_en(parity_check_en));

endmodule
