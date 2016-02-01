# Getting-and-Cleaning-Data-Assignment

Windows 7 environment

Assume working directy is default, we want to set working directory to "data", creating it if necessary

For this project, we need to load the dplyr library (assume package is already installed)

We download the zipped data file using the download.file function. and a variable fileUrl containing a string pointing to the download URL. Note that for a Windows environment we need to remove the "s" in "https://" and we need to use mode = "wb" (binary)
We can unzip the file suing the unzip function

Because the unzip file creates another directory and subdirectories, we need to set the working directory to "UCI HAR Dataset"

We need to read the features list (features.txt), activity labels (activity_labels.txt), subject and training labels files into R. We read the files into the follwoing dataframes respectively:
featureList
activityLabels
subjectTraining
subjectTest
trainingLabels
testLabels

We use the featureList d.f. as a means to add column names to the training and test datasets. We do this by transposing the featureList rows to columns and then saving the column to a character vector

We read the training ("train/x_train.txt") and test ("test/x_test.txt") files into the dataframes training and test, respectively
(using col.names = features, where features is the vector we calculted from featureList 

We merge the subject and activity columns to the training/test dataframes using the cbind function

To complete step 1,  we merge training and test dataframes into one dataset, using the rbind function. This d.f. is called "hardata"

To complete step 2, we select only the variables containg the characters "mean" or "std", using the select function 

To add the activity labels column to our dataframe, we merge hardata with activityLabels, by the common activity variable 

At this point, we can convert the text in the activity variables to lowercase using tolower function

To complete step 4, we tidy variable names by removing dots, underscores, commas, brackets; we also set all text to lowercase

Some variable names contain "BodyBody". We can use the sub function to replace this with "Body"

To complete step 5, we use the group_by and summarize_each fumctions to calculate the means for each variable by activity and subject and assign it to a dataframe. We use write.table function to save this dataframe to a file for upload.
