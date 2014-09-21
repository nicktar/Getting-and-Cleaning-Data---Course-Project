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
    
}