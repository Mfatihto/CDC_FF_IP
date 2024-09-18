# CDC Flip-Flop Design for Clock Domain Crossing Applications

A generic flip-flop design optimized for clock domain crossing (CDC) applications, allowing the user to specify the number of flip-flops and to select between synchronous or asynchronous reset.

This project implements a **generic flip-flop design** optimized for **Clock Domain Crossing (CDC)** applications. The design is configurable to specify:
- The number of flip-flops used.
- Whether the reset behavior is **synchronous** or **asynchronous**.

This project includes both the VHDL implementation of the flip-flop chain and a comprehensive testbench to simulate the functionality and verify the behavior under different reset conditions.

## Features
- **Configurable Number of Flip-Flops**: The user can specify how many flip-flops should be used in the chain.
- **Synchronous or Asynchronous Reset**: The reset behavior (synchronous or asynchronous) can be dynamically controlled via a signal.
- **Clock Domain Crossing (CDC) Support**: Designed specifically for CDC applications to ensure reliable data transfer between clock domains.

## File Structure
- `D_FlipFlop.vhd`: The main VHDL file that defines the generic flip-flop design.
- `TB_D_FlipFlop.vhd`: The testbench for simulating and verifying the behavior of the flip-flop chain under different conditions.
- `README.md`: This file, providing details on how to use the project.

## Design Details
The flip-flop design includes:
- A **generic parameter** for the number of flip-flops (`N`).
- A **signal-controlled reset mode** (`reset_mode`), which dynamically selects between **synchronous** and **asynchronous** reset during simulation.

### Flip-Flop Design
```vhdl
entity CDC_FF_IP is
    generic  (
        N : integer := 2;			-- Number of flip-flops in the chain
	ASYNC_RST : boolean := true		-- true --> async rst, false --> sync rst
	);
    Port ( Clk : in STD_LOGIC;
           D : in STD_LOGIC;                    -- Input of the first FF in the chain
           Q : out STD_LOGIC;                   -- Output of the last FF in the chain
           Rst : in STD_LOGIC);                 -- Reset input that resets every FF in the chain
end CDC_FF_IP;
