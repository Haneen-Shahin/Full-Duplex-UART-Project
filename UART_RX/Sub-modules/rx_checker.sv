//==============================================================================
// Module      : rx_checker
// Description : Checks UART parity and stop-bit validity.
//==============================================================================
module rx_checker#(
    parameter DATA_W = 8
)(    
    input logic i_clk,i_rst_n,
    input logic i_rx,
    input logic i_par_odd,
    input logic [DATA_W-1:0]o_data,
    input logic i_par_en,
    input logic stop_check_en,
    input logic parity_check_en,
    output logic o_parity_err,
    output logic o_frame_err
);
    logic exp_parity_bit;  
    logic captured_parity_bit;

    assign exp_parity_bit = (^o_data) ^ i_par_odd; //even parity if i_par_odd=0, odd parity if i_par_odd=1

    always_ff @(posedge i_clk or negedge i_rst_n) begin
        if (!i_rst_n) begin
            captured_parity_bit <= 1'b0;
        end 
        else if (i_par_en && parity_check_en) begin
            captured_parity_bit <= i_rx;
        end
    end
    always_comb begin
        if(stop_check_en && i_par_en)begin
            o_parity_err =(captured_parity_bit != exp_parity_bit);
        end
        else begin
            o_parity_err=0;
        end
        if(stop_check_en)begin
            o_frame_err  =  ~i_rx;
        end
        else begin
            o_frame_err=0;
        end
    end
endmodule
