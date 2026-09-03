vlib work
vlog TX_FSM.sv Serializer.sv mux.sv paritybit_calc.sv RX_FSM.sv de_serializer.sv rx_checker.sv start_bit_detector.sv uart_loopback_tb.sv
vsim -voptargs=+acc work.uart_grading_tb
add wave *
run -all 
#quit -sim