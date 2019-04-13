library(dplyr)

message("Trying to load data files in R...")

## Creates the list with the instructions needed by 'read.table()'
read.table_instructions <- list(
  # The first object is a list with name 'file'
  # that contains values for 'file' argument,
  # which indicates the path of each file.
  file = list(
    activity_labels = "UCI HAR Dataset/activity_labels.txt",
    features = "UCI HAR Dataset/features.txt",
    subject_train = "UCI HAR Dataset/train/subject_train.txt",
    y_train = "UCI HAR Dataset/train/y_train.txt",
    X_train = "UCI HAR Dataset/train/X_train.txt",
    subject_test = "UCI HAR Dataset/test/subject_test.txt",
    y_test = "UCI HAR Dataset/test/y_test.txt",
    X_test = "UCI HAR Dataset/test/X_test.txt"
  ),
  # The second object is a list with name 'colClasses'
  # that contains the values for 'colClasses' argument
  # that indicates the classes of all variables in each file.
  colClasses = list(
    activity_labels = c("integer", "character"),
    features = c("integer", "character"),
    subject_train = "integer",
    y_train = "integer",
    X_train = rep("numeric", 561),
    subject_test = "integer",
    y_test = "integer",
    X_test = rep("numeric", 561)
  ),
  # The third object is a list with name 'nrows'
  # It contains the values for 'nrows' argument
  # It indicates the number of rows to read in each file.
  nrows = list(
    activity_labels = 6,
    features = 561,
    subject_train = 7352,
    y_train = 7352,
    X_train = 7352,
    subject_test = 2947,
    y_test = 2947,
    X_test = 2947
  )
)

## Uses the instructions created above to load all needed data with 'Map()'.
## For each file the correct arguments are supplied to function 'read.table()',
## Function 'with()' is used for clearer code.
data_files <- with(read.table_instructions,
                   Map(read.table,
                       file = file, colClasses = colClasses, nrows = nrows,
                       quote = "", comment.char = "",
                       stringsAsFactors = FALSE))

message("data files were successfully loaded into R in the list with name 'data_files'.")

#Step-1

## Merges the train and test sets
merged_data <- with(data_files,
                    rbind(cbind(subject_train, y_train, X_train),
                          cbind(subject_test,  y_test,  X_test)))

#Step-2

## Finds the target features indexes from the 'features' data frame,
## by searching for matches with pattens 'mean()' or 'std()'
target_features_indexes <- grep("mean\\(\\)|std\\(\\)",
                                data_files$features[[2]])

## Add 2 to each index to adjust for the first 2 column we have bind
## that should also be included
target_variables_indexes <- c(1, 2,target_features_indexes + 2)

## Extracts the target variables to create the target data frame
target_data <- merged_data[ , target_variables_indexes]

#Step-3:

target_data[[2]] <- factor(target_data[[2]],
                           levels = data_files$activity_labels[[1]],
                           labels = data_files$activity_labels[[2]])

#Step-4

## Extract the target variables names
descriptive_variable_names <- data_files$features[[2]][target_features_indexes]

## Correct a typo
descriptive_variable_names <- gsub(pattern = "BodyBody", replacement = "Body",
                                   descriptive_variable_names)

## Create a tidy data set with appropriate labels for the variable names
tidy_data <- target_data
names(tidy_data) <- c("subject", "activity", descriptive_variable_names)




#STEP 5:

## Create a dataset with the mean of each column for 'subject' and 'activity'
tidy_data_summary <- tidy_data %>%
  group_by(subject, activity) %>%
  summarise_all(funs(mean)) %>%
  ungroup()

## Replace the variable names of 'tidy_data_summary' with new descriptive ones.
## Just the prefix "Avrg-" will be added in all variable names,
new_names_for_summary <- c(names(tidy_data_summary[c(1,2)]),
                           paste0("Avrg-", names(tidy_data_summary[-c(1, 2)])))
names(tidy_data_summary) <- new_names_for_summary

## Save the data frame created as a text file in working directory
write.table(tidy_data_summary, "tidy_data_summary.txt", row.names = FALSE)

message("The script 'run_analysis.R was executed successfully. \n",
        "As a result, a new tidy data set was created with name \n", 
        "'tidy_data_summary.txt' in the working directory.")