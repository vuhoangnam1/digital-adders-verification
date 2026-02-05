module checker_skip(
input logic clk,
input logic [15:0] a,
input logic [15:0] b,
input logic C_i,
input logic [16:0] expected_sum, //kết quả mong đợi
input logic [16:0] actual_sum //kết quả thực tế //kết quả thực tế
);
//kiểm tra skip ở block 1 và 3
property test6;
@(posedge clk) 
a==16'h4AA8 && b==16'h4567 && C_i==1 |=> actual_sum==expected_sum;
endproperty
assert property(test6) else $error("fail | kiem tra skip o block 1 va 3");

//kiểm tra không skip ở bất kì block nào
property test7;
@(posedge clk)
a==16'h26E1 && b==16'h7A07 && C_i==1 |=> actual_sum==expected_sum;
endproperty
assert property(test7) else $error("fail | kiem tra cong co nho");


//kiểm tra tất cả block đều skip
property test8;
@(posedge clk)
a==16'hAAAA && b==16'h5555 && C_i==0 |=> actual_sum==expected_sum;
endproperty
assert property(test8) else $error("fail | kiem tra cong qua bien giau cac block");
endmodule

