//==============================================================================
// Module      : start_bit_detector
// Description : Detects a falling edge on the UART RX line while RX is idle.
//==============================================================================
module start_bit_detector(
    input logic i_clk,
    input logic i_rst_n,
    input logic i_rx,
    input logic o_busy,
    output logic neg_edge_rx,
    output logic start_detected
);
    logic i_rx_dly;
    always_ff @(posedge i_clk or negedge i_rst_n)begin
        if(!i_rst_n)begin
            i_rx_dly <= 1'b1;
        end
        else begin
            i_rx_dly <= i_rx;
        end
    end

    assign neg_edge_rx = ~i_rx & i_rx_dly;
    assign start_detected = neg_edge_rx ;
endmodule
