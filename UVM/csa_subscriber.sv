class csa_subscriber extends uvm_subscriber#(csa_transaction);
`uvm_component_utils(csa_subscriber)
// Biến lưu dữ liệu để dùng cho covergroup
logic [15:0] a;
logic [15:0] b;
logic [15:0] S;
logic C_i;
logic C_o;

//Kiểm tra function coverage
covergroup cvg;

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

function new(string name = "csa_subscriber", uvm_component parent);
super.new(name,parent);
cvg = new(); // khởi tạo covergroup
endfunction

function void write(csa_transaction t);
// Lấy dữ liệu từ transaction
a=t.a;
b=t.b;
C_i=t.C_i;
C_o=t.C_o;
S=t.S;
// Lấy mẫu coverage
cvg.sample();
endfunction
endclass
