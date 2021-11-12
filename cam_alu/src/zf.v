`timescale 1ns/10ps

module zf(Q, z);

input [31:0] Q;
output z;

wire [31:0] w;
wire zf_wire;

genvar i;

generate
    or_gate or_(.x(Q[0]), .y(Q[1]), .z(w[0]));
    for(i = 1; i < 31; i = i + 1) begin
        or_gate or_1(.x(Q[i]), .y(w[i-1]), .z(w[i]));
    end
    not_gate not_(.x(w[31]), .z(zf_wire));
endgenerate

assign z = zf_wire;

endmodule