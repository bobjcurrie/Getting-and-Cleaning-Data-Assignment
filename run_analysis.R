# Getting and Cleaning Data Course Assignment
#
# Windows 7 environment

# Assume working directy is default
# Set working directory to "data", create if neccessary
if (!file.exists("data")) {
    dir.create("data")
}

setwd("./data")

# Load necessary libraries
library ("dplyr")

# Download project data
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl,, destfile = "dataset.zip", mode = "wb")

# Unzip all files from compressed file
unzip("dataset.zip")

# Set working directory to "UCI HAR Dataset"
setwd("UCI HAR Dataset")

# Read features list, activity labels, subject and test labels files into R
featureList <- read.table("features.txt", header = FALSE, col.names = c("featurenumber", "feature"))
activityLabels <- read.table("activity_labels.txt", header = FALSE, col.names = c("activitynumber", "activity"))
subjectTraining <- read.table("train/subject_train.txt", header = FALSE, col.names = "subject")
subjectTest <- read.table("test/subject_test.txt", header = FALSE, col.names = "subject")
trainingLabels <- read.table("train/y_train.txt", header = FALSE, col.names = "activitynumber")
testLabels <- read.table("test/y_test.txt", header = FALSE, col.names = "activitynumber")

# Transpose featureList rows to columns and convert to a character vector
# to be used as column names for training and test dataframes
#
# Drop 'featurenumber' from dataframe
featureList <- select(featureList, -featurenumber)
#
features <- as.vector((t(featureList)))

# Read training and test datasets into dataframe
training <- read.table("train/x_train.txt", header = FALSE, col.names = features)
test <- read.table("test/x_test.txt", header = FALSE, col.names = features)

# Add columns "subject" and 'activitynumber' to front of training, test dataframes using cbind function
training <- cbind(subjectTraining, trainingLabels, training)
test <- cbind(subjectTest, testLabels, test)

# 1. Merge training and test dataframes into one dataset, using rbind function
hardata <- rbind(training, test)

# 2. Extract only the data for mean and standard deviation for each measurement
#
# Select only variables that contain characters "mean" or "std" in their names 
hardata <- select(hardata, subject, activitynumber, contains("mean"), contains("std"))

# 3. Merge hardata with activityLAbels by the common variable (activitynumber) 
hardata <- merge(hardata, activityLabels)

# Sort hardata by subject then activitynumber. Drop the activitynumber column
hardata <- arrange(hardata, subject)
hardata <- select(hardata, subject, activity, everything(), -activitynumber)
#
# Convert 'activity' labels to lowercase
hardata$activity <- tolower(hardata$activity)
# Remove the underscore from 'activity'
hardata$activity <- sub("_","",hardata$activity)

# 4. Tidy variable names i.e. remove dots, underscores, commas, brackets; set to lowercase
names(hardata) <- gsub("_","", names(hardata))
names(hardata) <- gsub("\\.","", names(hardata))
names(hardata) <- gsub("\\,","", names(hardata))
names(hardata) <- gsub("\\(","", names(hardata))
names(hardata) <- gsub("\\)","", names(hardata))
names(hardata) <- tolower(names(hardata))
#
# Variable names 43:48 and 86:88 have the word "body" repeated e.g. fbodybodyaccjerkmagmean
# remove the extra 'body'
names(hardata) <- sub("bodybody", "body", names(hardata))

# 5. Create a dataset summarizing the means of each variable for each activity and subject
stepfive <- summarize_each(group_by(hardata, activity, subject), funs(mean))
#
# Write tidy dataset to file for upload
write.table(stepfive, file = "tidydatasetstep5.txt", row.names = FALSE)

