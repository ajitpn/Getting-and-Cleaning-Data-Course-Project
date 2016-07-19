setwd('D:\\Workspace\\Git\\coursera\\datascience\\Getting-and-Cleaning-Data-Course-Project')
### 0.  Load necessary libraries
    library(plyr)


### 1. Merge the training and the test sets to create one data set.

    #  Load the training and test sets

    X.train <-  read.table("UCI HAR Dataset\\train\\X_train.txt")
    y.train <-  read.table("UCI HAR Dataset\\train\\y_train.txt")
    subject.train <-  read.table("UCI HAR Dataset\\train\\subject_train.txt")

    X.test <-  read.table("UCI HAR Dataset\\test\\X_test.txt")
    y.test <-  read.table("UCI HAR Dataset\\test\\y_test.txt")
    subject.test <-  read.table("UCI HAR Dataset\\test\\subject_test.txt")

    # Create the merged data for x, y and subject

    X.merged <- rbind(X.train, X.test)
    y.merged <- rbind(y.train, y.test)
    subject.merged <- rbind(subject.train, subject.test)
    
    
### 2. Extract only the measurements on the mean and standard deviation 
###   for each measurement.

    # Load features and identify mean and standard deviation measurements
    # (features with names containing "-mean" or "-std")
    features <- read.table("UCI HAR Dataset\\features.txt")
    features.desired <- grep("-(mean|std)\\(\\)", features[, 2])
    
    # extract only the desired columns and name columns correctly
    X.extract <- X.merged[, features.desired]
    names(X.extract) <- features[features.desired, 2]


### 3. Use descriptive activity names to name the activities in the data set

    activity.names <- read.table("UCI HAR Dataset\\activity_labels.txt")
    y.merged[,1] <- activity.names[y.merged[,1], 2]
    names(y.merged) <- "activity"


### 4. Appropriately label the data set with descriptive variable names.

    names(subject.merged) <- "subject"
    all.data <- cbind(subject.merged, y.merged, X.extract)   


### 5. From the data set in step 4, create a second, independent tidy data set
###    with the average of each variable for each activity and each subject

    TidyData <- ddply(all.data, .(subject, activity), function(x) colMeans(x[, 3:68]))
    
    write.table(TidyData, "TidyData.txt", row.name=FALSE)