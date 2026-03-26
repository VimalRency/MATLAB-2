📌 Project Overview

This project implements an AI-enabled Dynamic Voltage and Frequency Scaling (DVFS) controller on a Zynq FPGA platform.
The system dynamically adjusts frequency based on workload using a lightweight prediction model generated from MATLAB and deployed as RTL.

🧠 Key Features
Adaptive DVFS using predictive logic
MATLAB → HDL workflow (hardware-aware design)
AXI-based integration with Zynq Processing System
Real-time performance scaling
Low-power optimization strategy
🏗️ Architecture

<img width="2415" height="678" alt="image" src="https://github.com/user-attachments/assets/b9a04171-9dc9-4a4a-9def-88460d2fd18c" />


Main components:

Processing System (PS7)
AXI Interconnect
DVFS Controller IP
Clock/Reset logic
Performance Monitor
⚙️ Workflow
Model DVFS logic in MATLAB
Generate HDL using HDL Coder
Integrate IP in Vivado block design
Connect via AXI interface
Simulate and deploy on FPGA
📊 Results
| Mode     | Frequency   | Power  | Performance |  
| -------- | ----------- | ------ | ----------- |  
| Static   | Fixed       | High   | Medium      |  
| DVFS     | Adaptive    | Low    | High        |  


📁 Repository Structure
rtl/               → Verilog/SystemVerilog
constraints/       → XDC files
matlab_scripts/    → MATLAB + HDL workflow
docs/              → Diagrams + explanation


🚀 Future Work
Integrate ML-based workload prediction
Add hardware counters
Extend to multi-core systems
