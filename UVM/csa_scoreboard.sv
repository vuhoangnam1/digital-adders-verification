//kế thừa từ uvm_scoreboard dùng để kiểm tra kết quả DUT trả về có đúng hay không
class csa_scoreboard extends uvm_scoreboard;
//tạo các biến sử dụng cho vòng lặp ở kiểm tra skip ở các khối block
int i,j; 
int block;
int skip;
//biến báo số lần vào socreboard
int n=1;
//biến chứa giá trị tổng kỳ vọng và tổng thực tế từ DUT 
logic [16:0] expected_sum;
logic [16:0] actual_sum;
`uvm_component_utils(csa_scoreboard); //marco UVM cho phép tạo create ghi đè tự động
//analysis_imp cho phép scoreboard nhận transaction từ agent thông qua phương thức write()
uvm_analysis_imp#(csa_transaction, csa_scoreboard) imp;
function new(string name ="csa_scoreboard", uvm_component parent);
super.new(name,parent); //gọi constructor lớp cha
imp=new("imp",this); //khởi tạo analysis_imp để nhận transaction
endfunction

function bit all_propagate(input logic [15:0] a, input logic [15:0] b);
begin
`uvm_info("SCOREBOARD",$sformatf("kiem tra skip o cac khoi block"),UVM_LOW )
skip = 0; //skip=0 mỗi lần vào hàm
//Kiểm tra lần lượt a^b ở 4 khối block
//Giả sử ở mỗi vòng lặp của i có skip, cho block=1
//Nếu trong 1 khối block có 1-bit a^b=0 thì tức là block =0,block đó không có skip, thoát vòng lặp đi kiểm tra block tiếp theo
	for(i=0;i<16;i=i+4) begin
		block=1; //giả sử block này có skip
		for(j=0;j<4;j++) begin
			if((a[i+j]^b[i+j])==0) begin
			block=0; //nếu 1-bit không propagate thì không thể skip
			break;
			end
		end	
		//in ra kết quả có skip và không có skip ở block nào đó ngay sau khi thoát vòng lặp j tại block đó
	if(block==1) begin
	skip = 1;
	`uvm_info("SCOREBOARD", $sformatf("Co block skip o [%0d:%0d]", i+3, i), UVM_LOW)
	end else begin
	`uvm_info("SCOREBOARD", $sformatf("block khong skip o [%0d:%0d]", i+3, i), UVM_LOW)
	end
	end

//In ra kết qua không có khối block nào skip
if(skip==0) begin
`uvm_info("SCOREBOARD",$sformatf("khong co block nao skip"),UVM_LOW )
end
return skip;
end
endfunction

//gọi khi monitor gửi 1 transaction đến scoreboard để kiểm tra	
function void write(csa_transaction tr);
expected_sum= tr.a+tr.b+tr.C_i;
actual_sum = {tr.C_o, tr.S};
//in ra thông báo khi scoreboard bắt đầu xử lý một transaction
//kiểm tra xem transaction từ monitor có thực sự tới được scoreboard hay không
`uvm_info("SCOREBOARD", $sformatf("t=%0t da vao ham write() lan %0d", $time,n), UVM_LOW);
n++;
//in kết quả mong đợi
$display("[SCOREBOARD] | t=%0t | a: %0h | b: %0h | C_i: %0h | C_o: %0h | S: %0h",$time,tr.a,tr.b,tr.C_i,tr.C_o,tr.S);
if(expected_sum == actual_sum) begin
	`uvm_info("SCOREBOARD", $sformatf("PASS | expected_sum: %0h | actual_sum: %0h",expected_sum,actual_sum), UVM_LOW)
		if(all_propagate(tr.a,tr.b)) begin
		`uvm_info("SCOREBOARD", $sformatf("Random test (skip)"), UVM_LOW)
		$display("////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////");
		end else begin
		`uvm_info("SCOREBOARD", $sformatf("Random test (no skip)"), UVM_LOW)
		$display("////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////");
		end		 
end else begin
	`uvm_error("SCOREBOARD", $sformatf("FAIL | expected_sum: %0h | actual_sum: %0h | gia tri dau ra sai!",expected_sum,actual_sum))
end
endfunction
endclass

	
	


		
		


