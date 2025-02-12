# IACV Project 2024-2025 - Politecnico di Milano

## Optimizing the Viewing Graph

### Project Overview
This project critically analyzes the approach presented in [Manam and Govindu, CVPR 2024](https://ee.iisc.ac.in/cvlab/research/camtripsfm/cam_triplets_sfm.pdf), comparing it to other Structure-from-Motion (SfM) methods to highlight its advantages and limitations.


### Our Trials
Given our limited computational setup (Intel Core i7-7700HQ CPU, 16 GB RAM, no GPU), generating a matched edge database was infeasible. We used pre-matched datasets from COLMAP and worked with smaller datasets (fewer than 400 images), making matching more manageable. Our analysis focused on small, generic datasets.

#### Results Overview
**Key Metrics:**
- **RT G**: Reconstruction time for the original viewgraph.
- **RT Gf**: Reconstruction time after applying Algorithm 1.
- **MRE G**: Mean Reconstruction Error (in pixels) of the original viewgraph.
- **MRE Gf**: Mean Reconstruction Error (in pixels) after applying Algorithm 1.
- **3D points G**: Number of 3D points reconstructed from the original viewgraph.
- **3D points Gf**: Number of 3D points reconstructed after applying Algorithm 1.
- **N images**: Number of images in the dataset (with minimum edge score = 0.7).

# Experiments

| **Data**                   | **RT G** | **RT Gf** | **MRE G** | **MRE Gf** | **#3D points G** | **#3D points Gf** | **#N images** |
|----------------------------|----------|-----------|-----------|------------|------------------|-------------------|---------------|
| South Building [COLMAP dataset](https://demuc.de/colmap/datasets/) | 3.25     | **2.53**  | 0.510     | **0.504**  | 61338            | 50222             | 128           |
| Person Hall [COLMAP dataset](https://demuc.de/colmap/datasets/) | 16.27    | **13.45** | 0.677     | **0.676**  | 141865           | 131369            | 330           |
| Gerrard Hall [COLMAP dataset](https://demuc.de/colmap/datasets/) | 3.25     | **3.22**  | **0.639** | **0.639**  | 42819            | 42515             | 100           |
| Water Tower [small datasets](https://www.maths.lth.se/matematiklth/personal/calle/dataset/dataset.html) | 18.20    | **17.37** | 0.4283    | **0.4279** | 98831            | 98470             | 173           |
| Alcatraz [small datasets](https://www.maths.lth.se/matematiklth/personal/calle/dataset/dataset.html) | 6.57     | **4.33**  | 0.4085    | **0.4077** | 77713            | 77305             | 132           |
| UWO [small datasets](https://www.maths.lth.se/matematiklth/personal/calle/dataset/dataset.html) | 1.40     | **1.24**  | 0.4210    | **0.4100** | 26625            | 24607             | 57            |
| Gustav_wolf [small datasets](https://www.maths.lth.se/matematiklth/personal/calle/dataset/dataset.html) | 2.08     | **1.57**  | 0.3589    | **0.3528** | 56850            | 50595             | 57            |
| Pumpkin [small datasets](https://www.maths.lth.se/matematiklth/personal/calle/dataset/dataset.html) | 11.14    | **10.18** | **0.6124**| 0.6129     | 101467           | 100208            | 209           |
| UrbanII [small datasets](https://www.maths.lth.se/matematiklth/personal/calle/dataset/dataset.html) | 5.06     | **3.29**  | 0.3910    | **0.3867** | 80408            | 78801             | 90            |
| Eglise [small datasets](https://www.maths.lth.se/matematiklth/personal/calle/dataset/dataset.html) | **4.35** | **4.35**  | 0.4264    | **0.4263** | 52702            | 50640             | 85            |
| LUsphinx [small datasets](https://www.maths.lth.se/matematiklth/personal/calle/dataset/dataset.html) | 1.51     | **1.42**  | 0.4619    | **0.4584** | 42999            | 41485             | 70            |
| Round_church [small datasets](https://www.maths.lth.se/matematiklth/personal/calle/dataset/dataset.html) | **3.18** | 3.21      | **0.5161**| 0.5169     | 44650            | 43968             | 92            |
| Porta san Donato [small datasets](https://www.maths.lth.se/matematiklth/personal/calle/dataset/dataset.html)| **9.33** | 9.34      | 0.4583    | **0.4570** | 81839            | 80839             | 141           |
| King's College, Toronto [small datasets](https://www.maths.lth.se/matematiklth/personal/calle/dataset/dataset.html) | 4.24  | **4.20**  | **0.4254**| 0.4254     | 53822            | 52202             | 77            |
| Sri_Thendayuthapani [small datasets](https://www.maths.lth.se/matematiklth/personal/calle/dataset/dataset.html) | 5.29  | **4.47**  | 0.5936    | **0.5862** | 46938            | 45051             | 98            |

Despite our setup constraints, we managed to replicate the core findings and found that the method is particularly effective for small datasets, reducing reconstruction times without sacrificing accuracy.

#### Key Observations:
- **Reconstruction Time (RT)**:  
  - For most datasets, the sparsified graph (Gf) reduces reconstruction time.  
  - Example: Alcatraz (RT of 6.57 → 4.33) and Person Hall (RT of 16.27 → 13.45).  
  - In some cases (e.g., Eglise and Gerrard Hall), sparsification had minimal impact on reconstruction time.

- **Mean Reconstruction Error (MRE)**:  
  - In many cases, MRE decreased or remained the same with the sparsified graph (Gf) compared to the original (G).  
  - Example: South Building (MRE G = 0.510 → 0.504) and Gustav Wolf (MRE G = 0.3589 → 0.3528).  
  - The sparsification process improved consistency in camera parameters and 3D points, leading to lower MRE in some datasets.

- **Number of 3D Points**:  
  - The number of 3D points remained relatively high in both the original and sparsified graphs.  
  - A slight decrease in 3D points was observed in some cases (e.g., South Building: 61338 → 50222).  
  - However, the remaining points often showed lower MRE, indicating more consistent reconstructions.

### Advantages of the Method
- **Single Hyperparameter**: Requires only one hyperparameter, simplifying optimization compared to methods requiring multiple parameters.
- **No Partial Reconstruction**: Unlike other methods, it does not rely on intermediate partial reconstruction, offering a more direct approach.
- **Adaptability**: The method can be integrated into various SfM pipelines, making it versatile.
- **No Specific Probability Distributions**: Unlike some methods, it does not require specific probability distributions for missing correspondences.

### Disadvantages
- **Optimization Needed**: Although only one hyperparameter is required, finding the optimal graph often requires fine-tuning within a specific range (e.g., m = [0.3 - 0.9]).
- **Potential Loss of Essential Information**: Relying solely on G_LCT scores may omit important edges, especially in small datasets, leading to a loss of critical information in some cases.

### Conclusions
Our experiments and results confirm that the algorithm from [Manam and Govindu, 2024](https://ee.iisc.ac.in/cvlab/research/camtripsfm/cam_triplets_sfm.pdf) 
is also effective for small datasets. Despite being designed for larger datasets, it successfully reduces reconstruction times without sacrificing accuracy. The method is versatile, applicable to datasets of all sizes and complexities, making it a promising tool for enhancing SfM efficiency and accuracy.

### Instructions for Running the Process
1. Install [COLMAP](https://colmap.github.io/index.html).
2. Download datasets from [COLMAP](https://demuc.de/colmap/datasets/), [Small Datasets](https://www.maths.lth.se/matematiklth/personal/calle/dataset/dataset.html).
3. For [Small Datasets](https://www.maths.lth.se/matematiklth/personal/calle/dataset/dataset.html) you have to match edged, for that use [vocabulary tree with 32K visual words](https://demuc.de/colmap/) as we work with small datasets. (Authors used in their experiments trees with 1M words).
4. Also for [Small Datasets](https://www.maths.lth.se/matematiklth/personal/calle/dataset/dataset.html) you have extract features, but for that you don't need anything, just use default setting and default feature extractor.
5. Open the COLMAP database file extracted from the feature extractor.
6. Use SQLite Browser to export the inlier matches table to a text file.
7. Apply the provided MATLAB [code](https://ee.iisc.ac.in/cvlab/research/camtripsfm/camtripsfm.zip) to generate an output.txt.
8. Use SQL queries in SQLite Browser to clean the data:
   ```sql
   DELETE FROM inlier_matches
   WHERE pair_id IN (SELECT * FROM output);
   ```

### Extra Comments (Very Important)

As you can notice, despite retaining the best edges (those with scores above the threshold), we ended up removing them and working only with the remaining edges. When we applied the default threshold value of **0.7** to keep only the best edges, we ended up with a too-sparsified graph, which made the full scene reconstruction impossible.

Recognizing this issue, we adjusted our approach by removing the best edges and working with the remaining ones. Later, we realized our mistake and decided to test with a lower threshold value to conduct more accurate experiments for few datasets from table.

As a result, reconstruction time improved significantly, with a 50-80% reduction, aligning closely with the performance reported in the authors' article. However, we obtained these results with a much lower threshold of **0.1**, which was not used in the authors' experiments.

In conclusion, while our mistake still led to improved reconstruction times, it highlighted the **challenge of selecting an optimal threshold value**, which can be considerably different from the default values.

To correct this, the following SQL code should be used:

   ```sql
   DELETE FROM inlier_matches
   WHERE pair_id NOT IN (SELECT * FROM output);
   ```

### Repository Structure

```
📂 IACV_project
│-- 📁 camtripsfm/                      # source code of authors from their website
│-- 📁 datasets/                        # datasets with txt file of source and thresholded edges 
│-- 📁 experiment_recordings/           # recordings of our experiments
│-- 📁 reconstruct_images/              # screeenshots of reconstructed scenes
│-- 📁 report/                          # our presentation and report 
│-- 📁 src/                             # python file to manage dataset if you don't have SQL editor
│-- 📁 vocab_trees/                     # vocab tree for matching 
│-- README.md                           # Project overview (this file)
```

### Reference
**Leveraging Camera Triplets for Efficient and Accurate Structure-from-Motion**  
* Lalit Manam, Venu Madhav Govindu  
In Proceedings of the IEEE/CVF Conference on Computer Vision and Pattern Recognition (CVPR), 2024.  
[PDF](https://ee.iisc.ac.in/cvlab/research/camtripsfm/cam_triplets_sfm.pdf) | [Project Page](https://ee.iisc.ac.in/cvlab/research/camtripsfm/)
* [Gdrive with all files from experiments](https://drive.google.com/drive/folders/1UMQcAAotJTJ2d3ogCpm_Fa7r8qrP2MOJ?usp=sharing)

## Contact Information
* Iusupov Safuan [Telegram](https://t.me/IusupovSafuan) | [GitHub](https://github.com/SAFUANlip) | safuan.iusupov@mail.polimi.it
