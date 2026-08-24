# UART Verilog Implementation

A UART transmitter and receiver implemented in Verilog HDL and verified using simulation in AMD Vivado.

## Features

- 8-bit UART data
- 1 start bit
- 1 stop bit
- LSB-first transmission
- Configurable clock frequency
- Configurable baud rate
- UART transmitter
- UART receiver
- TX-RX loopback verification

## Project Structure

```text
rtl/
├── uart_tx.v
└── uart_rx.v

tb/
├── uart_tx_tb.v
├── uart_rx_tb.v
└── uart_loopback_tb.v

screenshots/
├── uart_tx_tb_sim.png
├── uart_rx_tb_sim.png
└── uart_loopback_tb_sim.png
