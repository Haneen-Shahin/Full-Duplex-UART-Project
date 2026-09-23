```markdown
# 📡 Parameterizable Full-Duplex UART IP Core — SystemVerilog

A robust and parameterizable **Full-Duplex Universal Asynchronous Receiver-Transmitter (UART) IP Core** implemented in **SystemVerilog**[cite: 1]. The design consists of independent and modular **Transmitter (`uart_tx`)** and **Receiver (`uart_rx`)** architectures, supporting configurable data width, parity generation/checking, flexible UART framing, error detection, and seamless back-to-back data transmission[cite: 1].

---

## 📌 Project Overview

UART (Universal Asynchronous Receiver-Transmitter) is a widely used serial communication protocol for exchanging data between digital systems without requiring a shared clock between the communicating devices[cite: 1].

This project implements a **full-duplex UART**, allowing the transmitter and receiver to operate independently and simultaneously[cite: 1].

The TX path converts parallel data into a serial UART frame, while the RX path receives and reconstructs the serial frame into parallel data[cite: 1].

The design is written in **SystemVerilog** with a modular RTL architecture suitable for simulation, synthesis, and FPGA implementation[cite: 1].

### Key Features
* **Full-Duplex Operation**: Independent TX and RX paths allowing simultaneous transmission and reception[cite: 1].
* **Parameterizable Data Width**: Configurable bus width (`DATA_W`, default = 8)[cite: 1].
* **Flexible Parity Configuration**: Supports Even Parity, Odd Parity, or Disabled Parity modes[cite: 1].
* **Back-to-Back Transmission**: High-throughput operation without required inter-frame delays[cite: 1].
* **Robust Error Detection**: Hardware detection for **Framing Errors** and **Parity Errors**[cite: 1].
* **Noise/Glitch Filtering**: Integrated sampling and noise filtering logic on the RX line[cite: 1].

---

## 🏗️ Architecture

```text
                       Full-Duplex UART Block Diagram
     +----------------------------------------------------------------+
     |                                                                |
     |   Parallel Input      +------------------+                     |
---->|--- i_data ----------->|                  |----> o_tx           |----> Serial Output
---->|--- i_valid ---------->|     uart_tx      |----> o_busy         |
     |                       |  #(DATA_W = 8)   |                     |
     |                       +------------------+                     |
     |                                                                |
     |                       +------------------+----> o_data         |----> Parallel Output
     |                       |                  |----> o_valid        |
---->|--- i_rx ------------->|     uart_rx      |----> o_busy         |
     |                       |  #(DATA_W = 8)   |----> o_parity_err   |
     |                       +------------------+----> o_frame_err    |
     |                                                                |
     +----------------------------------------------------------------+

```

---

## 📤 Transmitter Architecture (`uart_tx`)

The UART Transmitter converts a parallel input payload (`i_data`) into a serial bitstream (`o_tx`) framed with start, data, optional parity, and stop bits.

### Port Interface (`uart_tx`)

| Port Name | Direction | Type | Description |
| --- | --- | --- | --- |
| `i_clk` | Input | `logic` | System clock signal

 |
| `i_rst_n` | Input | `logic` | Active-low asynchronous reset

 |
| `i_data` | Input | `logic [DATA_W-1:0]` | Parallel input payload to transmit

 |
| `i_valid` | Input | `logic` | Handshake pulse indicating input data validity

 |
| `i_par_en` | Input | `logic` | Enables parity bit generation (`1`: Enabled, `0`: Disabled)

 |
| `i_par_odd` | Input | `logic` | Parity mode selector (`0`: Even Parity, `1`: Odd Parity)

 |
| `o_tx` | Output | `logic` | Serial output data line

 |
| `o_busy` | Output | `logic` | High when transmission is actively in progress

 |

### Submodule Breakdown

* **`TX_FSM`**: Controls state transitions (`IDLE` $\rightarrow$ `START` $\rightarrow$ `DATA` $\rightarrow$ `PARITY` $\rightarrow$ `STOP`) and control flags.


* **`Serializer`**: Parameterized shift register converting parallel data to serial bitstreams LSB-first.


* **`paritybit_calc`**: Pre-calculates even (XOR) or odd (XNOR) parity over payload bits.


* **`mux`**: Routes start bit, data bits, parity, or stop bit to `o_tx`.



---

## 📥 Receiver Architecture (`uart_rx`)

The UART Receiver samples incoming asynchronous serial data (`i_rx`), reconstructs the parallel payload (`o_data`), and validates framing and parity integrity.

### Port Interface (`uart_rx`)

| Port Name | Direction | Type | Description |
| --- | --- | --- | --- |
| `i_clk` | Input | `logic` | System clock signal

 |
| `i_rst_n` | Input | `logic` | Active-low asynchronous reset

 |
| `i_rx` | Input | `logic` | Serial input data line

 |
| `i_par_en` | Input | `logic` | Enables parity evaluation (`1`: Enabled, `0`: Disabled)

 |
| `i_par_odd` | Input | `logic` | Parity mode selector (`0`: Even Parity, `1`: Odd Parity)

 |
| `o_data` | Output | `logic [DATA_W-1:0]` | Latched parallel received payload

 |
| `o_valid` | Output | `logic` | Single-cycle pulse indicating valid received data

 |
| `o_busy` | Output | `logic` | High while receiving a frame

 |
| `o_parity_err` | Output | `logic` | Asserted if received parity bit mismatches expected value

 |
| `o_frame_err` | Output | `logic` | Asserted if stop bit is invalid (`1'b0` instead of `1'b1`)

 |

### Submodule Breakdown

* **`Data_Sync / Sampler`**: Mid-bit oversampling and glitch filtering for start bit detection.


* **`RX_FSM`**: Coordinates data collection, parity evaluation, and flag generation sequences.


* **`Deserializer`**: Reconstructs serial stream into parallel payload LSB-first.


* **`paritybit_chk`**: Evaluates payload against received parity bit to flag discrepancies.



---

## 🛠️ Verification & Testbench Strategy

Comprehensive verification is performed using self-checking SystemVerilog testbenches to validate protocol compliance and edge-case behaviors.

### Key Verification Scenarios

* **Reset & Glitch Rejection**: Verifies FSM initialization upon `i_rst_n = 0` and ensures noise pulses in `IDLE` do not trigger false reception starts.


* **Parity Validation (Even & Odd)**: Validates correct parity generation/checking and intentional error assertion when bit errors are injected.


* **Framing Error Detection**: Verifies `o_frame_err` triggers properly if `i_rx` is driven low during the stop bit sampling window.


* **Back-To-Back Transfers**: Ensures zero-inter-frame gap transfers operate smoothly without payload loss or frame corruption.



---

## 📊 Functional Simulation & Results

The behavioral SystemVerilog implementation was verified using **Siemens QuestaSim**.

* **Timing Compliance**: State transitions, handshake signals (`load`, `ser_en`, `deser_en`), and serial bit durations strictly align with standard UART framing.


* **Data Integrity**: Complete data symmetry achieved across full-duplex transfers with LSB-first ordering.


* **Verification Status**: Self-checking testbench suite passed with **0 Errors and 0 Warnings**.



---

## 👤 Author & License

**Haneen Fady Shahin**

This open-source IP core is available for research, academic coursework, and engineering integration. Reuse, modifications, and project integration are welcomed.

```

```
