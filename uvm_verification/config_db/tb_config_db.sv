`include "uvm_macros.svh"
import uvm_pkg::*;

//////////////////////////////////////////////////////////////////////////
//                            Interface
//////////////////////////////////////////////////////////////////////////
interface intf;
   logic [3:0] a = 4'h0;
   logic [7:0] b = 8'h0;
endinterface
//////////////////////////////////////////////////////////////////////////
//                              Driver
//////////////////////////////////////////////////////////////////////////
class drv extends uvm_driver;
   `uvm_component_utils(drv);

   virtual intf vif_intf;

   function new(string path = "drv", uvm_component parent = null);
      super.new(path, parent);
   endfunction // new

   virtual function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      if(!uvm_config_db#(virtual intf)::get(this, "", "vif_intf", vif_intf))
	`uvm_info("DRV", "Unable to access the interface", UVM_NONE);
   endfunction // build_phase

   virtual task run_phase(uvm_phase phase);
      phase.raise_objection(this);
      repeat(4)begin
	 vif_intf.a <= $urandom;
	 vif_intf.b <= $urandom;
         `uvm_info("DRV", $sformatf("Generated data is a = %0d, b = %0d", vif_intf.a, vif_intf.b), UVM_NONE);
	 #10;
      end
      phase.drop_objection(this);
   endtask // run_phase

endclass // drv
//////////////////////////////////////////////////////////////////////////
//                             Monitor
//////////////////////////////////////////////////////////////////////////
class mon extends uvm_monitor;
   `uvm_component_utils(mon);

   virtual intf vif_intf;

   function new(string path = "mon", uvm_component parent = null);
      super.new(path,parent);
   endfunction // new

   virtual function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      if(!uvm_config_db#(virtual intf)::get(this, "", "vif_intf", vif_intf))
	`uvm_info("MON", "Unable to access the interface", UVM_NONE);
   endfunction // build_phase

   virtual task run_phase(uvm_phase phase);
      phase.raise_objection(this);
      repeat(4)begin
      `uvm_info("MON", $sformatf("Received data is a = %0d, b = %0d", vif_intf.a, vif_intf.b), UVM_NONE);
      #10;
      end
      phase.drop_objection(this);
   endtask // run_phase

endclass // mon
//////////////////////////////////////////////////////////////////////////
//                                Agent
//////////////////////////////////////////////////////////////////////////
class agt extends uvm_agent;
   `uvm_component_utils(agt);

   drv d;
   mon m;

   virtual intf vif_intf;
   
   function new(string path = "agt", uvm_component parent = null);
      super.new(path,parent);
   endfunction // new

   virtual function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      d = drv::type_id::create("drv", this);
      m = mon::type_id::create("mon", this);
   endfunction // build_phase

endclass // agt
//////////////////////////////////////////////////////////////////////////
//                            Environment
//////////////////////////////////////////////////////////////////////////
class env extends uvm_env;
   `uvm_component_utils(env);

   agt a;

   function new(string path = "env", uvm_component parent = null);
      super.new(path,parent);
   endfunction // new

   virtual function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      a = agt::type_id::create("agt", this);
   endfunction // build_phase

endclass // env
//////////////////////////////////////////////////////////////////////////
//                              Test
//////////////////////////////////////////////////////////////////////////
class test extends uvm_test;
   `uvm_component_utils(test);

   env e;
   
   function new(string path = "test", uvm_component parent = null);
      super.new(path,parent);
   endfunction // new

   virtual function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      e = env::type_id::create("env", this);
   endfunction // build_phase

   virtual function void end_of_elaboration_phase(uvm_phase phase);
      uvm_top.print_topology;
   endfunction // end_of_elaboration_phase
   
endclass // test
//////////////////////////////////////////////////////////////////////////
//                              Test Top
//////////////////////////////////////////////////////////////////////////
module tb_config_db;

   intf vif_intf();
   
   initial begin
      uvm_config_db#(virtual intf)::set(null, "uvm_test_top.env.agt*", "vif_intf", vif_intf);
      run_test("test");
   end

endmodule // tb_config_db

      
      
      
