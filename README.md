# Full-Duplex UART Transceiver (SystemVerilog)

## 📌 Project Overview
A highly robust, parameterized Full-Duplex UART (Universal Asynchronous Receiver-Transmitter) module implemented in SystemVerilog. This project features dynamic parity generation/checking, framing error detection, and glitch-free registered outputs. It is designed with advanced Finite State Machines (FSMs) for both TX and RX and verified against a strict industry-standard grading testbench.

## 🚀 Key Features
* **Full-Duplex Communication:** Independent TX and RX modules capable of simultaneous operation.
* **Parameterized Design:** Configurable Data Width and Oversampling Rate (`N`).
* **Advanced Error Detection:** 
  * **Parity Error (`pe`):** Supports dynamic switching between Even/Odd parity and parity enable/disable.
  * **Framing Error (`fe`):** Detects corrupted stop bits and raises synchronized error flags.
* **Robust FSM Architecture:** Optimized state machines with eliminated pipeline delays and Race Condition prevention using sequential registered outputs.
* **Mid-Bit Sampling:** RX FSM accurately samples data at the exact center of the bit period to avoid metastability and data desynchronization.

## 📁 Repository Structure
* `/rtl_tx`: Contains UART Transmitter RTL (`UART_TX.sv`, `FSM_TX.sv`, etc.)
* `/rtl_rx`: Contains UART Receiver RTL (`UART_RX.sv`, `FSM_RX.sv`, `Shifter.sv`, etc.)
* `/tb`: Contains the advanced grading testbench (`uart_grading_tb.sv`).
* `/sim`: Simulation scripts (`run.do`) and generated waveforms.

## 🛠️ Tools & Technologies
* **Hardware Description Language:** SystemVerilog
* **Simulation & Verification:** QuestaSim / ModelSim
* **Synthesis & FPGA Flow:** Intel Quartus Prime (Targeted)

## 🧪 Verification & Testing
The design successfully passed an automated grading harness with a **100% Score (66/66 frames)**. The testbench verified:
1. Randomized data transmission (Parity Disabled).
2. Randomized data transmission (Even/Odd Parity).
3. **Error Injection:** Successful detection of forced parity errors and framing errors on the wire.
4. Back-to-back frame transmission (Stress testing).
5. Busy-reject mechanisms to prevent data overwrite.

## 📈 Waveform Analysis
*(Optional: Add a screenshot of your QuestaSim waveform here showing successful TX/RX loopback)*
![UART Waveform](link_to_image_if_available)

---
*Designed by [Ahmed Gamal] - Electronics and Communications Engineering*
