module driver(
output logic clk
);
always #5 clk=~clk;
initial begin
clk=0;
end
endmodule

