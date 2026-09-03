# 📡 Parameterizable Full-Duplex UART IP Core — SystemVerilog

A robust and parameterizable **Full-Duplex Universal Asynchronous Receiver-Transmitter (UART) IP Core** implemented in **SystemVerilog**. The design consists of independent and modular **Transmitter (`uart_tx`)** and **Receiver (`uart_rx`)** architectures, supporting configurable data width, parity generation and checking, flexible UART framing, error detection, and seamless back-to-back data transmission.

---

## 📌 Project Overview

UART (Universal Asynchronous Receiver-Transmitter) is a widely used serial communication protocol for exchanging data between digital systems without requiring a shared clock between the communicating devices.

This project implements a **full-duplex UART**, allowing the transmitter and receiver to operate independently and simultaneously.

The TX path converts parallel data into a serial UART frame, while the RX path receives and reconstructs the serial frame into parallel data.

The design is written in **SystemVerilog** with a modular RTL architecture suitable for simulation, synthesis, and FPGA implementation.

---

## 🏗️ Architecture

```text
                         Full-Duplex UART
                    +-------------------------+
                    |                         |
 Parallel Data ---> |      +-----------+      | ---> TX Serial
                    |      |  uart_tx  |      |
                    |      +-----------+      |
                    |                         |
                    |      +-----------+      |
 RX Serial -------->|      |  uart_rx  |      | ---> Parallel Data
                    |      +-----------+      |
                    |                         |
                    +-------------------------+
