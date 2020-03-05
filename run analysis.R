setwd("~/R/getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset")
library(dplyr)
library(reshape2)

## Load Features and Activities info
features <- read.table("./features.txt")
activities <- read.table("./activity_labels.txt")

## Load training data
training <- read.table("./train/X_train.txt") # Training set
colnames(training) <- features$V2
Training_lables <- read.table("./train/y_train.txt") # Training labels (5 types of activities)
training$labels <- Training_lables$V1 # Add labels column
training_subject <- read.table("./train/subject_train.txt") # Training subjects (1-30)
training$subject <- training_subject$V1 # Add subject column

## Load test data
test <- read.table("./test/X_test.txt") # Test set
colnames(test) <- features$V2
test_labels <- read.table("./test/y_test.txt") # Test labels
test$labels <- test_labels$V1 # Add labels column
test_subject <- read.table("./test/subject_test.txt") # Test subject
test$subject <- test_subject$V1 # Add subject column

## Merge datasets
all_data <- rbind(training, test) # Merger rows of the two datasets

## Filter features
col_names <- colnames(all_data) # Extract names of targeted columns 
filtered_column_names <- grep(".mean\\(\\)|.std\\(\\)|labels|subject", col_names, value = TRUE)

## Filter the merged dataset
filtered_dataset <- all_data[, filtered_column_names]

## Add descriptive activity names
activity_names <- activities$V2
filtered_dataset$activity_name <- factor(filtered_dataset$labels, labels = activity_names)


## Get a tidy dataset
targeted_features <- grep(".mean\\(\\)|.std\\(\\)", col_names, value = TRUE) # extract all -std and -mean measurements
melted_dataset <- melt(filtered_dataset, id.vars = c("activity_name", "subject"), measure.vars = targeted_features)
tidy_dataset <- dcast(melted_dataset, activity_name + subject ~ variable, mean)

write.table(tidy_dataset, "./tidy_dataset")
