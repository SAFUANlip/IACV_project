Copyright (C) 2024 Computer Vision Lab, Electrical Engineering, 
Indian Institute of Science, Bengaluru, India.
All rights reserved.

This file is a part of the implementation for the paper:
Lalit Manam and Venu Madhav Govindu, Leveraging Camera Triplets for Efficient and Accurate Structure-from-Motion, IEEE/CVF Conference on Computer Vision and Pattern Recognition, 2024.

Code tested on MATLAB R2023a.
parfor is used only for fast construction of triplet graph (dependency: Parallel Computing Toolbox). To avoid using parfor replace 'parfor' with 'for' in lines 84 and 140 in camtripsfm_demo.m.
