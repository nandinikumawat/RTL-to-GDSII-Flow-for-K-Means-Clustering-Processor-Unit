`timescale 1ns/1ps

// Main KMeansClustering Module (4 Dimensions)
module KMeansClustering (
    input clk, reset, test_se, test_si,
    input [15:0] data_in1, data_in2, data_in3, data_in4,
    input [15:0] centroid1_1, centroid1_2, centroid1_3, centroid1_4,
    input [15:0] centroid2_1, centroid2_2, centroid2_3, centroid2_4,
    input [15:0] centroid3_1, centroid3_2, centroid3_3, centroid3_4,
    output test_so,	
    output wire [1:0] cluster_addr,
    output reg [31:0] dist_sum1, dist_sum2, dist_sum3
);

    // Intermediate signals for summed squared distances
    wire [31:0] dist_sum1_internal, dist_sum2_internal, dist_sum3_internal;

    // Subtraction and Squaring for each dimension of centroid 1
    wire [31:0] square1_1, square1_2, square1_3, square1_4;
    SubtractionAndSquare sas1_1 (.A(data_in1), .B(centroid1_1), .square(square1_1));
    SubtractionAndSquare sas1_2 (.A(data_in2), .B(centroid1_2), .square(square1_2));
    SubtractionAndSquare sas1_3 (.A(data_in3), .B(centroid1_3), .square(square1_3));
    SubtractionAndSquare sas1_4 (.A(data_in4), .B(centroid1_4), .square(square1_4));

    // Summation for centroid 1
    wire [31:0] sum1_12, sum1_34;
    Adder32 sum1_1 (.A(square1_1), .B(square1_2), .Sum(sum1_12));
    Adder32 sum1_2 (.A(square1_3), .B(square1_4), .Sum(sum1_34));
    Adder32 sum1_3 (.A(sum1_12), .B(sum1_34), .Sum(dist_sum1_internal));

    // Subtraction and Squaring for each dimension of centroid 2
    wire [31:0] square2_1, square2_2, square2_3, square2_4;
    SubtractionAndSquare sas2_1 (.A(data_in1), .B(centroid2_1), .square(square2_1));
    SubtractionAndSquare sas2_2 (.A(data_in2), .B(centroid2_2), .square(square2_2));
    SubtractionAndSquare sas2_3 (.A(data_in3), .B(centroid2_3), .square(square2_3));
    SubtractionAndSquare sas2_4 (.A(data_in4), .B(centroid2_4), .square(square2_4));

    // Summation for centroid 2
    wire [31:0] sum2_12, sum2_34;
    Adder32 sum2_1 (.A(square2_1), .B(square2_2), .Sum(sum2_12));
    Adder32 sum2_2 (.A(square2_3), .B(square2_4), .Sum(sum2_34));
    Adder32 sum2_3 (.A(sum2_12), .B(sum2_34), .Sum(dist_sum2_internal));

    // Subtraction and Squaring for each dimension of centroid 3
    wire [31:0] square3_1, square3_2, square3_3, square3_4;
    SubtractionAndSquare sas3_1 (.A(data_in1), .B(centroid3_1), .square(square3_1));
    SubtractionAndSquare sas3_2 (.A(data_in2), .B(centroid3_2), .square(square3_2));
    SubtractionAndSquare sas3_3 (.A(data_in3), .B(centroid3_3), .square(square3_3));
    SubtractionAndSquare sas3_4 (.A(data_in4), .B(centroid3_4), .square(square3_4));

    // Summation for centroid 3
    wire [31:0] sum3_12, sum3_34;
    Adder32 sum3_1 (.A(square3_1), .B(square3_2), .Sum(sum3_12));
    Adder32 sum3_2 (.A(square3_3), .B(square3_4), .Sum(sum3_34));
    Adder32 sum3_3 (.A(sum3_12), .B(sum3_34), .Sum(dist_sum3_internal));

    // Assign the intermediate distances to module outputs
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            dist_sum1 <= 0;
            dist_sum2 <= 0;
            dist_sum3 <= 0;
        end else begin
            dist_sum1 <= dist_sum1_internal;
            dist_sum2 <= dist_sum2_internal;
            dist_sum3 <= dist_sum3_internal;
        end
    end

    // LTA Unit to determine the cluster with the minimum distance
    LTA_Unit_Gate lta (
        .dist1(dist_sum1_internal),
        .dist2(dist_sum2_internal),
        .dist3(dist_sum3_internal),
        .cluster_addr(cluster_addr)
    );
endmodule

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

module LTA_Unit_Gate (
    input [31:0] dist1, dist2, dist3,
    output [1:0] cluster_addr
);
    wire comp1_2, comp1_3, comp2_3;
    wire [1:0] mux_out1, mux_out2;

    // Comparators to determine which distance is smaller
    Comparator comp1 (.A(dist1), .B(dist2), .comp_out(comp1_2));
    Comparator comp2 (.A(dist1), .B(dist3), .comp_out(comp1_3));
    Comparator comp3 (.A(dist2), .B(dist3), .comp_out(comp2_3));

    // Mux chain to select the "loser" address based on the comparator outputs
    // Address values: 2'b00 = dist1, 2'b01 = dist2, 2'b10 = dist3

    // First level of multiplexers
    Mux2to1 #(2) mux1 (
        .in0(2'b00),          // Address for dist1
        .in1(2'b01),          // Address for dist2
        .sel(comp1_2),        // Select based on dist1 vs. dist2
        .out(mux_out1)
    );

    Mux2to1 #(2) mux2 (
        .in0(2'b00),          // Address for dist1
        .in1(2'b10),          // Address for dist3
        .sel(comp1_3),        // Select based on dist1 vs. dist3
        .out(mux_out2)
    );

    // Final level of multiplexer to determine the minimum distance
    Mux2to1 #(2) mux_final (
        .in0(mux_out1),       // Result of dist1 vs. dist2
        .in1(2'b10),          // Address for dist3
        .sel(comp2_3),        // Select based on dist2 vs. dist3
        .out(cluster_addr)
    );

endmodule

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

module FullSubtractor (
    input A, B, Bin,
    output D, Bout
);
    assign D = A ^ B ^ Bin;
    assign Bout = (~A & B) | (Bin & ~A) | (Bin & B);
endmodule

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

module Comparator (
    input [31:0] A, B,
    output comp_out
);
    assign comp_out = (A > B);  // 1 if A > B, 0 otherwise
endmodule

module FullAdder (
    input A, B, Cin,
    output Sum, Cout
);
    assign Sum = A ^ B ^ Cin;
    assign Cout = (A & B) | (Cin & (A ^ B));
endmodule

module Mux2to1 #(parameter WIDTH = 32) (
    input [WIDTH-1:0] in0, in1,
    input sel,
    output [WIDTH-1:0] out
);
    assign out = sel ? in1 : in0;
endmodule


