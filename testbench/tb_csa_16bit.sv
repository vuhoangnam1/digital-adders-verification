`timescale 1ns/1ps
module tb_csa_16bit;
logic [15:0] a;
logic [15:0] b;
logic C_i;
logic [15:0] S;
logic C_o;
logic clk;
logic [16:0] expected_sum; //kết quả mong đợi
logic [16:0] actual_sum; //kết quả thực tế
int i,j; //tạo biến sử dụng cho vòng lặp ở kiểm tra skip ở các khối block
int n;
int block;
int skip;
//kết nối module carry_skip_adder_16bit
carry_skip_adder_16bit dut(
.a(a),
.b(b),
.C_i(C_i),
.S(S),
.C_o(C_o)
);
//gộp carry-out và sum lại thành actual_sum, caary-out đóng vai trò là bit thứ 17 của kết quả tổng
assign actual_sum = {C_o, S};
//tạo chu kì xung clocking
always #5 clk=~clk;

//hàm task kiểm tra kết quả
task check_result(string name, logic [16:0] expected_result, logic [16:0] actual_result);
begin
if(expected_result == actual_result) begin
$display("%s | expected_result =%0d | actual_result=%0d",name,expected_result,actual_result);
end else begin
$display("%s | expected_result =%0d sai | actual_result=%0d",name,expected_result,actual_result);
$stop;
end
end
endtask
//kiểm tra block skip
function bit all_propagate(input logic [15:0] a, input logic [15:0] b);
begin
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
	$display("Co block skip o [%0d:%0d]", i+3, i);
	end else begin
	$display("block khong skip o [%0d:%0d]", i+3, i);
	end
	end

//In ra kết qua không có khối block nào skip
if(skip==0) begin
$display("khong co block nao skip");
end
return skip;
end
endfunction


//Kiểm tra function coverage
covergroup cvg@(posedge clk);
//coverpoint cho tín hiệu clk theo dõi trạng thái high/low
cvgp_clk: coverpoint clk{
bins clk_l ={0};
bins clk_h ={1};
}
//coverpoint cho giá trị a
cvgp_a: coverpoint a{
bins vl_a ={[0:65535]};
}
//coverpoint cho giá trị b
cvgp_b: coverpoint b{
bins vl_b ={[0:65535]};
}
//coverpoint cho giá trị carry-in
cvgp_C_i: coverpoint C_i{
bins vl_C_i ={[0:1]};
}

//coverpoint cho giá trị carry-out
cvgp_C_o: coverpoint C_o{
bins vl_C_o ={[0:1]};
}
//coverpoint cho giá trị sum
cvgp_S: coverpoint S{
bins vl_S ={[0:65535]};

}
//kiểm tra tổ hợp 
cross_all: cross cvgp_a, cvgp_b, cvgp_C_i, cvgp_C_o, cvgp_S;
endgroup
// Khai báo một biến tên là cp thuộc kiểu covergroup cvg
cvg cp; 
always @(posedge clk) begin
  cp.sample(); // Thu thập coverage mỗi xung clock
end

//bắt đầu chạy kiểm tra
initial begin
clk=0;
cp = new(); // kích hoạt covergroup để bắt đầu thu thập coverage
$dumpfile("wave.vcd");
$dumpvars(0, tb_csa_16bit);
//kiểm tra các hoạt động cơ bản
//kiểm tra cộng không nhớ
a=4; b=3; C_i=0; expected_sum=7; #10;
$display("///////////////////////");
$display("kiem tra cong khong nho");
check_result("4 + 3 + 0", expected_sum, actual_sum);

//kiểm tra cộng có nhớ
a=8; b=8; C_i=1; expected_sum=17; #10;
$display("///////////////////////");
$display("kiem tra cong co nho");
check_result("8 + 8 + 1", expected_sum, actual_sum);

//kiểm tra cộng qua biên giữa các block
a=15; b=1; C_i=0; expected_sum=16; #10;
$display("///////////////////////");
$display("kiem tra cong qua giua cac bien");
check_result("15 + 1 + 0", expected_sum, actual_sum);

//kiểm tra tràn 16 bit
a=65535; b=1; C_i=1; expected_sum=65537; #10;
$display("///////////////////////");
$display("kiem tra tran 16-bit");
check_result("65535 + 1 + 1 | tran 16-bit", expected_sum, actual_sum);

//kiểm tra các bit bằng 0
a=0; b=0; C_i=0; expected_sum=0; #10;
$display("///////////////////////");
$display("kiem tra cac bit bang 0");
check_result("0 + 0 + 0", expected_sum, actual_sum);

//kiểm tra skip ở block 1 và 3
a=16'h4AA8; b=16'h4567; C_i=1; expected_sum=16'h9010; #10;
$display("///////////////////////");
$display("kiem tra skip o block 1 va 3");
check_result("19112 + 17767 + 1", expected_sum, actual_sum);
//all_propagate() phải trả về 1
if(all_propagate(a, b)) begin
check_result("skip o block1 va block3", expected_sum, actual_sum);
end else begin
$display("Khong co block nao skip, khong nhu mong doi");
end

//kiểm tra không skip ở bất kì block nào
a=16'h26E1; b=16'h7A07; C_i=1; expected_sum=16'hA0E9; #10;
$display("///////////////////////");
$display("kiem tra khong skip o bat ki block nao ");
check_result("9953 + 31239 + 1", expected_sum, actual_sum);
//all_propagate() phải trả về 0
if(all_propagate(a, b)) begin
check_result("co block bi skip, khong dung nhu mong doi", expected_sum, actual_sum);
end else begin
check_result("khong co block nao skip", expected_sum, actual_sum);
end

//kiểm tra pattern xen kẻ, tất cả block đều skip
a=16'hAAAA; b=16'h5555; C_i=0; expected_sum=16'hFFFF; #10;
$display("///////////////////////");
$display("kiem tra tat ca block deu skip");
check_result("43690 + 5555 + 1", expected_sum, actual_sum);
//all_propagate() phải trả về 1
if(all_propagate(a, b)) begin
check_result("tat ca block deu skip",expected_sum, actual_sum);
end else begin
$display("Khong co block nao skip, khong nhu mong doi");
end

//Kiểm tra giá trị ngẫu nhiên
$display("///////////////////////");
$display("kiem tra cac gia tri ngau nhien");
$display("///////////////////////");
for(n=0;n<10;n++) begin
a=$urandom_range(0,65535); b=$urandom_range(0,65535); C_i=$urandom_range(0,1); expected_sum=a+b+C_i;
@(posedge clk); 
check_result($sformatf("Random test a=%0d + b=%d + C_i=%0d",a,b,C_i), expected_sum, actual_sum);
if(all_propagate(a,b)) begin
//function trả về 1
check_result($sformatf("Random test %0d (skip)", n), expected_sum, actual_sum);
$display("///////////////////////");
end else begin
//function trả về 0
check_result($sformatf("Random test %0d (no skip)", n), expected_sum, actual_sum);
$display("///////////////////////");
end
end
//in kết thúc
@(posedge clk);
$display("ket thuc kiem tra");
$display("Coverage = %0.2f%%", cp.get_coverage());
$stop;
end
endmodule


