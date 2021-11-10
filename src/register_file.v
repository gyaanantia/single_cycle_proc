// 32 of the 32-bit registers

module register_file(read_reg1, read_reg2, write_reg, write_data, write_enable, read_data1, read_data2);

input [4:0] read_reg1, read_reg2, write_reg;
input [31:0] write_data;
input write_enable;
output wire [31:0] read_data1, read_data2;

