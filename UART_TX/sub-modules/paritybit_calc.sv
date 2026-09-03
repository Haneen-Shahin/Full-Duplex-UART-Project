module paritybit_calc#(
    parameter DATA_W = 8
)(
    input  logic i_clk,
    input  logic i_rst_n,
    input  logic load,
    input  logic i_par_odd,  
    input  logic [DATA_W-1:0] i_data,
    output logic parity_bit
);

    // Register parity bit on load to keep output stable during shift operations
    always_ff @(posedge i_clk or negedge i_rst_n) begin
        if (!i_rst_n) begin
            parity_bit <= 1'b0;
        end else if (load) begin
            parity_bit <= (^i_data) ^ i_par_odd; //even parity if i_par_odd=0, odd parity if i_par_odd=1
        end
    end  
endmodule
