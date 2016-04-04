## Create one R script called run_analysis.R that does the following:
## 1. Merges the training and the test sets to create one data set.
## 2. Extracts only the measurements on the mean and standard deviation for each measurement.
## 3. Uses descriptive activity names to name the activities in the data set
## 4. Appropriately labels the data set with descriptive activity names.
## 5. Creates a second, independent tidy data set with the average of each variable for each activity and each subject.

if (!require("data.table")) {
        install.packages("data.table")
}

if (!require("reshape2")) {
        install.packages("reshape2")
}

if (!require("plyr")) {
        install.packages("plyr")
}


require("data.table")
require("reshape2")
require("plyr")

#filesPath="E:\\Bigdata\\Datascience\\CleaningData\\ProjectAssignment\\UCI HAR Dataset\\"
filesPath=getwd()


# Read subject files
dataSubjectTrain <- read.table(file.path(filesPath, "train", "subject_train.txt"))
dataSubjectTest  <- read.table(file.path(filesPath, "test" , "subject_test.txt" ))

# Read activity files
dataActivityTrain <- read.table(file.path(filesPath, "train", "Y_train.txt"))
dataActivityTest  <- read.table(file.path(filesPath, "test" , "Y_test.txt" ))

#Read data files.
dataTrain <- read.table(file.path(filesPath, "train", "X_train.txt" ))
dataTest  <- read.table(file.path(filesPath, "test" , "X_test.txt" ))

#1. Merges the training and the test sets to create one data set.
# for both Activity and Subject files this will merge the training and the test sets by row binding 
#and rename variables "subject" and "activityNum"
alldataSubject <- rbind(dataSubjectTrain, dataSubjectTest)
setnames(alldataSubject, "V1", "subject")
alldataActivity<- rbind(dataActivityTrain, dataActivityTest)
setnames(alldataActivity, "V1", "activityNum")

#combine the DATA training and test files
dataTable <- rbind(dataTrain, dataTest)

# name variables according to feature e.g.(V1 = "tBodyAcc-mean()-X")
dataFeatures <- read.table(file.path(filesPath, "features.txt"))
setnames(dataFeatures, names(dataFeatures), c("featureNum", "featureName"))
colnames(dataTable) <- dataFeatures$featureName

#column names for activity labels
activityLabels<- read.table(file.path(filesPath, "activity_labels.txt"))
setnames(activityLabels, names(activityLabels), c("activityNum","activityName"))

# Merge columns
alldataSubjAct<- cbind(alldataSubject, alldataActivity)
dataTable <- cbind(alldataSubjAct, dataTable)
#2. Extracts only the measurements on the mean and standard deviation for each measurement.

# Reading "features.txt" and extracting only the mean and standard deviation
dataFeaturesMeanStd <- grep("mean\\(\\)|std\\(\\)",dataFeatures$featureName,value=TRUE) #var name

# Taking only measurements for the mean and standard deviation and add "subject","activityNum"

dataFeaturesMeanStd <- union(c("subject","activityNum"), dataFeaturesMeanStd)
dataTable<- subset(dataTable,select=dataFeaturesMeanStd) 

#3. Uses descriptive activity names to name the activities in the data set

##enter name of activity into dataTable
dataTable <- merge(activityLabels, dataTable , by="activityNum", all.x=TRUE)
dataTable$activityName <- as.character(dataTable$activityName)

## create dataTable with variable means sorted by subject and Activity
dataTable$activityName <- as.character(dataTable$activityName)
dataAggr<- aggregate(. ~ subject - activityName, data = dataTable, mean) 
dataTable<- arrange(dataAggr,subject,activityName)

#4. Appropriately labels the data set with descriptive variable names.
#Names before
head(str(dataTable),2)
#5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

write.table(dataTable, "TidyData.txt", row.name=FALSE)




