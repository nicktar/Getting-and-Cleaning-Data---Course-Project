Getting and Cleaning Data - Course Project
==========================================

Course Project for the Getting and Cleaning Data course @ Coursera

### run_analysis.R

When the script is sourced, it checks if the required packages are installed and tries to install them if no installation can be found.
It then displays instructions on how to run the script

```r
source('./run_analysis.R')
run_analysis()
```

The script checks if there is a directory called `UCI HAR Dataset` in the working directory. If it finds one, this directory is assumed to contain the unzipped files from the Samsung data. It the directory is not found, the script checks for a file called `dataset.zip` that is assumed to contain the Samsung data and will be unzipped and used. It this file os not found, the scripts downloads the data.

## Processing steps

1. When sourced, the scripts checks for the needed packages and tries to install missing ones
2. Calling run_analysis() starts the processing
    1. The script checks if all the needed data is present
        1. The Script checks for several key files in the `UCI HAR Dataset` subdirectory
        2. If they are not found, the script checks for a file called `dataset.zip` in the working directory
        3. If this file is not there, it will be downloaded
   2. The actual processing starts for training and test data
        1. The feature labes are loaded from `features.txt`
        2. The features containing std or mean values are selected using `grepl`
        3. The activity labels are loadad from `activity_labels.txt`
        4. The data is loaded
        5. The feature vector is filtered using the selected features
        6. The feature vector is labeled according to the selected features
        7. Activity and subject data is added to the feature vector
    3. The processed training and test datasets are merged using `rbind` and converted to a data.table
    4. The mean is calculated for each feature per activity and subject
    5. The column names are cleaned and reapplied to the tidy dataset
    6. Both raw and tidy datasets are written to disc,
   
