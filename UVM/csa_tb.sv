//inclue các class uvm được gom trong my_pkg
`include "../my_pkg1/my_pkg1.sv"
//import các class, macro của UVM và các thành phần định nghĩa trong my_pkg.
import uvm_pkg::*; 
import my_pkg1::*;
module csa_tb;
//khởi tạo interface ảo kết nối giữa DUT và testbench
csa_interface csa_if();
//kết nối DUT với các tín hiệu trong interface 
carry_skip_adder_16bit dut(
.clk(csa_if.clk),
.a(csa_if.a),
.b(csa_if.b),
.C_i(csa_if.C_i),
.S(csa_if.S),
.C_o(csa_if.C_o)
);
//tạo chu kỳ xung clock
always #5 csa_if.clk=~csa_if.clk;

//khởi tạo các tín hiệu
initial begin
csa_if.clk = 0;
uvm_config_db #(virtual csa_interface)::set(null, "*", "vif", csa_if);
run_test("csa_test"); //gọi tại time 0
end
endmodule
