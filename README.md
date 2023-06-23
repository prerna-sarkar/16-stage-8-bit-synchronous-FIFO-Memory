# FIFO-Memory-using-Verilog

This repository contains the Verilog code for a FIFO (First-In, First-Out) memory circuit. The FIFO memory is implemented using modules to manage the read and write operations, memory storage, and status signal calculation.

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
- Outputs: is_full, is_empty, at_capacity, overflow, and underflow.
- Uses combinational logic to determine the status flags based on the control signals and pointer values.
- Calculates is_full by comparing the most significant bit of the write and read pointers.
- Calculates is_empty by comparing the most significant bit of the write and read pointers and the equality of the lower bits.
- Calculates at_capacity based on the result of the pointer subtraction.
- Determines overflow and underflow based on the control signals and the read and write operations.

### Reference
![image](https://github.com/prerna-sarkar/FIFO-Memory-using-Verilog/assets/40262089/7a4d246b-dcd8-4554-9b13-e9a9cdc4fc0e)




