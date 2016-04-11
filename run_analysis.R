## Step 1
# read all the data
test.labels <- read.table("test/y_test.txt", col.names="label")
test.subjects <- read.table("test/subject_test.txt", col.names="subject")
test.data <- read.table("test/X_test.txt")
train.labels <- read.table("train/y_train.txt", col.names="label")
train.subjects <- read.table("train/subject_train.txt", col.names="subject")
train.data <- read.table("train/X_train.txt")

# put it together in the following format: subjects, labels, everything else
data <- rbind(cbind(test.subjects, test.labels, test.data),cbind(train.subjects, train.labels, train.data))


## Step 2
# now read all the features, keep only data concerning "mean" and "std dev"
features <- read.table("features.txt", strip.white=TRUE, stringsAsFactors=FALSE)
featuresMeanStd <- features[grep("mean\\(\\)|std\\(\\)", features$V2), ]
dataMeanStd <- data[, c(1, 2, features.mean.std$V1+2)]

## step 3
# read the labels (activities)
labels <- read.table("activity_labels.txt", stringsAsFactors=FALSE)
# replace labels in data with label names
dataMeanStd$label <- labels[dataMeanStd$label, 2]

## step 4
# make a list of the current column names and feature names
currColnames <- c("subject", "label", featuresMeanStd$V2)
# remove non-alphabetic characters and convert to lowercase
newColNames <- tolower(gsub("[^[:alpha:]]", "", currColnames))
# use the list as column names for data
colnames(dataMeanStd) <- newColNames

## step 5
# create a second, independent tidy data set with the average of each variable for each activity and each subject
finalDataSet <- aggregate(dataMeanStd[, 3:ncol(dataMeanStd)], by=list(subject = dataMeanStd$subject, label = dataMeanStd$label),mean)
write.table(finalDataSet, "TidyData.txt", row.name=FALSE)
