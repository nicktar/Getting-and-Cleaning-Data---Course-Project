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
    feature_vector_labels <- read.table("UCI HAR Dataset/features.txt", col.names = c('id', 'label'))
    
    # Reducing the feature vector to only contain features ending in -mean() or -std(), which represent
    # the features for mean and standard deviation for each measurement
    selected_features <- subset(feature_vector_labels, grepl('-(std|mean)\\(\\)', feature_vector_labels$label))
    
    # Load activity labels vector
    activity_labels <- read.table('UCI HAR Dataset/activity_labels.txt', col.names = c('id', 'label'))
    
    # Read and process the datasets
    writeLines("Reading and processing training data")
    train_data <- process_dataset('train', features=selected_features, activities=activity_labels)
    
    writeLines("Reading and processing test data")
    test_data <- process_dataset('test', features=selected_features, activities=activity_labels)
    
    # create one merged dataset
    writeLines("Merging datasets")
    merged_data <-rbind(train_data, test_data)
    
    merged_data <- data.table(merged_data)
}

process_dataset <- function(dataset, features, activities) {
    
    # Load subject data
    subject_ids <- read.table(get_pathname(dataset, 'subject'))[,1]
    
    # Load the measurement dataset and keep only the selected features
    feature_vector <- read.table(get_pathname(dataset, 'X'))[,features$id]
    
    # Load the activity data
    activity_vector <- read.table(get_pathname(dataset, 'y'))[,1]

    # apply column names from the selected features
    names(feature_vector) <- features$label
    
    # add the activities from the activity data to the dataset
    feature_vector$activity <- factor(activity_vector, levels=activities$id, labels=activities$label)
    
    # add the subject data to the dataset
    feature_vector$subject <- factor(subject_ids)

    feature_vector    
}

get_pathname <- function(dataset, subset) {
    pathname <- paste(paste('UCI HAR Dataset', dataset, paste(subset, '_', dataset, '.txt', sep = ''), sep='/'))
}