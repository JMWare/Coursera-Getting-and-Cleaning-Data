Coursera-Getting-and-Cleaning-Data
==================================
R script - run_analysis.R

The script contains two main functions which are commented to explain their operation:-

Function : DataMerge() Reads the label files and subsets the column headings to select 'mean' and 'std' columns.
The 'train' and 'test' files and the associated subject and activity files are then read and merged. The columns 
of measurements are subset and a data frame with Activity name, Subject ID and 79 columns of measurements is assembled.
The data set is ordered using Activit name as primary key and Subject ID as secondary key.
This data frame is saved as X_merged.txt

Function : run_analysis()
The file X_merged.txt created by DataMerge() is read. Using the ordering on subject ID allows the rows to be 
subset on the sets of observations on each activity. A data frame of 180 rows containing Activity name, 
subject ID and 79 columns of measurements is created and saved as the file Activity_means.txt
