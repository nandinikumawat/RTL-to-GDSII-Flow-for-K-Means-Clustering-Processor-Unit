module Subtractor16 (
    input [15:0] A,             // Minuend
    input [15:0] B,             // Subtrahend
    output [15:0] Diff          // Difference output
);
    wire [15:0] borrow;         // Borrow wires for each stage

    FullSubtractor FS0  (.A(A[0]),  .B(B[0]),  .Bin(1'b0),       .D(Diff[0]), .Bout(borrow[0]));
    FullSubtractor FS1  (.A(A[1]),  .B(B[1]),  .Bin(borrow[0]),  .D(Diff[1]), .Bout(borrow[1]));
    FullSubtractor FS2  (.A(A[2]),  .B(B[2]),  .Bin(borrow[1]),  .D(Diff[2]), .Bout(borrow[2]));
    FullSubtractor FS3  (.A(A[3]),  .B(B[3]),  .Bin(borrow[2]),  .D(Diff[3]), .Bout(borrow[3]));
    FullSubtractor FS4  (.A(A[4]),  .B(B[4]),  .Bin(borrow[3]),  .D(Diff[4]), .Bout(borrow[4]));
    FullSubtractor FS5  (.A(A[5]),  .B(B[5]),  .Bin(borrow[4]),  .D(Diff[5]), .Bout(borrow[5]));
    FullSubtractor FS6  (.A(A[6]),  .B(B[6]),  .Bin(borrow[5]),  .D(Diff[6]), .Bout(borrow[6]));
    FullSubtractor FS7  (.A(A[7]),  .B(B[7]),  .Bin(borrow[6]),  .D(Diff[7]), .Bout(borrow[7]));
    FullSubtractor FS8  (.A(A[8]),  .B(B[8]),  .Bin(borrow[7]),  .D(Diff[8]), .Bout(borrow[8]));
    FullSubtractor FS9  (.A(A[9]),  .B(B[9]),  .Bin(borrow[8]),  .D(Diff[9]), .Bout(borrow[9]));
    FullSubtractor FS10 (.A(A[10]), .B(B[10]), .Bin(borrow[9]),  .D(Diff[10]), .Bout(borrow[10]));
    FullSubtractor FS11 (.A(A[11]), .B(B[11]), .Bin(borrow[10]), .D(Diff[11]), .Bout(borrow[11]));
    FullSubtractor FS12 (.A(A[12]), .B(B[12]), .Bin(borrow[11]), .D(Diff[12]), .Bout(borrow[12]));
    FullSubtractor FS13 (.A(A[13]), .B(B[13]), .Bin(borrow[12]), .D(Diff[13]), .Bout(borrow[13]));
    FullSubtractor FS14 (.A(A[14]), .B(B[14]), .Bin(borrow[13]), .D(Diff[14]), .Bout(borrow[14]));
    FullSubtractor FS15 (.A(A[15]), .B(B[15]), .Bin(borrow[14]), .D(Diff[15]), .Bout());
endmodule

