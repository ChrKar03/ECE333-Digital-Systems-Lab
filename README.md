# ECE333: Digital Systems Laboratory
This repository contains the Verilog hardware descriptions and Vivado project files for the **Digital Systems Laboratory (ECE333)** course at the **University of Thessaly, Department of Electrical and Computer Engineering**. 

The projects focus on designing, simulating, and implementing fundamental digital systems and communication protocols on a **NEXYS A7-100T FPGA** board using **Xilinx Vivado**.

## 🛠️ Hardware & Tools
* **Board:** Digilent Nexys A7-100T (Artix-7 FPGA)
* **Language:** Verilog HDL
* **Software:** Xilinx Vivado (Synthesis, Implementation, Simulation)

---

## 📂 Project Overview

### Lab 1: 7-Segment Display Driver & Message Rotator
The first assignment focuses on clock management, debouncing, and driving multiplexed external peripherals. 
* **Decoder & Multiplexing:** Designed a 4-bit to 8-bit hexadecimal decoder and a Finite State Machine (FSM) to multiplex four 7-segment displays.
* **Clock Management:** Utilized the Mixed-Mode Clock Manager (MMCM) module to step down the 100MHz system clock to 5MHz (and optionally 40KHz via cascading) for stable display driving without flickering.
* **Signal Conditioning:** Implemented synchronizers (chained D Flip-Flops) and a debouncing counter for reliable mechanical button input.
* **Message Rotation:** Created a memory module that shifts a stored hexadecimal message across the displays either manually (via button press) or automatically (using a 23-bit internal timer delay).

### Lab 2: Universal Asynchronous Receiver-Transmitter (UART)
The second assignment involves designing a complete, asynchronous serial communication system from scratch.
* **Baud Rate Controller:** Implemented a programmable clock divider to generate sampling pulses for various standard baud rates (from 300 to 115200 bps) with minimal relative error.
* **Transmitter (Tx):** Designed a 5-state Moore FSM (Idle, Start, Send, Parity, Stop) to serialize and transmit 8-bit data alongside dynamically calculated parity.
* **Receiver (Rx):** Designed a 5-state Moore FSM utilizing 8x oversampling to accurately detect the start bit, read incoming data, and flag Parity or Framing errors.
* **Top-Level Transceiver:** Integrated the Tx and Rx modules. Added an optional UI using the board's 7-segment displays and RGB LEDs to visually configure the baud rate and monitor transmission status and errors.

### Lab 3: VGA Display Controller
The final assignment centers on video signal generation and memory interfacing to drive a standard VGA monitor.
* **Video RAM (VRAM):** Instantiated FPGA Block RAM (BRAM) macros to act as virtual memory, storing color data for a 128x96 pixel image.
* **Timing Generators:** Calculated and implemented the strict clock-cycle timings (Front Porch, Sync Pulse, Back Porch, Active Video) required for a 640x480 @ 60Hz VGA signal.
* **FSM Control:** Designed dedicated Moore FSMs for both Horizontal (HSYNC) and Vertical (VSYNC) synchronization.
* **Image Upscaling:** Implemented coordinate-mapping logic using nested counters to scale the 128x96 image up by a factor of 5, allowing it to render correctly across the 640x480 resolution display without distortion.

---