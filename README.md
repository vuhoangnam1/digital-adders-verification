# Digital-Adders-Verification
# Configurable Adder RTL Design and UVM Verification

---

## Overview
This project focuses on the design and verification of basic digital adder architectures using SystemVerilog.  
The verification environment is developed using UVM (Universal Verification Methodology).

---

## Implemented Adder Architectures
The following adders are implemented at RTL level:
- Full Adder
- Ripple Carry Adder (RCA)
- Carry Skip Adder (CSA)

---

## Verification Methodology
The verification environment is built using **UVM**, including:
- Interface to connect UVM components with the DUT
- Transaction to represent test data to check the DUT
- Sequence to generate and and sends them to the sequencer. 
- Sequencer to control transaction flow to driver
- Driver to apply transactions to the DUT
- Monitor to observe DUT outputs
- Scoreboard for result checking correctness of addition
- Subscriber is functional coverage is implemented to evaluate the quality and completeness of verification
- Agent to integrate monitor && driver && sequencer
- Environment to integrate agent && scoreboard && subscriber
- Test to integrate environment && sequence
- Testbench (top) to instantiate the DUT, generate clock, and run the UVM test
- my_pkg to include all UVM class files and avoid compilation issues
---

## Tools
- Language: SystemVerilog
- Verification: UVM
- Simulator: ModelSim & Quartus

---

## How to Run Simulation
1. Compile RTL and UVM files
2. Run makefile
3. Observe waveform and UVM report output

---

## Project Scope
This project covers adder designs along with their UVM verification, and serves as a platform for performance and architecture evaluation.

---

## Author
Vu Hoang Nam  
