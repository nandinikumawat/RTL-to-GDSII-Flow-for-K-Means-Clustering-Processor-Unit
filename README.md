# K-Means Clustering Processor

## Project Overview
The **K-Means Clustering Processor** is a high-speed, low-power hardware implementation of the K-Means clustering algorithm. It is optimized for real-time classification tasks, such as data mining, machine learning, and image segmentation. The processor classifies a 4-dimensional input data point into one of three clusters based on Euclidean distance to predefined centroids. 

This project emphasizes precision, efficiency, and robust design methodologies to deliver an advanced hardware solution.

---

## Key Features
1. **Classification Accuracy**:
   - Supports 16-bit precision for data and centroids.
   - Reduces classification errors and enhances calculation robustness.

2. **Pipeline Design**:
   - Three-stage pipelined architecture ensures high throughput and low latency.

3. **Power Efficiency**:
   - Optimized arithmetic units reduce power consumption.
   - Power-aware design with hierarchical power distribution minimizes IR drop.

4. **Hardware Optimizations**:
   - Efficient subtraction and squaring modules.
   - Optimized multiplier design for partial product generation.

5. **Testing and Validation**:
   - Verified using the Iris dataset.
   - Cross-language validation in C++ and Python.
   - Comprehensive functional coverage.

---

## System Architecture
### Core Modules
1. **Input Interface**:
   - Inputs: A 4-dimensional data vector and three 4-dimensional centroid vectors.
   - Signals: Clock (clk) and reset (reset) for synchronization and initialization.

2. **Subtraction and Squaring Block**:
   - Computes squared differences between input data and centroids.
   - Outputs squared values for further processing.

3. **Adder Logic**:
   - Aggregates squared differences to compute total Euclidean distances.
   - Outputs distances for comparison.

4. **LTA (Loser Take All) Unit**:
   - Compares distances to identify the smallest (closest) distance.
   - Outputs the cluster address of the nearest centroid.

5. **Registers and Clock Tree**:
   - Ensures synchronized and sequential operation.

6. **Power Distribution**:
   - Uses hierarchical power mesh with virtual pads to ensure minimal IR drop.
  
<div align="center">
  <img src="https://github.com/user-attachments/assets/73db44d3-1345-4b7b-9081-c10fe2f31b53" alt="image description">
</div>

### Data Flow
1. Input data and centroids are fed into the **Subtraction and Squaring Block**.
2. The **Adder Logic** aggregates squared differences to calculate distances.
3. The **LTA Unit** identifies the closest centroid and outputs the cluster address.

---

## Design Details
### Design Specifications
- **Technology Node**: TSMC 16 nm FinFET
- **Clock Frequency**: 800 MHz
- **Pipeline Stages**:
  - Stage 1: Squared difference computation.
  - Stage 2: Distance summation.
  - Stage 3: Cluster determination.
- **Post-Synthesis Metrics**:
  - Total Cell Area: 5,364.09 µm²
  - Dynamic Power Consumption: 9.7 mW
  - Fault Coverage: 97.17%
 
<div align="center">
  <img src="https://github.com/user-attachments/assets/707501b4-67cd-49a0-bad1-4f408429b606" alt="Second image description">
</div>


Post-Route Metrics

Total Area: 5,234.70 µm² (Combinational) + 129.39 µm² (Noncombinational)

Power Metrics:

Internal Power: 4.36 mW

Switching Power: 4.46 mW

Leakage Power: 0.034 mW

Total Power: 8.85 mW

Timing Metrics:

Hold Timing Slack: 0.09 ns

Setup Timing Met

Clock Frequency: 1.25 GHz

### Port Descriptions
| Port Name      | Bit-Width | Direction | Description                            |
|----------------|-----------|-----------|----------------------------------------|
| clk            | 1         | Input     | Clock signal for synchronization       |
| reset          | 1         | Input     | Reset signal for initialization        |
| data_in[3:0]   | 16 each   | Input     | 4-dimensional input data vector        |
| centroid1[3:0] | 16 each   | Input     | Centroid 1 vector                      |
| centroid2[3:0] | 16 each   | Input     | Centroid 2 vector                      |
| centroid3[3:0] | 16 each   | Input     | Centroid 3 vector                      |
| cluster_addr   | 2         | Output    | Address of the closest cluster         |
| dist_sum[2:0]  | 32 each   | Output    | Distances to the three centroids       |

---

## Verification and Validation
1. **Functional Testing**:
   - Tested with 150 scaled Iris dataset points.
   - Verified edge cases such as overlapping centroids and extreme input values.

2. **Cross-Language Validation**:
   - Implemented reference models in C++ and Python.
   - Compared results from Verilog simulations to software outputs.

3. **Visualization**:
   - Plotted cluster assignments using Matplotlib for visual validation.

4. **Testbench**:
   - Input: Scaled Iris dataset values.
   - Output: Cluster assignments and distances.

---

## Layout and Routing
1. **Floorplanning**:
   - Die Size: 102 × 102 µm²
   - Core Utilization: 80%
   - Congestion: Reduced to <5%
  
<div align="center">
  <img src="https://github.com/user-attachments/assets/741182c8-42eb-4117-923d-2f3e917ff948" alt="First image description" style="margin-bottom: 20px;">
  <br>
  <img src="https://github.com/user-attachments/assets/6bf17018-58ef-4e12-a6bd-76f3f55a4063" alt="Second image description">
</div>



2. **Routing**:
   - M2-M10 layers optimized for signal integrity.
   - Clock tree designed for minimal skew.
   - 
<div align="center">
  <img src="https://github.com/user-attachments/assets/868a37d6-3d10-4262-ad1b-57adc434f99b" alt="First image description" style="margin-bottom: 20px;">
  <br>
  <img src="https://github.com/user-attachments/assets/9da56091-34a9-4600-8530-8519ffa6453c" alt="Second image description" style="margin-bottom: 20px;">
  <br>
  <img src="https://github.com/user-attachments/assets/0397c0f0-3e7e-4e06-98cf-0642057ba31e" alt="Third image description" style="margin-bottom: 20px;">
  <br>
  <img src="https://github.com/user-attachments/assets/a0262741-b3a6-483d-9fd0-1589c834491c" alt="Fourth image description">
</div>



3. **Key Metrics**:
   - Hold Timing Slack: 0.09 ns
   - Dynamic Power: 9.7 mW

---

## Future Improvements
1. Address remaining congestion issues for better scalability.
2. Optimize routing for further congestion reduction.
3. Incorporate adaptive clustering techniques for dynamic centroids.

---

## Tools and Technologies Used
- **Hardware Design**: Verilog HDL
- **EDA Tools**: Synopsys ICC2, Verdi, and HSPICE
- **Programming for Validation**: Python (Matplotlib), C++
- **Dataset**: Iris Dataset

---

## References
1. [Energy Efficient Distance Computing: Application to K-Means Clustering](https://archive.ics.uci.edu/ml/datasets/iris)
2. Synopsys ICC2 Documentation
3. Iris Dataset from UCI Machine Learning Repository

---

For further queries or collaboration, contact **Nandini Kumawat** at kumaw010@umn.edu.

