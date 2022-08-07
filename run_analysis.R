### Course Project
library(dplyr)
setwd("C:/Users/Maxi/Desktop/Coursera/Git_Github/GettingAndCleaningDataProject")


## Download and save data
if (!file.exists("UCI_dataset.zip")){
  file_url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
  download.file(file_url, "UCI_dataset.zip")
}
if (!file.exists("UCI HAR Dataset")) { 
  unzip("UCI_dataset.zip") 
}
setwd("C:/Users/Maxi/Desktop/Coursera/Git_Github/GettingAndCleaningDataProject/UCI HAR Dataset")


## Load data into R
features <- read.table("features.txt")[,2]
X_train <- read.table("train/X_train.txt")
y_train <- read.table("train/y_train.txt")
X_test <- read.table("test/X_test.txt")
y_test <- read.table("test/y_test.txt")

subject_train <- read.table("train/subject_train.txt")
subject_test <- read.table("test/subject_test.txt")
activities <- read.table("activity_labels.txt")


## Merge training and test sets to create one dataset
labels <- rbind(y_train, y_test)
observ <- rbind(X_train, X_test)

subject_data <- rbind(subject_train, subject_test)
df <- cbind(subject_data, labels, observ)
names(df) <- c("Subject", "Label", features)
  

## Extract only the measurements on the mean and standard deviation for each measurement
mean_std <- grep("mean|std", features, value=TRUE)
tidy_df <- select(df, 1:2, mean_std)


## Use descriptive activity names to name the activities in the data set
tidy_df <- mutate(tidy_df, Activity = activities[tidy_df$Label,2], .after=Label)


## Appropriately label the data set with descriptive variable names
names(tidy_df) <- gsub("Acc", "Accelerometer", names(tidy_df)) 
names(tidy_df) <- gsub("Gyro", "Gyroscope", names(tidy_df))
names(tidy_df) <- gsub("Mag", "Magnitude", names(tidy_df)) 
names(tidy_df) <- gsub("Acc", "Accelerometer", names(tidy_df)) 
names(tidy_df) <- gsub("^t", "time", names(tidy_df)) 
names(tidy_df) <- gsub("^f", "frequency", names(tidy_df))
names(tidy_df) <- gsub("[()]", "", names(tidy_df)) 


## Create a second, independent tidy data set with the average of each variable for each activity and each subject
summary_df <- tidy_df %>% 
  group_by(Activity, Subject) %>% 
  summarize_all(mean)

## Save the cleaned data
setwd("C:/Users/Maxi/Desktop/Coursera/Git_Github/GettingAndCleaningDataProject")
write.table(tidy_df, "tidy.txt", row.names=FALSE)
write.table(summary_df, "summary.txt", row.names=FALSE)



