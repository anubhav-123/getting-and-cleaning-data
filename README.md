# getting-and-cleaning-data
assignment for course on corsera

Binds these files,

1. UCI HAR Dataset/train/subject_train.txt
2. UCI HAR Dataset/train/X_train.txt
3. UCI HAR Dataset/train/y_train.txt
    from the train set by columns to a table that contains, the human subject, the activity performed and the values of the features.

Binds these files,

1. UCI HAR Dataset/test/subject_test.txt
2. UCI HAR Dataset/test/X_test.txt
3. UCI HAR Dataset/test/y_test.txt
    from the test set by columns to a table that contains, the human subject, the activity performed and the values of the features.

Binds the data frames created for test and train set into one large dataset by rows.

Extracts only the measurements on the mean and standard deviation for each measurement.
*Finds the target features, which are the features with measurements about mean and standard deviation, and extracts them as well as those that indicate the 'subject' and 'activity' and creates a new data table only with the target variables.

Uses descriptive activity names to name the activities in the data set.
*Replace the variable about activity, that contains integers from 1 to 6, with a factor based on levels and labels contained in the 'activity_labels' data file.

Appropriately labels the data set with target variables with descriptive names.
*Extracts the target variable names from 'features.txt'.
*Corrects a typo that exists in some feature names, that is to replace 'BodyBody' that appears in the names of some features with just 'Body'.
*Creates a new tidy dataset with the appropriate labels for the variable names.

From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
*Group the tidy data table created in step 4, by 'subject' and 'activity'.
*Summarize each variable to find the average for the grouped values.
*Ungroup the data table.
*Add descriptive names to the variables of the new tidy data table, by adding the prefix 'Avrg-' in the names of the target feature averages.


data in text file is written using:
write.table(tidy_data_summary, "tidy_data_summary.txt", row.names = FALSE) 



##Codebook

The code book contains informations on the 'tidy_data_summary' table. It consists of the following:

1. Informations on 'tidy_data_summary' data table
    *Identificators and averages of features
    *Description for the variables of 'tidy_data_summary'
    *How to load 'tidy_data_summary' in R
    *About 'tidy_data_summary' table
2. The process by which the 'tidy_data_summary' table was produced
3. Description of the features on which the averages were based
    *Information on how the features were produced from the raw data
    *Information on the collection of raw data
    *About the original data set
