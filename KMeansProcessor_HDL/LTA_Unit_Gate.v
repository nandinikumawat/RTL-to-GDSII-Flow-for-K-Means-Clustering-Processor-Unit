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
