# 📡 Parameterizable Full-Duplex UART IP Core — SystemVerilog

A parameterizable **Full-Duplex UART IP Core** implemented in SystemVerilog. The design includes independent **Transmitter (`uart_tx`)** and **Receiver (`uart_rx`)** modules with configurable data width, parity support, error detection, and back-to-back transmission.

## 📌 Features

* Full-duplex UART communication
* Parameterized data width (`DATA_W`, default = 8)
* Even, Odd, or Disabled parity
* Back-to-back frame transmission
* Parity and framing error detection
* RX start-bit detection and sampling
* Modular RTL architecture

## 🏗️ Architecture

```text
                    Full-Duplex UART
     +-------------------------------------------+
     |                                           |
     |   +------------------+                    |
     |-->|    uart_tx       |----> o_tx          |
     |   |                  |----> o_busy        |
     |   +------------------+                    |
     |                                           |
     |   +------------------+----> o_data        |
     |-->|    uart_rx       |----> o_valid       |
     |   |                  |----> o_busy        |
     |   |                  |----> o_parity_err  |
     |   +------------------+----> o_frame_err   |
     |                                           |
     +-------------------------------------------+
```

## 📤 Transmitter — `uart_tx`

Converts parallel input data into a UART serial frame consisting of start, data, optional parity, and stop bits.

### Interface

| Port        | Direction | Description               |
| ----------- | --------- | ------------------------- |
| `i_data`    | Input     | Parallel transmit data    |
| `i_valid`   | Input     | Transmit request          |
| `i_clk`     | Input     | System clock              |
| `i_rst_n`   | Input     | Active-low reset          |
| `i_par_en`  | Input     | Parity enable             |
| `i_par_odd` | Input     | Odd/even parity selection |
| `o_tx`      | Output    | UART serial output        |
| `o_busy`    | Output    | Transmission busy flag    |

### Main Blocks

* **TX_FSM** — Controls UART transmission states.
* **Serializer** — Shifts data out LSB-first.
* **Parity Calculator** — Generates the selected parity bit.
* **MUX** — Selects start, data, parity, or stop bit.

## 📥 Receiver — `uart_rx`

Receives the UART serial stream, reconstructs the parallel data, and checks parity and stop-bit validity.

### Interface

| Port           | Direction | Description               |
| -------------- | --------- | ------------------------- |
| `i_rx`         | Input     | UART serial input         |
| `i_clk`        | Input     | System clock              |
| `i_rst_n`      | Input     | Active-low reset          |
| `i_par_en`     | Input     | Parity checking enable    |
| `i_par_odd`    | Input     | Odd/even parity selection |
| `o_data`       | Output    | Received parallel data    |
| `o_valid`      | Output    | Valid data pulse          |
| `o_busy`       | Output    | Reception busy flag       |
| `o_parity_err` | Output    | Parity error flag         |
| `o_frame_err`  | Output    | Framing error flag        |

### Main Blocks

* **Data Synchronizer / Sampler** — Synchronizes and samples the RX input.
* **RX_FSM** — Controls the reception sequence.
* **Deserializer** — Converts serial data to parallel data.
* **Parity Checker** — Detects parity errors.

## 🛠️ Verification

The UART was verified using **SystemVerilog self-checking testbenches** and **Siemens QuestaSim**.

Verification includes:

* Reset and RX noise/glitch handling
* Even and odd parity modes
* Parity error injection
* Framing error detection
* Back-to-back frame transmission
* TX/RX data integrity

## 📊 Simulation

Simulation results confirm correct:

* UART frame timing
* TX/RX data transfer
* Parity and framing error detection
* Back-to-back operation

**Verification Status:** 0 Errors, 0 Warnings

## 👤 Author

**Haneen Fady Shahin**

This project is open for **learning, educational use, and experimentation**. Feel free to study the design, modify it, or use it as a reference for similar academic projects.
