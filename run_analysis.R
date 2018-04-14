## See comments below. Each of the lines that achieve one of the
## five requirements is tagged as [Item X]. See:
## https://www.coursera.org/learn/data-cleaning/peer/FIZtT/getting-and-cleaning-data-course-project)


## can be used to point to a different path
path="."

## Reading the values
test_data <- read.table(file.path(path, "test","X_test.txt"), header=FALSE)
test_act <- read.table(file.path(path, "test","y_test.txt"), header=FALSE)
test_subject <- read.table(file.path(path, "test","subject_test.txt"), header=FALSE)
train_data <- read.table(file.path(path, "train","X_train.txt"), header=FALSE)
train_act <- read.table(file.path(path, "train","y_train.txt"), header=FALSE)
train_subject <- read.table(file.path(path, "train","subject_train.txt"), header=FALSE)
feature_labels <- read.table(file.path(path, "features.txt"), header=FALSE)
activity_labels <- read.table(file.path(path, "activity_labels.txt"), header=FALSE)

## Naming columns [Item 4]
colnames(test_data) <- as.character(feature_labels[,2])
colnames(train_data) <- as.character(feature_labels[,2])
colnames(test_subject) <- "Subject"
colnames(train_subject) <- "Subject"

## Keeping only those columns with mean / sd [Item 2]
cols <- grep("mean\\(\\)|std\\(\\)",as.character(feature_labels[,2]))
test_data <-test_data[,cols]
train_data <- train_data[,cols]

## Adding column with source (test/train) to the datasets [not strictly necessary]
##test_data$Source="test"
##train_data$Source="train"

## Changing numbers to the action, according to activity labels [Item 3]
test_act$V1 <- as.character(activity_labels$V2[test_act$V1])
train_act$V1 <- as.character(activity_labels$V2[train_act$V1])

colnames(test_act) <- "Activity"
colnames(train_act) <- "Activity"

## Merging activity columns
dtest <- cbind(test_act, test_subject, test_data)
dtrain <- cbind(train_act, train_subject, train_data)

## Merging both sets [Item 1]
dt <- rbind(dtest, dtrain)

## Melting to create a table with Activity, Subject Variable Value
library(reshape2)
dt <- melt(dt, id.vars=colnames(dt)[1:2])

## Grouping
library(dplyr)
dt <- group_by(dt, Activity, Subject, variable)

## Finally getting mean of each variable per Activity and Subject
dt <- dcast(dt, Subject + Activity ~ variable, fun.aggregate = mean)

write.table(dt,file="mean_data.txt",row.names=FALSE,quote=FALSE)
