//my_pkg.sv
//tránh inclue trùng file 
`ifndef MY_PKG_SV
`define MY_PKG_SV
//nạp gói thư viện macro cho phép sử dụng uvm_component_utils, uvm_object_utils tạo macro
`include "uvm_macros.svh"
package my_pkg1; 
import uvm_pkg::*; //import uvm_pkg để sử dụng uvm_env, uvm_driver
// Include tất cả các file class liên quan đến UVM
 `include "../csa_transaction/csa_transaction.sv"
 `include "../csa_sequence/csa_sequence.sv"
 `include "../csa_sequencer/csa_sequencer.sv"
 `include "../csa_driver/csa_driver.sv"
 `include "../csa_monitor/csa_monitor.sv"
 `include "../csa_agent/csa_agent.sv"
 `include "../csa_scoreboard/csa_scoreboard.sv"
 `include "../csa_subscriber/csa_subscriber.sv"
 `include "../csa_environment/csa_environment.sv"
 `include "../csa_test/csa_test.sv"
endpackage
`endif
