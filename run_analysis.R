library(dplyr)

setwd("C:/Users/phan3/OneDrive/Desktop/Data")

features <- read.table("UCI HAR Dataset/features.txt", col.names = c("n","functions"))
activities <- read.table("UCI HAR Dataset/activity_labels.txt", col.names = c("code", "activity"))

subject_train <- read.table("UCI HAR Dataset/train/subject_train.txt", col.names = "subject")
x_train <- read.table("UCI HAR Dataset/train/X_train.txt", col.names = features$functions)
y_train <- read.table("UCI HAR Dataset/train/y_train.txt", col.names = "code")


subject_test <- read.table("UCI HAR Dataset/test/subject_test.txt", col.names = "subject")
x_test <- read.table("UCI HAR Dataset/test/X_test.txt", col.names = features$functions)
y_test <- read.table("UCI HAR Dataset/test/y_test.txt", col.names = "code")

X_Data <- rbind(x_train, x_test)
Y_Data <- rbind(y_train, y_test)
Subject <- rbind(subject_train, subject_test)
Merged_Data <- cbind(Subject, Y_Data, X_Data)

CombinedData <- Merged_Data %>% select(subject, code, contains("mean"), contains("std"))
CombinedData$code <- activities[CombinedData$code, 2]

names(CombinedData)[2] = "activity"
names(CombinedData)<-gsub("Acc", "Accelerometer", names(CombinedData))
names(CombinedData)<-gsub("Gyro", "Gyroscope", names(CombinedData))
names(CombinedData)<-gsub("BodyBody", "Body", names(CombinedData))
names(CombinedData)<-gsub("Mag", "Magnitude", names(CombinedData))
names(CombinedData)<-gsub("^t", "Time", names(CombinedData))
names(CombinedData)<-gsub("^f", "Frequency", names(CombinedData))
names(CombinedData)<-gsub("tBody", "TimeBody", names(CombinedData))
names(CombinedData)<-gsub("-mean()", "Mean", names(CombinedData), ignore.case = TRUE)
names(CombinedData)<-gsub("-std()", "STD", names(CombinedData), ignore.case = TRUE)
names(CombinedData)<-gsub("-freq()", "Frequency", names(CombinedData), ignore.case = TRUE)
names(CombinedData)<-gsub("angle", "Angle", names(CombinedData))
names(CombinedData)<-gsub("gravity", "Gravity", names(CombinedData))

FinalData <- CombinedData %>%
  group_by(subject, activity) %>%
  summarise_all(funs(mean))
write.table(FinalData, "FinalData.txt", row.name=FALSE)