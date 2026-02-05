//kế thừa từ uvm_sequence kiểu dữ liệu csa_transaction, là nơi tạo và điều khiển các transaction sẽ gửi đến DUT
class csa_sequence extends uvm_sequence#(csa_transaction);
int n=100;
`uvm_object_utils(csa_sequence)
function new(string name = "csa_sequence"); //marco UVM cho phép tạo create ghi đè tự động
super.new(name); //gọi constructor lớp cha
endfunction
//task chính thực thi nội dung của sequence, dùng để tạo và gửi transaction
task body();
//vòng lặp random 
repeat(n)
begin
csa_transaction tr;
tr = csa_transaction::type_id::create("tr");;
//gán giá trị ngẫu nhiện cho a, b và C_i 
assert(tr.randomize());
start_item(tr); //báo sẵn sàng truyền transaction cho driver
finish_item(tr); //báo cho driver đã hoàn tất truyền transaction 
end
endtask
endclass

