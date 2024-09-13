`include "uvm_macros.svh"
 import uvm_pkg::*;

module tb_rpt_msg;

   initial begin

      /////////////////////////////////////////////////////////////////////////
      // Task 1: Observe the usage of verbosity
      /////////////////////////////////////////////////////////////////////////
      $display("------------------ Task 1 ------------------");
 
      // display the defualt uvm verbosity
      $display("Default UVM Verbosity: %0d", uvm_top.get_report_verbosity_level);

      // display a list of messages
      `uvm_info("REPORT MSG1", "Low Verbosity", UVM_LOW);
      `uvm_info("REPORT MSG2", "Medium Verbosity", UVM_MEDIUM);
      `uvm_info("REPORT MSG3", "High Verbosity", UVM_HIGH);

     
      /////////////////////////////////////////////////////////////////////////
      // Task 2: Change default verbosity
      /////////////////////////////////////////////////////////////////////////
      $display("------------------ Task 2 ------------------");

      // change verbosity
      uvm_top.set_report_verbosity_level(UVM_HIGH);

      // display the changed verbosity
      $display("CHANGED UVM Verbosity: %0d", uvm_top.get_report_verbosity_level);

      // display a list of messages
      `uvm_info("REPORT MSG1", "Low Verbosity", UVM_LOW);
      `uvm_info("REPORT MSG2", "Medium Verbosity", UVM_MEDIUM);
      `uvm_info("REPORT MSG3", "High Verbosity", UVM_HIGH);

     
 
      /////////////////////////////////////////////////////////////////////////
      // Task 3: Change Verbosity using String ID
      /////////////////////////////////////////////////////////////////////////
      $display("------------------ Task 3 ------------------");
 
      
      // change verbosity to low
      uvm_top.set_report_verbosity_level(UVM_LOW);
      
      // display the changed verbosity
      $display("CHANGED UVM Verbosity: %0d", uvm_top.get_report_verbosity_level);

      // change the verbosity using the message id
      uvm_top.set_report_id_verbosity("REPORT MSG3",UVM_HIGH);

      // display a list of messages
      `uvm_info("REPORT MSG1", "Low Verbosity", UVM_LOW);
      `uvm_info("REPORT MSG2", "Medium Verbosity", UVM_MEDIUM);
      `uvm_info("REPORT MSG3", "High Verbosity", UVM_HIGH);
   end // initial begin

endmodule // rpt_msg
