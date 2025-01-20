module SubtractionAndSquare (
    input [15:0] A,
    input [15:0] B,
    output [31:0] square
);
    wire [15:0] diff;
    wire [15:0] abs_diff;

    Subtractor16 subtractor (.A(A), .B(B), .Diff(diff));
    assign abs_diff = (diff[15] == 1) ? (~diff + 1) : diff;

    Multiplier16 mult (.A(abs_diff), .B(abs_diff), .Product(square));
endmodule
