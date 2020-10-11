# Data collected from the accelerometers from the Samsung Galaxy S smartphone.
# Merge the training (X_train.txt) and the test sets (x_test.txt) to create one data set.
# Extract only the measurements on the mean and standard deviation for each measurement.
# Uses descriptive activity names to name the activities in the data set
# Appropriately labels the data set with descriptive variable names.
# Creates an independent tidy data set with the 
# average of each variable for each activity and each subject.

#read in tables from downloaded data
features <- read.table("./features.txt")
test_subject <- read.table("./test/subject_test.txt")
colnames(test_subject) <- "SubjectID"
test_set <- read.table("./test/X_test.txt")
colnames(test_set) <- features[,2]
test_labels <- read.table("./test/y_test.txt")
colnames(test_labels) <- "ActivityID"
train_subject <- read.table("./train/subject_train.txt")
colnames(train_subject) <- "SubjectID"
train_set <- read.table("./train/X_train.txt")
colnames(train_set) <- features[,2]
train_labels <- read.table("./train/y_train.txt")
colnames(train_labels) <- "ActivityID"

#merge all tables into 1 data set
test_df <- cbind(test_subject, test_labels, test_set)
train_df <- cbind(train_subject, train_labels, train_set)
data <- rbind(test_df, train_df)

#extract only mean and standard deviation values
mean_data_cols <- grep("mean", features$V2, ignore.case = TRUE) + 2
mean_data_cols_names <- grep("mean", features$V2, ignore.case = TRUE, value = TRUE)
std_data_cols <- grep("std", features$V2, ignore.case = TRUE) + 2
std_data_cols_names <- grep("std", features$V2, ignore.case = TRUE, value = TRUE)
data_subset <- cbind(data[1:2], data[mean_data_cols], data[std_data_cols])

#change activity levels in test/train_labels from numbers to names
data_subset$ActivityID <- gsub("1", "WALKING", data_subset$ActivityID)
data_subset$ActivityID <- gsub("2", "WALKING_UPSTAIRS", data_subset$ActivityID)
data_subset$ActivityID <- gsub("3", "WALKING_DOWNSTAIRS", data_subset$ActivityID)
data_subset$ActivityID <- gsub("4", "SITTING", data_subset$ActivityID)
data_subset$ActivityID <- gsub("5", "STANDING", data_subset$ActivityID)
data_subset$ActivityID <- gsub("6", "LAYING", data_subset$ActivityID)

#make a tidy data set of averages for each variable for each subject and activity
data_subset <- group_by(data_subset, SubjectID, ActivityID)
final_data_averages <- summarise_all(data_subset, "mean")

#write tidy data set to a text file
write.table(final_data_averages, file = "finalTidyData.txt", row.name = FALSE)