---
title: A Real-time, Spiking SoC for Edge RF Inference
date: 2023-05-14
author: Jon Cowart, Zephan Enciso, Mark Horeni, and Clemens Schaefer
geometry: margin=25.4mm
---

\pagebreak

#   Overview

We present a **real-time**, **spiking** SoC for **edge radio frequency (RF)
inference** in 22 nm CMOS.

##  System Architecture

Figure 1 depicts the primary components of the system, which are:

1. **4x4 phased array**, which is mixed down off-chip.

2. **"Spikifier"** analog circuit, which integrates the mixed RF signal during the
   negative phase of a 10 MHz clock and produces an output spike if the
   integrated signal surpassed a threshold.

3. **Data buffers** (FIFO) for synchronization.

4. Two layers of **processing elements (PEs)**: 16 layer 1 PEs, which feed 8 layer 2
   PEs.

5. **RISC-V processor**, responsible for controlling PEs via a single multicast
   reset signal and measuring the firing rate of the layer 2 PEs to produce a
   classification.

![](./System_Overview.pdf)

Figure 1: System architecture.  Everything within the grey rectangle is on-chip.
The red call-out depicts the spikifier circuit, while the teal call-out depicts
the PE architecture.

##  Timing and Dataflow

The goal of this project is to perform **real-time** inference, which
necessitates that the data consumption rate equals the data ingest rate.  The
system is fully pipelined (see Figure 2), and the longest single processing step
is the layer 1 PEs at 16 clock cycles (the operation of the PE is described in
more depth in Section 3.1).  Therefore, the core clock must run at 16 times
the rate of the sample clock. 

The spikifiers integrate the mixed RF signal during the negative phase of a 10
MHz clock and produce an output at the positive edge.  FIFOs between the
spikifiers and the layer 1 PEs provide synchronization between the 10 MHz sample
clock and the 160 MHz core clock.  The layer 2 PEs only require 8 clock cycles
to complete their computation, after which the RISC-V processor requires 12
cycles to update its rate counts.

![](./Timing.pdf)
Figure 2: Pipelined system timing.


#   Analog Behavioral Model

##  Operation
![](./Analog_Behavior.pdf)
Figure 3:

##  Noise Modeling


#   Digital Accelerator

##  Processing Element Architecture

Each PE is very simple to maximize density and energy efficiency (see Fig. 1).

##  Physical Implementation


#   RISC-V Control


#   Division of Labor

| Group Member  | Task                                                      |
|---------------|-----------------------------------------------------------|
| Jon           | RTL and Validation                                        |
| Zephan        | System Architecture and Analog Behavioral Model           |
| Mark          | System Architecture and RISC-V computation kernel         |
| Clemens       | Synthesis and Implementation                              |

