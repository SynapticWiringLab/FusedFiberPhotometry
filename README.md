# Fused Fiber Photometry

![Fused Fiber Photometry of Genetically Encoded Calcium Indicator in vivo](photometry_calcium_activity_405_470nm.png)

The code allows reproduction of the analysis of data presented in the manuscript "A flexible and versatile system for multi-color fiber photometry and optogenetic manipulation", Cell Method Reports, 2023, by Formozov, Dieter, and Wiegert. 

The corresponding data is deposited at https://gin.g-node.org/SW_lab/FusedFiberPhotometry

The path to the data have to be adjusted in the *data_location* script. 

Dependencies (including additional MATLAB toolboxes to be installed):
- *FFP_code* folder (added to the MATLAB path automatically) contains essential functions used in the scripts (*import_ppd*, *re_sample* and others).
- Curve Fitting Toolbox (*smooth*)
- Statistics and Machine Learning Toolbox (*lsline*, *ttest2*)  

The code was tested on MATLAB version 2022b.
