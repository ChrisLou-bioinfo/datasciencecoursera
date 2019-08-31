# 1. Merges the training and the test sets to create one data set.
# 2. Extracts only the measurements on the mean and standard deviation for each measurement.
# 3. Uses descriptive activity names to name the activities in the data set
# 4. Appropriately labels the data set with descriptive variable names.
# 5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

## Merges the training and the test sets to create one data set.
### get Data
require("data.table")
require("reshape2")
url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(url, file.path("./dataFiles.zip"))
unzip(zipfile = "dataFiles.zip")

### find labels and features
activityLabels <- read.table("./UCI HAR Dataset/activity_labels.txt",col.names  =c("classLabels", "activityName"))
features <- read.table("./UCI HAR Dataset/features.txt",col.names  =c("index", "featureNames"))
featuresget <- grep("(mean|std)\\(\\)", features[, "featureNames"])
measurements <- features[featuresget, "featureNames"]
measurements <- gsub('[()]', '', measurements)

### get datasets

train <- read.table("./UCI HAR Dataset/train/X_train.txt")
test<- read.table("./UCI HAR Dataset/test/X_test.txt")
train<-train[,featuresget]
test<-test[,featuresget]
colnames(train)<-measurements
colnames(test)<-measurements
trainActivities <- read.table("./UCI HAR Dataset/train/Y_train.txt",col.names = c("Activity"))
testActivities <- read.table("./UCI HAR Dataset/test/Y_test.txt",col.names = c("Activity"))
trainSubjects <- read.table("./UCI HAR Dataset/train/subject_train.txt",col.names = c("SubjectNum"))
testSubjects <- read.table("./UCI HAR Dataset/test/subject_test.txt",col.names = c("SubjectNum"))
train <- cbind(trainSubjects, trainActivities, train)
test <- cbind(testSubjects, testActivities,test)

### merge datasets
mergedata<- rbind(train, test)
### classLabels to activityName. 
mergedata[["Activity"]] <- factor(mergedata[, "Activity"],levels = activityLabels[["classLabels"]],labels = activityLabels[["activityName"]])
mergedata[["SubjectNum"]] <- as.factor(mergedata[, "SubjectNum"])
mergedata <- reshape2::melt(data = mergedata, id = c("SubjectNum", "Activity"))
mergedata <- reshape2::dcast(data = mergedata, SubjectNum + Activity ~ variable, fun.aggregate = mean)
### export result
write.table(mergedata,file="tidyData.txt",row.names = F)
