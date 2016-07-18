# Setting the folder as work directory
> setwd("~/Documents/Uni Stuff/Coursera/Getting and Cleaning Data/UCI HAR Dataset")
> filespath <- "~/Documents/Uni Stuff/Coursera/Getting and Cleaning Data/UCI HAR Dataset"

# This reads the subject files
> datasubjecttrain <- tbl_df(read.table(file.path(filespath, "train", "subject_train.txt")))
> datasubjecttest <- tbl_df(read.table(file.path(filespath, "test", "subject_test.txt")))

# This reads the activity files
> dataactivitytrain <- tbl_df(read.table(file.path(filespath, "train", "Y_train.txt")))
> dataactivitytest <- tbl_df(read.table(file.path(filespath, "test", "Y_test.txt"))

# This reads the data files
> datatrain <- tbl_df(read.table(file.path(filespath, "train", "X_train.txt")))
> datatest <- tbl_df(read.table(file.path(filespath, "test", "X_test.txt")))

# For both Activity and Subject files, the training and test sets will be merged by 
#row binding and the variables will be renamed to "subject" and "activityNum"
> alldatasubject <- rbind(datasubjecttrain, datasubjecttest)
> setnames(alldatasubject, "V1", "subject")
> alldataactivity<- rbind(dataactivitytrain, dataactivitytest)
> setnames(alldataactivity, "V1", "activityNum")

# Combines the DATA training and test files
> dataTable <- rbind(datatrain, datatest)

# Names the variables according to their features
> datafeatures <- tbl_df(read.table(file.path(filespath, "features.txt")))
> setnames(datafeatures, names(datafeatures), c("featureNum", "featureName"))
> colnames(dataTable) <- datafeatures$featureName

# Column names for activity labels
> activityLabels <- tbl_df(read.table(file.path(filespath, "activity_labels.txt")))
> setnames(activityLabels, names(activityLabels), c("activityNum", "activityName"))

# Merges columns
> alldataSubjAct <- cbind(alldatasubject, alldataactivity)
> dataTable <- cbind(alldataSubjAct, dataTable)

# This reads "features.txt" and extracts only the mean and standard deviation
> dataFeaturesMeanStd <- grep("mean\\(\\)|std\\(\\)", datafeatures$featureName, value=TRUE)

# This takes the measurements for mean and standard deviation and adds "subject" and "activityNum"
> dataFeaturesMeanStd <- union(c("subject", "activityNum"), dataFeaturesMeanStd)
> dataTable <- subset(dataTable, select=dataFeaturesMeanStd)

# This enters the name of activities into dataTable
> dataTable <- merge(activityLabels, dataTable, by="activityNum", all.x=TRUE)
> dataTable$activityName <- as.character(dataTable$activityName)

# This creates the dataTable with variables sorted by Subject and Activity
> dataTable$activityName <- as.character(dataTable$activityName)
> dataAggr <- aggregate(. ~ subject - activityName, data = dataTable, mean)
> dataTable <- tbl_df(arrange(dataAggr, subject, activityName))

# This appropriately labels the data set with their descriptive variable names
> names(dataTable) <- gsub("std()", "SD", names(dataTable))
> names(dataTable) <- gsub("mean()", "MEAN", names(dataTable))
> names(dataTable) <- gsub("^t", "time", names(dataTable))
> names(dataTable) <- gsub("^f", "frequency", names(dataTable))
> names(dataTable) <- gsub("Acc", "Accelormetor", names(dataTable))
> names(dataTable) <- gsub("Gyro", "Gyroscope", names(dataTable))
> names(dataTable) <- gsub("Mag", "Magnitude", names(dataTable))
> names(dataTable) <- gsub("BodyBody", "Body", Names(dataTable))

# Finally this creates a second and independent data set with the average of each 
#variable for each activity and subject
> write.table(dataTable, "TidyData.txt", row.names=FALSE)
