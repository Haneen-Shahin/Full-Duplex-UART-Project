module Serializer#(
    parameter DATA_W = 8
)(
    input logic [DATA_W-1:0] i_data,
    input logic i_clk,i_rst_n,
    input logic ser_en,load,
    output logic o_serial_data,
    output logic ser_done
);
logic [DATA_W-1:0]shift_reg;
logic [$clog2(DATA_W):0]counter;
//
assign o_serial_data = shift_reg[0];  //transmit LSB first
assign ser_done = (counter == DATA_W - 1) && ser_en;
//
always_ff@(posedge i_clk or negedge i_rst_n)begin
    if(!i_rst_n)begin
        shift_reg <= 0;
        counter <= 0;
    end
    else begin
        if(load)begin
            shift_reg <= i_data;
            counter <= 0;
        end
        else if(ser_en)begin
            if(counter == DATA_W-1) begin
                counter<=0;
            end
            else begin
                if(counter < DATA_W-1)begin
                    shift_reg <= shift_reg >> 1;
                    counter <= counter + 1;
                end
            end
        end
        else begin
            counter <= 0;
        end
    end
end
endmodule
