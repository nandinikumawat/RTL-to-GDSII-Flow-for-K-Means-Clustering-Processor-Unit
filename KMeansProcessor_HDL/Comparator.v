module Comparator (
    input [31:0] A, B,
    output comp_out
);
    assign comp_out = (A > B);  // 1 if A > B, 0 otherwise
endmodule

