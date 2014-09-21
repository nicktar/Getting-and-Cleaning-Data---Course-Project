# Coursera Course Getting and Cleaning Data. Course Project Codebook


## Source Data

The source data was collected using the smartphone accelerometer and gyroscope 3-axial signals. 
The raw data was preprocessed to a vector containing 561 features as well as vectors containing the 
activities and test subject ids.
The zipped source data contains a `features_info.txt` file with additional metadata.

- [source](https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip) 
- [description](http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones)

## Data sets

### Raw data

The raw dataset contains 68 features. 66 of those were filtered from the source data using a regular expression on the 
features from the `features.txt` file contained in the source data. The expression 

`-(std|mean)\\(\\)`

redurced the feature list to those 66 containing one of the string `-std()` or `-mean()` in their labels. These are the features
that contain the standard deviation and mean measurements in the source data.

The other 2 columns contain the activity identifiers `activity` and subject ids `subject`.

The merged data contains 7314 rows from the raining dataset and 2909 rows from the test dataset.

### Tidy data

The tidy data cntains the mean values from the raw dataset calculated per subject and activity.

The labels were modified as follows:

 1. Replaced `std()` with `Standard`
 2. Replaced `mean()` with `Mean`
 3. Dashes are removed 
 4. Replaced `BodyBody` with `Body`
 

## Examples of labels in raw data and matching names from the tidy dataset

 |Raw data labels         | Tidy data labels       |
 |------------------------|------------------------|
 |´activity´              | ´activity´             |
 |´subject´               | ´subject´              |
 |´tBodyAcc-mean()-X´     | ´tBodyAccMeanX´        |
 |´tBodyAcc-mean()-Y´     | ´tBodyAccMeanY´        |
 |´tBodyAcc-mean()-Z´     | ´tBodyAccMeanZ´        |
 |´tBodyAcc-std()-X´      | ´tBodyAccStandardX´    |
 |´tBodyAcc-std()-Y´      | ´tBodyAccStandardY´    |
 |´tBodyAcc-std()-Z´      | ´tBodyAccStandardZ´    |
 |´tGravityAcc-mean()-X´  | ´tGravityAccMeanX´     |
 |´tGravityAcc-mean()-Y´  | ´tGravityAccMeanY´     |
 |´tGravityAcc-mean()-Z´  | ´tGravityAccMeanZ´     |
 |´tGravityAcc-std()-X´   | ´tGravityAccStandardX´ |
 |´tGravityAcc-std()-Y´   | ´tGravityAccStandardY´ |
 |´tGravityAcc-std()-Z´   | ´tGravityAccStandardZ´ |
 |´tBodyAccJerk-mean()-X´ | ´tBodyAccJerkMeanX´    |

