module mux(
    input logic start_bit,
    input logic serial_bit,
    input logic parity_bit,
    input logic stop_bit,
    input logic [1:0]mux_sel,
    output logic o_tx
);

assign o_tx  = (mux_sel==2'b00)? start_bit:
                    (mux_sel==2'b01)? serial_bit:
                    (mux_sel==2'b10)? parity_bit:  stop_bit;
endmodule
