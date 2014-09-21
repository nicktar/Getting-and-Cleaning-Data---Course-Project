if (!require('data.table')) {
    writeLines("Need to install data.table package")
    install.packages("data.table")
    if (require('data.table')) {
        writeLines('data.table package installed')
    } else {
        stop('Could not install required package data.table.')
    }
}

run_analysis <- function()  {
    if (!file.exists("UCI HAR Dataset/test/X_test.txt") ||
            !file.exists("UCI HAR Dataset/test/y_test.txt") ||
            !file.exists("UCI HAR Dataset/train/X_train.txt") ||
            !file.exists("UCI HAR Dataset/train/y_train.txt")) {
        writeLines("Data not found.")
        if (!file.exists("dataset.zip")) {
            writeLines("Downloading")
            download.file(
                url='https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip', 
                destfile='dataset.zip')
        } else {
            writeLines("ZIP File found")
        }
        unzip('dataset.zip')
    }
    
    # Load feature vector
    featureVectorLabels <- read.table("UCI HAR Dataset/features.txt", col.names = c('id', 'label'))
    
    # Reducing the feature vector to only contain features ending in -mean() or -std(), which represent
    # the features for mean and standard deviation for each measurement
    selectedFeatures <- subset(featureVectorLabels, grepl('-(std|mean)\\(\\)', featureVectorLabels$label))
    
    # Load activity labels vector
    activityLabels <- read.table('UCI HAR Dataset/activity_labels.txt', col.names = c('id', 'label'))
    
    # Read and process the datasets
    writeLines("Reading and processing training data")
    trainingData <- process_dataset('train', features=selectedFeatures, activities=activityLabels)
    
    writeLines("Reading and processing test data")
    testData <- process_dataset('test', features=selectedFeatures, activities=activityLabels)
    
    # create one merged dataset
    writeLines("Merging datasets")
    mergedData <-rbind(trainingData, testData)
    
    mergedData <- data.table(mergedData)
    
    tidy_data <- create_tidy_data(mergedData)
    
    write.csv(mergedData, file = 'raw_data.csv', row.names = FALSE)
    write.csv(tidy_data, file = 'tidy_data.csv', row.names = FALSE)
    
    writeLines("Done. Raw data can be found in raw_data.csv, tidy data can be found in tidy_data.csv")
}

process_dataset <- function(dataset, features, activities) {
    
    # Load subject data
    subjectIds <- read.table(get_pathname(dataset, 'subject'))[,1]
    
    # Load the measurement dataset and keep only the selected features
    featureVector <- read.table(get_pathname(dataset, 'X'))[,features$id]
    
    # Load the activity data
    activityVector <- read.table(get_pathname(dataset, 'y'))[,1]

    # apply column names from the selected features
    names(featureVector) <- features$label
    
    # add the activities from the activity data to the dataset
    featureVector$activity <- factor(activityVector, levels=activities$id, labels=activities$label)
    
    # add the subject data to the dataset
    featureVector$subject <- factor(subjectIds)

    featureVector    
}

get_pathname <- function(dataset, subset) {
    pathname <- paste(paste('UCI HAR Dataset', dataset, paste(subset, '_', dataset, '.txt', sep = ''), sep='/'))
}

create_tidy_data <- function(rawData) {
    
    # calculate the average of each feature per activity and subject
    tidy <- rawData[, lapply(.SD, mean), by=list(activity, subject)]
    
    # clean column names
    names <- names(tidy)
    
    names <- gsub('std\\(\\)', 'Standard', names)
    names <- gsub('mean\\(\\)', 'Mean', names)
    names <- gsub('-', '', names)
    names <- gsub('BodyBody', 'Body', names)
    setnames(tidy, names)
    
    tidy
    
}