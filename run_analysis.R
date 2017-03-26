#loading of activity labels, column names, test data and train data.
activity_labels <- read.table("activity_labels.txt")[,2]
features <- read.table("features.txt")[,2]
X_test <- read.table("./test/X_test.txt")
y_test <- read.table("./test/y_test.txt")
subject_test <- read.table("./test/subject_test.txt")
X_train <- read.table("./train/X_train.txt")
y_train <- read.table("./train/y_train.txt")
subject_train <- read.table("./train/subject_train.txt")

#naming all the columns, labelling the data set and desciptive activity
names(X_test) = features
y_test[,2] = activity_labels[y_test[,1]]
names(y_test) = c("Activity_ID", "Activity_Label")
names(subject_test) = "subject"
names(X_train) = features
y_train[,2] = activity_labels[y_train[,1]]
names(y_train) = c("Activity_ID", "Activity_Label")
names(subject_train) = "subject"

#extracting the measurements on mean and standard deviation for each measurement
meanstd <- grepl("mean|std", features)
X_test = X_test[,meanstd]
X_train = X_train[,meanstd]

#merging the two measurements data
test_data <- cbind(as.data.table(subject_test), y_test, X_test)
train_data <- cbind(as.data.table(subject_train), y_train, X_train)
mergedata = rbind(test_data, train_data)

#creating tidy daya set and averaging of each variable for each activity and each subject
id_labels = c("subject", "Activity_ID", "Activity_Label")
data_labels = setdiff(colnames(mergedata), id_labels)
meltdata = melt(mergedata, id = id_labels, measure.vars = data_labels)
tidydata = dcast(meltdata, subject + Activity_Label ~ variable, mean)

#writing data to .txt file
write.table(tidy_data, file = "./tidydata.txt")