// type r
`define INST_TYPE_R     6'b000000 // decode according to funct field, op = 6'b000000
    `define INST_SLL    6'b000000 // sll
    `define INST_ADD    6'b100000 // add
    `define INST_SUB    6'b100010 // sub
    `define INST_AND    6'b100100 // and
// type i
`define INST_ADDIU      6'b001001 // addiu
`define INST_LW         6'b100011 // lw
`define INST_SW         6'b101011 // sw
`define INST_LUI        6'b001111 // lui
`define INST_ORI        6'b001101 // ori
`define INST_BEQ        6'b000100 // beq

// type j
`define INST_J          6'b000010 // j
`define INST_JAL        6'b000011 // jal