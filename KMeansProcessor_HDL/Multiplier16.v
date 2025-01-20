module Multiplier16 (
    input [15:0] A,          // Multiplicand
    input [15:0] B,          // Multiplier
    output [31:0] Product    // 32-bit Product output
);
    wire [31:0] pp[15:0];    // Partial products (each row is 32-bits for shifted values)

    // Generate partial products by ANDing each bit of A with each bit of B
    assign pp[0]  = {16'b0, A} & {32{B[0]}};
    assign pp[1]  = {15'b0, A, 1'b0} & {32{B[1]}};
    assign pp[2]  = {14'b0, A, 2'b0} & {32{B[2]}};
    assign pp[3]  = {13'b0, A, 3'b0} & {32{B[3]}};
    assign pp[4]  = {12'b0, A, 4'b0} & {32{B[4]}};
    assign pp[5]  = {11'b0, A, 5'b0} & {32{B[5]}};
    assign pp[6]  = {10'b0, A, 6'b0} & {32{B[6]}};
    assign pp[7]  = {9'b0, A, 7'b0} & {32{B[7]}};
    assign pp[8]  = {8'b0, A, 8'b0} & {32{B[8]}};
    assign pp[9]  = {7'b0, A, 9'b0} & {32{B[9]}};
    assign pp[10] = {6'b0, A, 10'b0} & {32{B[10]}};
    assign pp[11] = {5'b0, A, 11'b0} & {32{B[11]}};
    assign pp[12] = {4'b0, A, 12'b0} & {32{B[12]}};
    assign pp[13] = {3'b0, A, 13'b0} & {32{B[13]}};
    assign pp[14] = {2'b0, A, 14'b0} & {32{B[14]}};
    assign pp[15] = {1'b0, A, 15'b0} & {32{B[15]}};

    // Tree structure to add partial products
    wire [31:0] sum_stage1[7:0];
    wire [31:0] sum_stage2[3:0];
    wire [31:0] sum_stage3[1:0];
    wire [31:0] final_sum;
    wire carry;

    // Stage 1: Add pairs of partial products
    Adder32 add1_0 (.A(pp[0]),  .B(pp[1]),  .Sum(sum_stage1[0]));
    Adder32 add1_1 (.A(pp[2]),  .B(pp[3]),  .Sum(sum_stage1[1]));
    Adder32 add1_2 (.A(pp[4]),  .B(pp[5]),  .Sum(sum_stage1[2]));
    Adder32 add1_3 (.A(pp[6]),  .B(pp[7]),  .Sum(sum_stage1[3]));
    Adder32 add1_4 (.A(pp[8]),  .B(pp[9]),  .Sum(sum_stage1[4]));
    Adder32 add1_5 (.A(pp[10]), .B(pp[11]), .Sum(sum_stage1[5]));
    Adder32 add1_6 (.A(pp[12]), .B(pp[13]), .Sum(sum_stage1[6]));
    Adder32 add1_7 (.A(pp[14]), .B(pp[15]), .Sum(sum_stage1[7]));

    // Stage 2: Add results from stage 1
    Adder32 add2_0 (.A(sum_stage1[0]), .B(sum_stage1[1]), .Sum(sum_stage2[0]));
    Adder32 add2_1 (.A(sum_stage1[2]), .B(sum_stage1[3]), .Sum(sum_stage2[1]));
    Adder32 add2_2 (.A(sum_stage1[4]), .B(sum_stage1[5]), .Sum(sum_stage2[2]));
    Adder32 add2_3 (.A(sum_stage1[6]), .B(sum_stage1[7]), .Sum(sum_stage2[3]));

    // Stage 3: Add results from stage 2
    Adder32 add3_0 (.A(sum_stage2[0]), .B(sum_stage2[1]), .Sum(sum_stage3[0]));
    Adder32 add3_1 (.A(sum_stage2[2]), .B(sum_stage2[3]), .Sum(sum_stage3[1]));

    // Final stage: Add results from stage 3 to produce the final product
    Adder32 add_final (.A(sum_stage3[0]), .B(sum_stage3[1]), .Sum(final_sum));

    // Assign final product
    assign Product = final_sum;
endmodule
