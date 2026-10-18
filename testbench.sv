`timescale 1ns/1ns

`include "uvm_macros.svh" // contains all uvm macros

import uvm_pkg::*; // contains all uvm base classes

//include classes in order
`include "interface.sv"
`include "seq_item.sv"
`include "sequence.sv"
`include "sequencer.sv"
`include "driver.sv"
`include "monitor.sv"
`include "agent.sv"
`include "scoreboard.sv"
`include "environment.sv"
`include "test.sv"

module top;
  
  logic clk;
  logic rst;
  //..instantiation of lower modules.. Mainly DUT,Interface
  
  dff dut (
    .clk (intf.clk),
    .rst(intf.rst),
    .d(intf.d),
    .q(intf.q)
  );
  
  dff_intf intf(.clk(clk), .rst(rst)); //(.interface clk(topmodule clk))
  
  initial begin 
    uvm_config_db#(virtual dff_intf)::set(null,"*","vif",intf);
  end
/*  uvm_config_db#(virtual dff_intf)::set(
    null,      // inst_name or parent context. null : We are setting it from outside the UVM hierarchy
    "*",       // instance path (where to apply) * : All components below the current hierarchy can access this config
    insted of * we can use path, "env.agent.driver"     // Only the driver inside agent under env
    "vif",     // field name (key)
    intf       // value (actual object or interface handle)
);
 */ 
  
  initial  begin
    clk = 0;
    rst = 1;
    #20 rst = 0;
  end
    always #10 clk = ~clk;
   
  initial begin
    $monitor($time, "clk = %d", clk);
     //enable wave dump
    $dumpfile("dump.vcd"); 
    $dumpvars;
    //#100 $finish;
  end
   
  initial begin 
    run_test("dff_test");//Start simulation and run the UVM test class named dff_test.
  end
  
endmodule