## Data info 
from http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones
### Data Set Information:

>The experiments have been carried out with a group of 30 volunteers within an age bracket of 19-48 years. Each person performed six activities (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING) wearing a smartphone (Samsung Galaxy S II) on the waist. Using its embedded accelerometer and gyroscope, we captured 3-axial linear acceleration and 3-axial angular velocity at a constant rate of 50Hz. The experiments have been video-recorded to label the data manually. The obtained dataset has been randomly partitioned into two sets, where 70% of the volunteers was selected for generating the training data and 30% the test data. The sensor signals (accelerometer and gyroscope) were pre-processed by applying noise filters and then sampled in fixed-width sliding windows of 2.56 sec and 50% overlap (128 readings/window). The sensor acceleration signal, which has gravitational and body motion components, was separated using a Butterworth low-pass filter into body acceleration and gravity. The gravitational force is assumed to have only low frequency components, therefore a filter with 0.3 Hz cutoff frequency was used. From each window, a vector of features was obtained by calculating variables from the time and frequency domain.


### Attribute Information:

#### For each record in the dataset it is provided: 
- Triaxial acceleration from the accelerometer (total acceleration) and the estimated body acceleration. 
- Triaxial Angular velocity from the gyroscope. 
- A 561-feature vector with time and frequency domain variables. 
- Its activity label. 
- An identifier of the subject who carried out the experiment.



## My code(Merges the training and the test sets to create one data set)
### get Data
##### require("data.table") 
##### require("reshape2")
> load required packages
##### url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
##### download.file(url, file.path("./dataFiles.zip"))
##### unzip(zipfile = "dataFiles.zip")
> download and unzip

### find labels and features
##### activityLabels <- read.table("./UCI HAR Dataset/activity_labels.txt",col.names  =c("classLabels", "activityName"))
##### features <- read.table("./UCI HAR Dataset/features.txt",col.names  =c("index", "featureNames"))
> input activity_label and features table into Global Enviroment and then give colnames names
##### featuresget <- grep("(mean|std)\\(\\)", features[, "featureNames"])
> find mean and standard deviation data in the featureNames col of features table
##### measurements <- features[featuresget, "featureNames"]
##### measurements <- gsub('[()]', '', measurements)
> remove "()" in measurements

### get datasets

##### train <- read.table("./UCI HAR Dataset/train/X_train.txt")
##### test<- read.table("./UCI HAR Dataset/test/X_test.txt")
> read train and test table into Global Enviroment
##### train<-train[,featuresget]
##### test<-test[,featuresget]
> Extract from train and test by featuresget 
##### colnames(train)<-measurements
##### colnames(test)<-measurements
> give names to column of train/test table according to measurements
##### trainActivities <- read.table("./UCI HAR Dataset/train/Y_train.txt",col.names = c("Activity"))
##### testActivities <- read.table("./UCI HAR Dataset/test/Y_test.txt",col.names = c("Activity"))
> read Activities train/test table into Global Enviroment and give the column names Activity
##### trainsubjects <- read.table("./UCI HAR Dataset/train/subject_train.txt",col.names = c("SubjectNum"))
##### testsubjects <- read.table("./UCI HAR Dataset/test/subject_test.txt",col.names = c("SubjectNum"))
> read subjects train/test table into Global Enviroment and give the column names Activity
##### train <- cbind(trainsubjects, trainActivities, train)
##### test <- cbind(testsubjects, testActivities,test)
##### mergedata<- rbind(train, test)
> merge datasets

### classLabels to activityName. 
##### mergedata[["Activity"]] <- factor(mergedata[, "Activity"],levels = activityLabels[["classLabels"]],labels = activityLabels[["activityName"]])
##### mergedata[["SubjectNum"]] <- as.factor(mergedata[, "SubjectNum"])
> define factor of mergedata and give levels names
##### mergedata <- reshape2::melt(data = mergedata, id = c("SubjectNum", "Activity"))
>  Extract data by SubjectNum and Activity in mergedata
##### mergedata <- reshape2::dcast(data = mergedata, SubjectNum + Activity ~ variable, fun.aggregate = mean)
>  calculate mean by SubjectNum and Activity in mergedata
### export result
##### write.table(mergedata,file="tidyData.txt",row.names = F)
