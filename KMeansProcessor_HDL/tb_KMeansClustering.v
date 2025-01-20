`timescale 1ns/1ps 

module tb_KMeansClustering;

    // Testbench signals
    reg clk, reset;
    reg [15:0] data_in1, data_in2, data_in3, data_in4;    // 4-D input data point
    reg [15:0] centroid1_1, centroid1_2, centroid1_3, centroid1_4; // Centroid 1
    reg [15:0] centroid2_1, centroid2_2, centroid2_3, centroid2_4; // Centroid 2
    reg [15:0] centroid3_1, centroid3_2, centroid3_3, centroid3_4; // Centroid 3
    wire [1:0] cluster_addr;  // Output cluster address

    // Internal wires to observe the intermediate distance calculations
    wire [31:0] dist_sum1, dist_sum2, dist_sum3;

    // Instantiate the KMeansClustering module
    KMeansClustering uut (
        .clk(clk), .reset(reset),
        .data_in1(data_in1), .data_in2(data_in2), .data_in3(data_in3), .data_in4(data_in4),
        .centroid1_1(centroid1_1), .centroid1_2(centroid1_2), .centroid1_3(centroid1_3), .centroid1_4(centroid1_4),
        .centroid2_1(centroid2_1), .centroid2_2(centroid2_2), .centroid2_3(centroid2_3), .centroid2_4(centroid2_4),
        .centroid3_1(centroid3_1), .centroid3_2(centroid3_2), .centroid3_3(centroid3_3), .centroid3_4(centroid3_4),
        .cluster_addr(cluster_addr),
        .dist_sum1(dist_sum1), // Access to intermediate distance calculations
        .dist_sum2(dist_sum2),
        .dist_sum3(dist_sum3)
    );

    // Clock generation
    always #5 clk = ~clk;

    // Test data array and loop variable declaration
    reg [63:0] test_data [0:49]; // Array to hold test data points (4 x 16-bit = 64-bit)
    integer i; // Loop counter

    // Testbench procedure
    initial begin
        // Initialize clock and reset
        clk = 0;
        reset = 1;
        #10 reset = 0;

        // Define diverse centroids

	// Centroids (already scaled)
	// New centroids for improved clustering results
	centroid1_1 = 16'd4000; centroid1_2 = 16'd3000; centroid1_3 = 16'd1000; centroid1_4 = 16'd500;
	centroid2_1 = 16'd6000; centroid2_2 = 16'd3200; centroid2_3 = 16'd5000; centroid2_4 = 16'd2000;
	centroid3_1 = 16'd8000; centroid3_2 = 16'd4000; centroid3_3 = 16'd6000; centroid3_4 = 16'd3000;


	// Further scaled test data points (100x original values)
	test_data[0]  = {16'd5100, 16'd3500, 16'd1400, 16'd200};
	test_data[1]  = {16'd4900, 16'd3000, 16'd1400, 16'd200};
	test_data[2]  = {16'd4700, 16'd3200, 16'd1300, 16'd200};
	test_data[3]  = {16'd4600, 16'd3100, 16'd1500, 16'd200};
	test_data[4]  = {16'd5000, 16'd3600, 16'd1400, 16'd200};
	test_data[5]  = {16'd5400, 16'd3900, 16'd1700, 16'd400};
	test_data[6]  = {16'd4600, 16'd3400, 16'd1400, 16'd300};
	test_data[7]  = {16'd5000, 16'd3400, 16'd1500, 16'd200};
	test_data[8]  = {16'd4400, 16'd2900, 16'd1400, 16'd200};
	test_data[9]  = {16'd4900, 16'd3100, 16'd1500, 16'd100};
	test_data[10] = {16'd5400, 16'd3700, 16'd1500, 16'd200};
	test_data[11] = {16'd4800, 16'd3400, 16'd1600, 16'd200};
	test_data[12] = {16'd4800, 16'd3000, 16'd1400, 16'd100};
	test_data[13] = {16'd4300, 16'd3000, 16'd1100, 16'd100};
	test_data[14] = {16'd5800, 16'd4000, 16'd1200, 16'd200};
	test_data[15] = {16'd5700, 16'd4400, 16'd1500, 16'd400};
	test_data[16] = {16'd5400, 16'd3900, 16'd1300, 16'd400};
	test_data[17] = {16'd5100, 16'd3500, 16'd1400, 16'd300};
	test_data[18] = {16'd5700, 16'd3800, 16'd1700, 16'd300};
	test_data[19] = {16'd5000, 16'd3400, 16'd1500, 16'd200};

	// Iris-versicolor data points
	test_data[20] = {16'd7000, 16'd3200, 16'd4700, 16'd1400};  
	test_data[21] = {16'd6400, 16'd3200, 16'd4500, 16'd1500};
	test_data[22] = {16'd6900, 16'd3100, 16'd4900, 16'd1500};
	test_data[23] = {16'd5500, 16'd2300, 16'd4000, 16'd1300};
	test_data[24] = {16'd6500, 16'd2800, 16'd4600, 16'd1500};
	test_data[25] = {16'd5700, 16'd2800, 16'd4500, 16'd1300};
	test_data[26] = {16'd6300, 16'd3300, 16'd4700, 16'd1600};
	test_data[27] = {16'd4900, 16'd2400, 16'd3300, 16'd1000};
	test_data[28] = {16'd6600, 16'd2900, 16'd4600, 16'd1300};
	test_data[29] = {16'd5200, 16'd2700, 16'd3900, 16'd1400};
	test_data[30] = {16'd5000, 16'd2000, 16'd3500, 16'd1000};
	test_data[31] = {16'd5900, 16'd3000, 16'd4200, 16'd1500};
	test_data[32] = {16'd6000, 16'd2200, 16'd4000, 16'd1000};
	test_data[33] = {16'd6100, 16'd2900, 16'd4700, 16'd1400};
	test_data[34] = {16'd5600, 16'd2900, 16'd3600, 16'd1300};
	test_data[35] = {16'd6700, 16'd3100, 16'd4400, 16'd1400};
	test_data[36] = {16'd5600, 16'd3000, 16'd4500, 16'd1500};
	test_data[37] = {16'd5800, 16'd2700, 16'd4100, 16'd1000};
	test_data[38] = {16'd6200, 16'd2200, 16'd4500, 16'd1500};
	test_data[39] = {16'd5600, 16'd2500, 16'd3900, 16'd1100};

	// Iris-virginica data points
	test_data[40] = {16'd6300, 16'd3300, 16'd6000, 16'd2500};  
	test_data[41] = {16'd5800, 16'd2700, 16'd5100, 16'd1900};
	test_data[42] = {16'd7100, 16'd3000, 16'd5900, 16'd2100};
	test_data[43] = {16'd6300, 16'd2900, 16'd5600, 16'd1800};
	test_data[44] = {16'd6500, 16'd3000, 16'd5800, 16'd2200};
	test_data[45] = {16'd7600, 16'd3000, 16'd6600, 16'd2100};
	test_data[46] = {16'd4900, 16'd2500, 16'd4500, 16'd1700};
	test_data[47] = {16'd7300, 16'd2900, 16'd6300, 16'd1800};
	test_data[48] = {16'd6700, 16'd2500, 16'd5800, 16'd1800};
	test_data[49] = {16'd7200, 16'd3600, 16'd6100, 16'd2500};


     // Apply test data in sequence
    for (i = 0; i < 50; i = i + 1) begin
        {data_in1, data_in2, data_in3, data_in4} = test_data[i]; // Assign test data to inputs
        #10; // Wait for a few cycles to observe the output
        $display("Test Case %0d: dist_sum1=%d, dist_sum2=%d, dist_sum3=%d, Cluster Address = %b", 
                 i+1, dist_sum1, dist_sum2, dist_sum3, cluster_addr);
        // Run through each test case

	end

        $finish;
    end
endmodule

   
