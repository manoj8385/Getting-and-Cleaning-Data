##1. Merges the training and the test sets to create one data set.

testLabels <- read.table("test/y_test.txt", col.names="label")
testSubjects <- read.table("test/subject_test.txt", col.names="subject")
testData <- read.table("test/X_test.txt")
trainLabels <- read.table("train/y_train.txt", col.names="label")
trainSubjects <- read.table("train/subject_train.txt", col.names="subject")
trainData <- read.table("train/X_train.txt")

data <- rbind(cbind(testSubjects, testLabels, testData),
              cbind(trainSubjects, trainLabels, trainData))

## 2. Extracts only the measurements on the mean and standard deviation for each measurement.
features <- read.table("features.txt", strip.white=TRUE, stringsAsFactors=FALSE)
featureMeanStd <- features[grep("mean\\(\\)|std\\(\\)", features$V2), ]
dataMeanStd <- data[, c(1, 2, featureMeanStd$V1+2)]

## 3. Uses descriptive activity names to name the activities in the data set
labels <- read.table("activity_labels.txt", stringsAsFactors=FALSE)
dataMeanStd$label <- labels[dataMeanStd$label, 2]

## 4. Appropriately labels the data set with descriptive variable names. 
columnNames <- c("subject", "label", featureMeanStd$V2)
columnNames <- tolower(gsub("[^[:alpha:]]", "", columnNames))
colnames(dataMeanStd) <- columnNames

## 5. Appropriately labels the data set with descriptive variable names. 
aggregrateData <- aggregate(dataMeanStd[, 3:ncol(dataMeanStd)],
                       by=list(subject = dataMeanStd$subject, 
                               label = dataMeanStd$label),
                       mean)


write.table(format(aggregrateData, scientific=T), "tidy.txt",
            row.names=F, col.names=F, quote=2)