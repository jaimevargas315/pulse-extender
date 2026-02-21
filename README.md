# Pulse Extender (Pulse Stretcher) in Verilog

A hardware-efficient **Pulse Extender** module designed to capture short input pulses and extend their duration to a fixed width of 5 clock cycles. This repository includes the RTL design and a functional testbench for verification.

---

## Overview

In digital systems, short asynchronous pulses or "glitches" can sometimes be missed by slower logic or control states. This module uses a **6-bit Shift Register** to "stretch" a short input pulse, ensuring it remains high long enough for downstream logic to sample it reliably.



---

## How It Works

The module operates on a synchronous clock and uses a sequential shift register to track the state of the input over time.

### 1. Shift Register Logic
On every `posedge clk`, the value of the `in` signal is sampled into the first bit of the `counter` register. Previous values are shifted forward:
* `counter[0]` $\leftarrow$ `in`
* `counter[1]` $\leftarrow$ `counter[0]`
* ...and so on up to `counter[5]`.

### 2. Output Logic
The output is determined by a combinational assignment that monitors the stages of the shift register. It uses a specific boolean expression to manage the pulse width:

$$out = (C_0 \lor C_1 \lor C_2 \lor C_3 \lor C_4) \land \neg C_5$$

* **Extension:** The `OR` operation ensures that if the input was high at any point in the last 5 cycles, the output remains high.
* **Edge Limitation:** The `~counter[5]` term acts as a "cutoff." This ensures that even if the input stays high indefinitely, the output will eventually drop after the extension period, creating a fixed-width pulse.



##  Simulation & Testing

The provided testbench (`pulse_extender_tb`) simulates two different scenarios to ensure robustness:
1. **Long Pulse:** Input stays high for 10 time units to test the cutoff logic.
2. **Short Pulse:** Input stays high for only 5 time units to test the stretching capability.

### Waveform Analysis
When viewing the results in a waveform viewer (like GTKWave), you will observe that the `out` signal rises immediately with `in` and persists for exactly 5 clock cycles, regardless of how short the original input "blip" was.



---

##  Usage

To integrate this module into your own FPGA or ASIC project, instantiate it as follows:

```verilog
pulse_extender u_pulse_extender (
    .clk(sys_clk),    // System Clock
    .rst(sys_rst),    // Active High Reset
    .in(trigger_in),  // Short input pulse
    .out(pulse_out)   // Stretched output pulse
);
