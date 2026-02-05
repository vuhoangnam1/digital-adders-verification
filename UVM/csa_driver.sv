//kế thừa từ uvm_driver, dùng để điều khiển DUT theo transaction kiểu vending_machine_transaction
class csa_driver extends uvm_driver#(csa_transaction); 
`uvm_component_utils(csa_driver); //marco UVM cho phép tạo create ghi đè tự động
virtual csa_interface vif; //virtual interface để kết nối với DUT
function new(string name = "csa_driver", uvm_component parent);
super.new(name, parent); //gọi constructor lớp cha
endfunction

function void build_phase(uvm_phase phase);
super.build_phase(phase); //gọi build_phase lớp cha
//lấy virtual interface từ config_db; nếu không có thì sẽ báo lỗi
if(!uvm_config_db#(virtual csa_interface)::get(this,"","vif",vif))
`uvm_error("NOVIF","khong tim thay virtual interface")
endfunction

task run_phase(uvm_phase phase);
csa_transaction tr; //biến tr lưu transaction 
forever begin
repeat (1)@(posedge vif.clk);
seq_item_port.get_next_item(tr);  // nhận transaction từ sequence
//in ra kiểm tra thông tin của transaction vừa nhận được từ sequence
`uvm_info("DRIVER", $sformatf("t=%0t |da nhan duoc transaction: a = %0h, b = %0h, C_i = %0d",$time, tr.a, tr.b, tr.C_i), UVM_LOW)
//gửi tín hiệu vào
vif.a <= tr.a;
vif.b <= tr.b;
vif.C_i <= tr.C_i;
repeat (2)@(posedge vif.clk); //delay 2 chu kì để vào qua trường hợp khác
seq_item_port.item_done(); // báo đã gửi xong
end
endtask
endclass

