//kế thừa từ uvm_agent, dùng để gom nhóm các driver, sequencer và monitor
class csa_agent extends uvm_agent; 
`uvm_component_utils(csa_agent); //marco UVM cho phép tạo create ghi đè tự động
uvm_analysis_port #(csa_transaction) ap; //analysis port dùng để gửi dữ liệu từ monitor sang scoreboard
csa_driver dvr; // driver dùng để điều khiển DUT theo transaction
uvm_sequencer#(csa_transaction) sqr; //sequencer phát transaction cho driver
csa_monitor mon; //monitor quan sát tín hiệu đầu ra của DUT
function new(string name, uvm_component parent);
super.new(name, parent); //gọi constructor lớp cha
endfunction

function void build_phase(uvm_phase phase);
super.build_phase(phase); //gọi build_phase của lớp cha
ap = new("ap",this); //tạo analysis port
dvr = csa_driver::type_id::create("dvr",this); //tạo driver
sqr = csa_sequencer::type_id::create("sqr",this); //tạo sequencer
mon = csa_monitor::type_id::create("mon",this); //tạo monitor
endfunction
//kết nối analysis_port của monitor với analysis_port của agent giúp agent có thể chuyển tiếp dữ liệu monitor ra ngoài
function void connect_phase(uvm_phase phase);
mon.ap.connect(ap); 
dvr.seq_item_port.connect(sqr.seq_item_export); //driver kết nối seq_item_port với sequencer
endfunction
endclass


