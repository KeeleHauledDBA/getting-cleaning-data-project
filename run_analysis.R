#################################################################################################
#One of the most exciting areas in all of data science right now is wearable computing - see for example this article . Companies like Fitbit, Nike, and Jawbone Up are racing to develop the most advanced algorithms to attract new users. The data linked to from the course website represent data collected from the accelerometers from the Samsung Galaxy S smartphone. A full description is available at the site where the data was obtained:
#
#http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones
#
#Here are the data for the project:
#  
#  https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip
#
#You should create one R script called run_analysis.R that does the following.
#
#Merges the training and the test sets to create one data set.
#Extracts only the measurements on the mean and standard deviation for each measurement.
#Uses descriptive activity names to name the activities in the data set
#Appropriately labels the data set with descriptive variable names.
#From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

##Libraries
library(reshape2)
library(dplyr)

## 1. Get the data
filename <- "data/FUCIHAR_dataset.zip"
if (!file.exists(filename)){
  fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip "
  download.file(fileURL, filename, method="auto")
}  
##Unzip said data
unzip(filename) 

##Merges the training and the test sets to create one data set.

##Getting our pertinent data sorted out: 
# Trainings tables:
x_train <- read.table("./data/UCI HAR Dataset/train/X_train.txt")
y_train <- read.table("./data/UCI HAR Dataset/train/y_train.txt")
subject_train <- read.table("./data/UCI HAR Dataset/train/subject_train.txt")

# Testing tables:
x_test <- read.table("./data/UCI HAR Dataset/test/X_test.txt")
y_test <- read.table("./data/UCI HAR Dataset/test/y_test.txt")
subject_test <- read.table("./data/UCI HAR Dataset/test/subject_test.txt")

# Features:
features <- read.table('./data/UCI HAR Dataset/features.txt')

# Activity labels:
activitylabels = read.table('./data/UCI HAR Dataset/activity_labels.txt')

##Getting column names assigned properly
colnames(x_train) <- features[,2] 
colnames(y_train) <-"activityId"
colnames(subject_train) <- "subjectId"

colnames(x_test) <- features[,2] 
colnames(y_test) <- "activityId"
colnames(subject_test) <- "subjectId"

colnames(activitylabels) <- c('activityId','activityType')

#####Merges the training and the test sets to create one data set.

##Now that we know what to call everything we can bring it all together
cb_train <- cbind(y_train, subject_train, x_train)
cb_test <- cbind(y_test, subject_test, x_test)
fullraw <- rbind(cb_train, cb_test)

collabels <- colnames(fullraw)

###Extracts only the measurements on the mean and standard deviation for each measurement.

##Now for the smaller subset of measurements on the mean and standard deviation for each measurement
colkeeping <- grepl("subject|activity|mean|std", colnames(fullraw))
tidyish <- fullraw[, colkeeping]

#Clean up a bit now that we have what we need to work with
rm(fullraw, x_train, y_train, subject_train, x_test, y_test, subject_test)

###Appropriately labels the data set with descriptive variable names.

#Fix our labels so it makes sense a bit to the rest of the world
tidycolnames <- colnames(tidyconlabs)

##Special character handling and reassign fixed headers
tidycolnames <- gsub("[\\(\\)-]", "", tidycolnames)
colnames(tidyconlabs) <- tidycolnames

###From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

tidydatawin <- aggregate(. ~subjectId + activityId, tidyconlabs, mean)
tidydatawin <- tidydatawin[order(tidydatawin$subjectId, tidydatawin$activityId),]


###Uses descriptive activity names to name the activities in the data set

#Handle descriptive activity names
tidied <- merge(tidydatawin, activitylabels, by='activityId', all.x=TRUE)

###From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
write.table(tidied, "tidied_data.txt", row.name=FALSE)

