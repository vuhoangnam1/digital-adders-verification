//kế thừa từ uvm_env dùng để gom agent và scoreboard
class csa_environment extends uvm_env;
`uvm_component_utils(csa_environment); //marco UVM cho phép tạo create ghi đè tự động
csa_agent agn;
csa_scoreboard scb; 
csa_subscriber sub;
function new(string name,uvm_component parent);
super.new(name,parent); //gọi constructor lớp cha
endfunction

function void build_phase(uvm_phase phase);
super.build_phase(phase); //gọi build_phase của lớp cha
agn = csa_agent::type_id::create("agn",this); //tạo agent
scb = csa_scoreboard::type_id::create("scb",this); //tạo scoreboard
sub = csa_subscriber::type_id::create("sub",this); //tạo subscriber
endfunction
//analysis port của monitor trong agent đến analysis imp của scoreboard
function void connect_phase(uvm_phase phase);
//cho phép monitor gửi transaction tới scoreboard thông qua cơ chế write()
agn.ap.connect(scb.imp);
//cho phép monitor gửi transaction tới subscriber thông qua cơ chế write()
agn.ap.connect(sub.analysis_export);
endfunction
endclass
