module Adder32 (
    input [31:0] A,                // 32-bit input A
    input [31:0] B,                // 32-bit input B
    output [31:0] Sum              // 32-bit Sum output
);
    wire [31:0] carry;             // Carry signals for each stage

    // Instantiate 32 FullAdder modules, one for each bit
    FullAdder FA0  (.A(A[0]),  .B(B[0]),  .Cin(1'b0),       .Sum(Sum[0]),  .Cout(carry[0]));
    FullAdder FA1  (.A(A[1]),  .B(B[1]),  .Cin(carry[0]),   .Sum(Sum[1]),  .Cout(carry[1]));
    FullAdder FA2  (.A(A[2]),  .B(B[2]),  .Cin(carry[1]),   .Sum(Sum[2]),  .Cout(carry[2]));
    FullAdder FA3  (.A(A[3]),  .B(B[3]),  .Cin(carry[2]),   .Sum(Sum[3]),  .Cout(carry[3]));
    FullAdder FA4  (.A(A[4]),  .B(B[4]),  .Cin(carry[3]),   .Sum(Sum[4]),  .Cout(carry[4]));
    FullAdder FA5  (.A(A[5]),  .B(B[5]),  .Cin(carry[4]),   .Sum(Sum[5]),  .Cout(carry[5]));
    FullAdder FA6  (.A(A[6]),  .B(B[6]),  .Cin(carry[5]),   .Sum(Sum[6]),  .Cout(carry[6]));
    FullAdder FA7  (.A(A[7]),  .B(B[7]),  .Cin(carry[6]),   .Sum(Sum[7]),  .Cout(carry[7]));
    FullAdder FA8  (.A(A[8]),  .B(B[8]),  .Cin(carry[7]),   .Sum(Sum[8]),  .Cout(carry[8]));
    FullAdder FA9  (.A(A[9]),  .B(B[9]),  .Cin(carry[8]),   .Sum(Sum[9]),  .Cout(carry[9]));
    FullAdder FA10 (.A(A[10]), .B(B[10]), .Cin(carry[9]),   .Sum(Sum[10]), .Cout(carry[10]));
    FullAdder FA11 (.A(A[11]), .B(B[11]), .Cin(carry[10]),  .Sum(Sum[11]), .Cout(carry[11]));
    FullAdder FA12 (.A(A[12]), .B(B[12]), .Cin(carry[11]),  .Sum(Sum[12]), .Cout(carry[12]));
    FullAdder FA13 (.A(A[13]), .B(B[13]), .Cin(carry[12]),  .Sum(Sum[13]), .Cout(carry[13]));
    FullAdder FA14 (.A(A[14]), .B(B[14]), .Cin(carry[13]),  .Sum(Sum[14]), .Cout(carry[14]));
    FullAdder FA15 (.A(A[15]), .B(B[15]), .Cin(carry[14]),  .Sum(Sum[15]), .Cout(carry[15]));
    FullAdder FA16 (.A(A[16]), .B(B[16]), .Cin(carry[15]),  .Sum(Sum[16]), .Cout(carry[16]));
    FullAdder FA17 (.A(A[17]), .B(B[17]), .Cin(carry[16]),  .Sum(Sum[17]), .Cout(carry[17]));
    FullAdder FA18 (.A(A[18]), .B(B[18]), .Cin(carry[17]),  .Sum(Sum[18]), .Cout(carry[18]));
    FullAdder FA19 (.A(A[19]), .B(B[19]), .Cin(carry[18]),  .Sum(Sum[19]), .Cout(carry[19]));
    FullAdder FA20 (.A(A[20]), .B(B[20]), .Cin(carry[19]),  .Sum(Sum[20]), .Cout(carry[20]));
    FullAdder FA21 (.A(A[21]), .B(B[21]), .Cin(carry[20]),  .Sum(Sum[21]), .Cout(carry[21]));
    FullAdder FA22 (.A(A[22]), .B(B[22]), .Cin(carry[21]),  .Sum(Sum[22]), .Cout(carry[22]));
    FullAdder FA23 (.A(A[23]), .B(B[23]), .Cin(carry[22]),  .Sum(Sum[23]), .Cout(carry[23]));
    FullAdder FA24 (.A(A[24]), .B(B[24]), .Cin(carry[23]),  .Sum(Sum[24]), .Cout(carry[24]));
    FullAdder FA25 (.A(A[25]), .B(B[25]), .Cin(carry[24]),  .Sum(Sum[25]), .Cout(carry[25]));
    FullAdder FA26 (.A(A[26]), .B(B[26]), .Cin(carry[25]),  .Sum(Sum[26]), .Cout(carry[26]));
    FullAdder FA27 (.A(A[27]), .B(B[27]), .Cin(carry[26]),  .Sum(Sum[27]), .Cout(carry[27]));
    FullAdder FA28 (.A(A[28]), .B(B[28]), .Cin(carry[27]),  .Sum(Sum[28]), .Cout(carry[28]));
    FullAdder FA29 (.A(A[29]), .B(B[29]), .Cin(carry[28]),  .Sum(Sum[29]), .Cout(carry[29]));
    FullAdder FA30 (.A(A[30]), .B(B[30]), .Cin(carry[29]),  .Sum(Sum[30]), .Cout(carry[30]));
    FullAdder FA31 (.A(A[31]), .B(B[31]), .Cin(carry[30]),  .Sum(Sum[31]), .Cout(carry[31]));
endmodule
