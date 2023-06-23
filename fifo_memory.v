/*
Author: Prerna Sarkar
Date last modified: 06/23/2023
Description: 16 stage FIFO memory implementation in Verilog (8-bit data)
*/

module fifo_mem(data_out, is_full, is_empty, threshold, overflow, underflow, clk, rst_n, write, read, data_in);  
  
  input write, read, clk, rst_n;  // rst_n => active low (i.e. negated rst signal)
  input[7:0] data_in;
  output[7:0] data_out;  
  output is_full, is_empty, threshold, overflow, underflow;  
  
  wire[4:0] wptr,rptr;  
  wire wr_enable,rd_enable;   
  
  // instantiating the submodules
  write_pointer toplevel_submodule1(wptr,wr_enable,write,is_full,clk,rst_n);  
  read_pointer toplevel_submodule2(rptr,rd_enable,read,is_empty,clk,rst_n);  
  memory_array toplevel_submodule3(data_out, data_in, clk,wr_enable, wptr,rptr);  
  status_signal toplevel_submodule4(is_full, is_empty, threshold, overflow, underflow, write, read, wr_enable, rd_enable, wptr,rptr,clk,rst_n);  
  
endmodule  

// Write Pointer sub-module 
module write_pointer(wptr,wr_enable,write,is_full,clk,rst_n);
 
  input write,is_full,clk,rst_n;  
  
  output[4:0] wptr;  
  output wr_enable;  
  
  reg[4:0] wptr;  
  
  assign wr_enable = (~is_full)&write; // write enabled only if memory is not full and its a write instruction
  
  always @(posedge clk or negedge rst_n)  
  begin  
   if(~rst_n) wptr <= 5'b000000;  // reset
   else if(wr_enable)  
    wptr <= wptr + 5'b000001;  // if wr_enable is true, increment wptr
   else  
    wptr <= wptr; // maintain curr val of wptr
  end  
  
endmodule  
 
// Read Pointer submodule 
module read_pointer(rptr,rd_enable,read,is_empty,clk,rst_n);  
 
  input read,is_empty,clk,rst_n;  
  
  output[4:0] rptr;  
  output rd_enable;  
  
  reg[4:0] rptr;  
  
  assign rd_enable = (~is_empty)& read; // read enabled only if memory is non-empty and its a read instruction
  
  always @(posedge clk or negedge rst_n)  
  begin  
   if(~rst_n) rptr <= 5'b000000;  // reset
   else if(rd_enable)  
    rptr <= rptr + 5'b000001;  // if rd_enable is true, increment rptr
   else  
    rptr <= rptr;  // maintain curr val of rptr
  end  
endmodule  

// Memory Array submodule 
module memory_array(data_out, data_in, clk,wr_enable, wptr,rptr);  
  
  input[7:0] data_in;  
  input clk,wr_enable;  
  input[4:0] wptr,rptr;  
  
  output[7:0] data_out;  
  
  reg[7:0] data_out2[15:0];  
  
  wire[7:0] data_out;  
  
  always @(posedge clk)  
  begin  
   if(wr_enable)   
      data_out2[wptr[3:0]] <=data_in ;  // for write instructions, store data_in
  end  
  
  assign data_out = data_out2[rptr[3:0]];  // assign stored data_in to output
  
endmodule  
 
// Status Signals submodule 
module status_signal(is_full, is_empty, threshold, overflow, underflow, write, read, wr_enable, rd_enable, wptr,rptr,clk,rst_n);  
 
  input write, read, wr_enable, rd_enable,clk,rst_n;  
  input[4:0] wptr, rptr;  
  
  output is_full, is_empty, threshold, overflow, underflow;
  
  wire diff_msb_diff_bank, overflow_set, underflow_set;  
  wire pointer_equal;  
  wire[4:0] pointer_diff;  
  
  reg is_full, is_empty, threshold, overflow, underflow;
  
  assign diff_msb_diff_bank = wptr[4] ^ rptr[4]; // note: organizing memory into different banks allows simultaneous read and write operations
  assign pointer_equal = (wptr[3:0] - rptr[3:0]) ? 0:1;  
  assign pointer_diff = wptr[4:0] - rptr[4:0]; // to determine the number of memory locations or entries between rptr and wptr
  assign overflow_set = is_full&write;  
  assign underflow_set = is_empty&read;  
  
  always @(*)  
  begin  
   is_full = diff_msb_diff_bank & pointer_equal;  
   is_empty = (~diff_msb_diff_bank) & pointer_equal;  
   threshold = (pointer_diff[4]||pointer_diff[3]) ? 1:0; // since 16 stage memory: if diff between rptr and wptr reaches or exceeds (2^4) 16 or (2^3) 8, we set threshold to 1
  end  
  
  // overflow : if full + trying to write, AND no read enable
  always @(posedge clk or negedge rst_n)  
  begin  
  if(~rst_n) overflow <=0;  // reset
  else if((overflow_set==1)&&(rd_enable==0))
   overflow <=1;  
  else if(rd_enable)  
    overflow <=0;
  else  
     overflow <= overflow;
  end  
  
  // underflow : if empty + trying to read, AND no write enable
  always @(posedge clk or negedge rst_n)  
  begin  
	if(~rst_n) underflow <=0;  
	else if((underflow_set==1)&&(wr_enable==0))  
	  underflow <=1;  
	else if(wr_enable)  
	  underflow <=0;  
	else  
	  underflow <= underflow;  
  end  
  
endmodule  