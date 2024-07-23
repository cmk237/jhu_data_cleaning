library(dplyr)

zipFile <- "mod3_proj.zip"

if(!file.exists(zipFile)){
  url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
  download.file(url, zipFile, method="curl")
}

if (!file.exists("UCI HAR Dataset")) { 
  unzip(zipFile) 
}

f <- read.table("UCI HAR Dataset/features.txt", col.names =c('#', 'functions'))

activity <- read.table("UCI HAR Dataset/activity_labels.txt", col.names = c("#", "activity"))

x_train <- read.table("UCI HAR Dataset/train/X_train.txt", col.names = f$functions)

y_train <- read.table("UCI HAR Dataset/train/y_train.txt", col.names = "label")

x_test <- read.table("UCI HAR Dataset/test/X_test.txt", col.names = f$functions)

y_test <- read.table("UCI HAR Dataset/test/y_test.txt", col.names = "label")

sub_train <- read.table("UCI HAR Dataset/train/subject_train.txt", col.names = "subject")

sub_test <- read.table("UCI HAR Dataset/test/subject_test.txt", col.names = "subject")

x_merged <- rbind(x_train, x_test)
y_merged <- rbind(y_train, y_test)
sub_merged <- rbind(sub_train, sub_test)
all_data <- cbind(x_merged, y_merged, sub_merged)

mean_std <- all_data[, grep(c("(mean)|(std)|(label)|(subject)"), colnames(all_data))]

mean_std$label <- activity[mean_std$label, 2]

names(mean_std)<-gsub("Acc", "Accelerometer", names(mean_std))
names(mean_std)<-gsub("Gyro", "Gyroscope", names(mean_std))
names(mean_std)<-gsub("BodyBody", "Body", names(mean_std))
names(mean_std)<-gsub("Mag", "Magnitude", names(mean_std))
names(mean_std)<-gsub("^t", "Time", names(mean_std))
names(mean_std)<-gsub("^f", "Frequency", names(mean_std))
names(mean_std)<-gsub("tBody", "TimeBody", names(mean_std))
names(mean_std)<-gsub("label", "activity", names(mean_std))

second_data <- mean_std %>% group_by(subject, activity) %>% summarise_all(funs(mean))
write.table(second_data, "tidy.txt", row.names = FALSE)