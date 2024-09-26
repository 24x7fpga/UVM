`include "uvm_macros.svh"
import uvm_pkg::*;

class cls_copy extends uvm_object;

   rand bit [3:0] cp_a;
   rand bit [7:0] cp_b;

   // factory register data objects
   `uvm_object_utils_begin(cls_copy)
      `uvm_field_int(cp_a, UVM_DEFAULT);
      `uvm_field_int(cp_b, UVM_DEFAULT);
   `uvm_object_utils_end

   // construct uvm object
   function new(string path = "cls_copy");
      super.new(path);
   endfunction // new

endclass // cls_copy

class cls_copy_child extends cls_copy;

   rand bit [9:0] cp_ch_c;

   // factory register data objects
   `uvm_object_utils_begin(cls_copy_child)
      `uvm_field_int(cp_ch_c, UVM_DEFAULT);
   `uvm_field_utils_end

   // construct uvm object
   function new(string path = "cls_copy_child");
      super.new(path);
   endfunction // new

endclass // cls_copy_child

// do method
class obj_do extends uvm_object;
   // factory registration
   `uvm_object_utils(obj_do)

   //contruct the class
   function new(string path = "obj_do");
      super.new(path);
   endfunction // new

   rand bit [3:0] do_a;
   rand bit [7:0] do_b;

   string	  s = "Display Text";

   // do_copy method
   virtual function void do_copy(uvm_object rhs);
      obj_do temp;             // create a handle of the object
      $cast(temp, rhs);        // check to type match
      super.do_copy(rhs);      // syntax
      this.do_a = temp.do_a;
      this.do_b = temp.do_b;
   endfunction // do_copy

   // do_print method
   virtual function void do_print(uvm_printer printer);
      super.do_print(printer);
      printer.print_field_int("do_a", do_a, $bits(do_a), UVM_HEX);
      printer.print_field_int("do_b", do_b, $bits(do_b), UVM_BIN);
      printer.print_string("s", s);
   endfunction // do_print

   // convert2string method
   virtual function string convert2string();
      string str = super.convert2string();
      str = {str, $sformatf("do_a = %0d, ", do_a)};
      str = {str, $sformatf("do_b = %0d, ", do_b)};
      str = {str, $sformatf("str  = %0s ", s)};
      return str;
   endfunction // convert2string

   // do_compare
   virtual function bit do_compare(uvm_object rhs, uvm_comparer comparer);
      obj_do temp;
      int status;
      $cast(temp,rhs);
      status = super.do_compare(rhs, comparer) && (do_a == temp.do_a) && (do_b == temp.do_b);
      return status;
   endfunction // do_compare
   
endclass // obj_do


 
   
module tb_cmn_op;

   cls_copy cls_cp1, cls_cp2, cls_cp3;

   obj_do obj_do1, obj_do2;

   int status;
  
  initial begin 
     // construct/build objects
     cls_cp1 = cls_copy::type_id::create("cls_cp1");
     cls_cp2 = cls_copy::type_id::create("cls_cp2");
     // generate random values
     cls_cp1.randomize();
     cls_cp2.copy(cls_cp1);
     // print both the objects
     $display("---------------------------- Copy ----------------------------");
     cls_cp1.print();
     cls_cp2.print();   
     // clone
     $cast(cls_cp3, cls_cp1.clone());
     // print cloned copy
     $display("---------------------------- Clone ----------------------------");
     cls_cp3.print();
     
     $display("---------------------------- Do_Copy ----------------------------");
     obj_do1 = obj_do::type_id::create("obj_do1");
     obj_do2 = obj_do::type_id::create("obj_do2");
     obj_do1.randomize();
     obj_do1.print();
     obj_do2.copy(obj_do1);
     obj_do2.print();
     $display("---------------------------- Compare ----------------------------");
     status = obj_do2.compare(obj_do1);
     `uvm_info("TB_TOP", $sformatf("Compare Status is %0d", status), UVM_NONE);
     
$display("---------------------------- Convert2String ----------------------------");
     `uvm_info("TB_TOP", $sformatf("Data in String : %0s ", obj_do2.convert2string()), UVM_NONE);
   end

endmodule // tb_cmn_op
