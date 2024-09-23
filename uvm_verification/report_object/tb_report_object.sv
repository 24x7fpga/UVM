`include "uvm_macros.svh"
import uvm_pkg::*;

// create a class extending from uvm_object
class rpt_obj extends uvm_object;

   // factory registration
   `uvm_object_utils(rpt_obj);

   // construct the uvm object class
   function new(string path = "rpt_obj");
      super.new(path);
   endfunction // new

   function void disp_msg;
      `uvm_info("Report Object 1=> MSG1", "Low Verbosity", UVM_LOW);
      `uvm_info("Report Object 1=> MSG2", "Medium Verbosity", UVM_MEDIUM);
      `uvm_info("Report Object 1=> MSG3", "High Verbosity", UVM_HIGH);
   endfunction // disp_msg
   
endclass // rpt_obj

// main testbench

module tb_report_object;

   rpt_obj  RP;        // class handle
   
   initial begin
      // create method for class constuctor
      RP = rpt_obj::type_id::create("RP");     // similar to =>RP = new("rpt_obj");
      $display("Default UVM Verbosity: %0d", uvm_top.get_report_verbosity_level);
      RP.disp_msg;
      uvm_top.set_report_verbosity_level(UVM_HIGH);
      $display("Changed UVM Verbosity: %0d", uvm_top.get_report_verbosity_level);
      RP.disp_msg;
      uvm_top.set_report_verbosity_level(UVM_LOW);
      $display("Changed UVM Verbosity: %0d", uvm_top.get_report_verbosity_level);
      RP.disp_msg;
      uvm_top.set_report_id_verbosity("Report Object 1=> MSG2", UVM_MEDIUM);
      RP.disp_msg;
      
      
      
   end
   


endmodule // tb_report_object

