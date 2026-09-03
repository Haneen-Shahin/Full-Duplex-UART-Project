//==============================================================================
// Module      : de_serializer
// Description : Serial-to-parallel conversion for UART data bits.
//               Data is received LSB first.
//==============================================================================
module de_serializer#(
    parameter DATA_W = 8
)(
    input logic i_clk,
    input logic i_rst_n,
    input logic shift_en,
    input logic i_rx,
    output logic [DATA_W-1:0] o_data,
    output logic done
);
    logic [$clog2(DATA_W)-1:0]bit_cnt;
    assign done = shift_en && (bit_cnt == DATA_W-1);
    always_ff @(posedge i_clk or negedge i_rst_n) begin
        if (!i_rst_n) begin
            o_data <= 0;
            bit_cnt <= 0;
        end
        else begin
            if (shift_en) begin
                o_data <= {i_rx, o_data[DATA_W-1:1]};
                if (bit_cnt == DATA_W-1) begin
                    bit_cnt <=0;
                end
                else begin
                    bit_cnt <= bit_cnt + 1'b1;
                end
            end
            else begin
                bit_cnt <= 0;
            end
        end
    end
endmodule
