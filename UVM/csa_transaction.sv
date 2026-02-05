//transaction kế thừa từ sequence_item để dùng trong sequence
class csa_transaction extends uvm_sequence_item;
rand bit [15:0] a;
rand bit [15:0] b;
rand bit [15:0] C_i;
bit [15:0] S;
bit C_o;
bit [16:0] expected_sum;
bit [16:0] actual_sum;
//tầm trị của a,b và C_i
constraint value{
 a inside {[0:65535]};
 b inside {[0:65535]};
 C_i inside {[0:1]};
}
`uvm_object_utils(csa_transaction) //marco UVM cho phép tạo create ghi đè tự động	
function new(string name = "csa_transaction");
super.new(name);//gọi constructor lớp cha
endfunction
endclass
