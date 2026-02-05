module monitor(
input logic clk,
input logic [16:0] expected_sum, //kết quả mong đợi
input logic [16:0] actual_sum //kết quả mong đợi
);
always @(posedge clk) begin
@(posedge clk);
$display("expected_sum =%0d | actual_sum=%0d",expected_sum,actual_sum);
end
endmodule
