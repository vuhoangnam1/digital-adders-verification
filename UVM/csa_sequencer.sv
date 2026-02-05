// Kế thừa từ uvm_sequencer, chuyên dùng để điều phối các transaction kiểu csa_transaction
class csa_sequencer extends uvm_sequencer #(csa_transaction);
`uvm_component_utils(csa_sequencer)
function new(string name, uvm_component parent);
super.new(name, parent);
endfunction
endclass
