# 16-stage-8-bit-synchronous-FIFO-Memory

This repository contains the Verilog code for a FIFO (First-In, First-Out) memory circuit with 8 bit data width and 16 stages. The FIFO memory is implemented using modules to manage the read and write operations, memory storage, and status signal calculation.

## Description
The FIFO memory circuit is designed to store and retrieve data in the order they are written. It is commonly used in various applications where data buffering and sequencing are required, such as communication systems, data processing, and hardware accelerators.

The Verilog code in this repository consists of four submodules:

The Top-level module 'fifo_mem' instantiates the submodules and connects their inputs and outputs. Module hierarchy is established by instantiating the submodules ("toplevel_submodule1" "toplevel_submodule2" "toplevel_submodule3" and "toplevel_submodule4")

1. Write Pointer
2. Read Pointer
3. Memory Array
4. Status Signals

### 1. write_pointer submodule:
- Manages the write operation of the FIFO.
- Inputs: write, is_full, clk, and rst_n.
- Outputs: wptr (write pointer) and wr_enable (write enable signal).
- Increments the write pointer (wptr) based on the control signal write and ensures that the FIFO is not full (is_full).
- Assigns the write enable signal wr_enable as the logical negation of is_full and write.

### 2. read_pointer submodule:
- Manages the read operation of the FIFO.
- Inputs: read, is_empty, clk, and rst_n.
- Outputs: rptr (read pointer) and rd_enable (read enable signal).
- Increments the read pointer (rptr) based on the control signal read and ensures that the FIFO is not empty (is_empty).
- Assigns the read enable signal rd_enable as the logical conjunction of the negation of is_empty and read.

### 3. memory_array submodule:
- Stores data in the FIFO memory.
- Inputs: data_in, clk, wr_enable, wptr, and rptr.
- Outputs: data_out (data read from the FIFO memory).
- Uses a register array data_out2 to hold the data.
- On the rising edge of the clock (clk), if the write enable signal wr_enable is active, it writes the input data (data_in) to the array at the location specified by the write pointer (wptr).
- Assigns the output data_out as the value stored in the array at the location specified by the read pointer (rptr).

### 4. status_signal submodule:
- Calculates the status flags of the FIFO.
- Inputs: write, read, wr_enable, rd_enable, clk, rst_n, wptr, and rptr.
- Outputs: is_full, is_empty, threshold, overflow, and underflow.
- Uses combinational logic to determine the status flags based on the control signals and pointer values.
- Calculates is_full by comparing the most significant bit of the write and read pointers (diff_msb_diff_bank) and the equality of the lower bits.
- Calculates is_empty by comparing the most significant bit of the write and read pointers (~diff_msb_diff_bank => same bank) and the equality of the lower bits.
- Calculates threshold based on the result of the pointer subtraction.
- Determines overflow and underflow based on the control signals and the read and write operations.

### Reference
![image](https://github.com/prerna-sarkar/FIFO-Memory-using-Verilog/assets/40262089/7a4d246b-dcd8-4554-9b13-e9a9cdc4fc0e)

## TestBench

The code defines a Verilog testbench for a FIFO (First-In-First-Out) memory module.
Overall, the code sets up the testbench environment, generates clock and reset signals, performs write and read operations on the FIFO memory module, and includes self-checking mechanisms to validate the functionality of the module.

1. It begins with a timescale directive that sets the time units to 10 picoseconds and the time precision to 10 picoseconds. The DELAY macro is defined using the preprocessor directive and it has a value of 10.

2. The DUT input registers (clk, rst_n, write, read, data_in) and output wires (data_out, is_full, is_empty, threshold, overflow, underflow) are declared, along with an integer variable i.

3. An instance of the FIFO memory module named tb1 is instantiated, connecting the inputs and outputs.

4. Initial conditions are set for the input registers.

5. The main task is called using the initial keyword, which starts a simulation.

6. The main task uses a fork-join construct to run several tasks concurrently:
(i) clock_generator: Generates a clock signal with a period of DELAY (10 picoseconds) using an infinite loop.
(ii) reset_generator: Generates a reset signal (rst_n) with a specific timing sequence.
(iii) operation_process: Performs write and read operations on the FIFO memory module in a loop.
(iv) debug_fifo: Displays simulation information and monitors the values of write, read, and data_in.
(v) endsimulation: Specifies the end time of the simulation using the ENDTIME parameter and displays a simulation finish message.

7. The self-checking part of the code implements the functionality of the FIFO memory module. It uses an always block triggered by the positive edge of the clock (posedge clk) and two registers, waddr for the write address and raddr for the read address.

 - If the reset signal is low, the write address is set to 0.
 - When the write signal is high, data is written to the memory at the current write address, and the write address is incremented.
 - The $display function is used to print the simulation time, the value of data_out, and the value in memory at the write address.

 - If the reset signal is low, the read address is set to 0.
 - When the read signal is high and the FIFO is not empty, the read address is incremented.
 - If the read signal is high and the FIFO is not empty, it checks if the value read from memory matches data_out.
 - If they match, a pass message is displayed.
 - If the read address reaches 16, the simulation finishes.
 - If they don't match, a fail message is displayed, and the simulation finishes.



