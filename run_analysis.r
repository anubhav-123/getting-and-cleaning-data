#read all data
xTrainData <- read.table("./data/train/X_train.txt")
yTrainData <- read.table("./data/train/Y_train.txt")
trainSubjectData <- read.table("./data/train/subject_train.txt")
xTestData <- read.table("./data/test/X_test.txt")
yTestData <- testLabel <- read.table("./data/test/y_test.txt")
testSubjectData <- read.table("./data/test/subject_test.txt")
features <- read.table("./data/features.txt")

# Step 1. Merge all test and train data
joinedXData <- rbind(xTrainData,xTestData)
relevantFeatures <- grep("mean\\(\\)|std\\(\\)", features[, 2])
#names(joinedXData) <- gsub("\\(\\)", "", features[relevantFeatures, 2]) # remove "()"
joinedYData <- rbind(yTrainData,yTestData)
joinedSubjectData <- rbind(trainSubjectData,testSubjectData)

# Step 2. Extract only the measurements on the mean and standard
# deviation for each relevant features

joinedXData <- joinedXData[, relevantFeatures]
names(joinedXData) <- gsub("\\(\\)", "", features[relevantFeatures, 2]) # remove "()"
# Step3. Uses descriptive activity names to name the activities in
# the data set

activity <- read.table("./data/activity_labels.txt")
activity[, 2] <- tolower(gsub("_", "", activity[, 2]))

activityLabel <- activity[joinedYData[, 1], 2]
joinedYData[, 1] <- activityLabel
names(joinedYData) <- "activity"

# Step4. Appropriately labels the data set with descriptive activity
# names.
names(joinedSubjectData) <- "subject"
cleanedData <- cbind(joinedSubjectData, joinedYData, joinedXData)
dim(cleanedData) # 10299*68
write.table(cleanedData, "merged_data.txt") # write out the 1st dataset
# Step5. Creates a second, independent tidy data set with the average of
# each variable for each activity and each subject.
subjectLen <- length(table(joinedSubjectData)) # 30
activityLen <- dim(activity)[1] # 6
columnLen <- dim(cleanedData)[2]
result <- matrix(NA, nrow=subjectLen*activityLen, ncol=columnLen)
result <- as.data.frame(result)
colnames(result) <- colnames(cleanedData)
row <- 1
for(i in 1:subjectLen) {
  for(j in 1:activityLen) {
    result[row, 1] <- sort(unique(joinedSubjectData)[, 1])[i]
    result[row, 2] <- activity[j, 2]
    bool1 <- i == cleanedData$subject
    bool2 <- activity[j, 2] == cleanedData$activity
    result[row, 3:columnLen] <- colMeans(cleanedData[bool1&bool2, 3:columnLen])
    row <- row + 1
  }
}
write.table(result,"data_with_means.txt",row.name=FALSE) # write out the 2nd dataset
