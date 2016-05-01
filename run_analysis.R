# run_analysis
# ============
# Instructions for project
# ------------------------
# 
# The purpose of this project is to demonstrate your ability to collect, work 
# with, and clean a data set. The goal is to prepare tidy data that can be 
# used for later analysis. 
# You will be graded by your peers on a series of yes/no questions related to 
# the project. 
# You will be required to submit: 
# 1) a tidy data set as described below, 
# 2) a link to a Github repository with your script for performing the analysis,
# and 
# 3) a code book that describes the variables, the data, and any transformations 
# or work that you performed to clean up the data called CodeBook.md. 
# You should also include a README.md in the repo with your scripts. 
# This repo explains how all of the scripts work and how they are connected.  
# 
# One of the most exciting areas in all of data science right now is wearable 
# computing 
# - see for example this article . Companies like Fitbit, Nike, and Jawbone Up 
# are racing to develop the most advanced algorithms to attract new users. 
# The data linked to from the course website represent data collected from the 
# accelerometers from the Samsung Galaxy S smartphone. A full description is 
# available at the site where the data was obtained: 
# 
# http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones 
# 
# Here are the data for the project: 
# 
# https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 
# 
# You should create one R script called run_analysis.R that does the following. 
# 
# 1. Merges the training and the test sets to create one data set.
# 2. Extracts only the measurements on the mean and standard deviation for each 
#  measurement.
# 3. Uses descriptive activity names to name the activities in the data set.
# 4. Appropriately labels the data set with descriptive activity names.
# 5. Creates a second, independent tidy data set with the average of each 
# variable for each activity and each subject. 

packages <- c("data.table")
sapply(packages, require, character.only=TRUE, quietly=TRUE)

## ----------------------------------------------------------------------------
## Get 
path <- "/Users/sridharms/jhuds/jh-ds-getcleandata-project"
setwd (path)

url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
zipfname <- "SamsungGalaxySDataset.zip"
if (!file.exists(path)) {dir.create(path)}

download.file(url, file.path(path, zipfname), method = "curl")

unzip(file.path(path, zipfname))
        
pathDataFiles <- file.path(path, "UCI HAR Dataset")
list.files(pathDataFiles, recursive=TRUE)

## ----------------------------------------------------------------------------
## Read Features file And Pick the Col Positions of desired feature-related var
dtFeatures <- fread(file.path(pathDataFiles, "features.txt"))
setnames(dtFeatures, names(dtFeatures), c("featureId", "featureName"))
## Get only the mean() and std() variables
dtFeatures <- dtFeatures[grep("mean\\(\\)|std\\(\\)", dtFeatures$featureName), ]
dtFeatures$featureCode <- dtFeatures[, paste0("V", featureId)]
head(dtFeatures)
dtFeatures$feature

## Read Subject Files
dtTrainsubject <- fread(file.path(pathDataFiles, "train", "subject_train.txt"))
dtTestsubject  <- fread(file.path(pathDataFiles, "test" , "subject_test.txt" ))

## Read Activity Files
dtTrainActivityId <- fread(file.path(pathDataFiles, "train", "Y_train.txt"))
dtTestActivityId  <- fread(file.path(pathDataFiles, "test" , "Y_test.txt" ))

## Read observations 
dtTrainObs <- data.table(read.table(file.path(pathDataFiles, "train", "X_train.txt")))
dtTestObs <- data.table(read.table(file.path(pathDataFiles, "test" , "X_test.txt" )))

## Read Activity Names
dtActivityNames <- fread(file.path(pathDataFiles, "activity_labels.txt"))
setnames(dtActivityNames, names(dtActivityNames), c("activityId", "activityName"))

## ----------------------------------------------------------------------------
## Merge
dtsubject <- rbind(dtTrainsubject, dtTestsubject)
setnames(dtsubject, "V1", "subject")

dtActivityId <- rbind(dtTrainActivityId, dtTestActivityId)
setnames(dtActivityId, "V1", "activityId")

dtObs <- rbind(dtTrainObs, dtTestObs)

dtSubActMerged <- cbind(dtsubject, dtActivityId)
dtAllMerged <- cbind(dtSubActMerged, dtObs)

## ----------------------------------------------------------------------------
setkey(dtAllMerged, subject, activityId)

## ----------------------------------------------------------------------------
pick <- c(key(dtAllMerged), dtFeatures$featureCode)
dtAllMerged <- dtAllMerged[, pick, with=FALSE]

## ----------------------------------------------------------------------------
dtAllMerged <- merge(dtAllMerged, dtActivityNames, by="activityId", all.x=TRUE)

## ----------------------------------------------------------------------------
setkey(dtAllMerged, subject, activityId, activityName)

## ----------------------------------------------------------------------------
allMelted <- data.table(melt(dtAllMerged, key(dtAllMerged), 
                             variable.name="featureCode"))


## ----------------------------------------------------------------------------
## Adding Descriptive activity names to the activities in the data set
allMelted <- merge(allMelted, 
                   dtFeatures[, list(featureId, featureCode, featureName)], 
                   by="featureCode", all.x=TRUE)
allMelted$activity <- factor(allMelted$activityName)
allMelted$feature <- factor(allMelted$featureName)

allMelted <- subset (allMelted, select = c(subject, activity, feature, value))

rm (list= ls()[grep(pattern = "^dt", x=ls())])


## ----matchFeature------------------------------------------------------------
matchFeature <- function (rgx) {
  grepl(rgx, allMelted$feature)
}

## ----------------------------------------------------------------
## Appropriately labels the data set with descriptive variable names

## Extract Domain - Time or Frequency using "t" or "f")
n <- 2
y <- matrix(seq(1, n), nrow=n)

x <- matrix(c(matchFeature("^t"), matchFeature("^f")), ncol=nrow(y))
allMelted$domain <- factor(x %*% y, labels=c("Time", "Frequency"))


## Extract Instrument Used - Accelerometer or Gyroscope
x <- matrix(c(matchFeature("Acc"), matchFeature("Gyro")), ncol=nrow(y))
allMelted$instrumentType <- 
        factor(x %*% y, labels=c("Accelerometer", "Gyroscope"))



## Extract Acceleration Type - Body or Gravity 
x <- matrix(c(matchFeature("BodyAcc"), 
              matchFeature("GravityAcc")), ncol=nrow(y))
allMelted$accelType <- factor(x %*% y, labels=c(NA, "Body", "Gravity"))


## Extract Variable Types - Mean SD
x <- matrix(c(matchFeature("mean()"), 
              matchFeature("std()")), ncol=nrow(y))
allMelted$varType <- factor(x %*% y, labels=c("Mean", "STD"))

## Extract Jerk and Magnitude
allMelted$jerk <- factor(matchFeature("Jerk"), labels=c(NA, "Jerk"))
allMelted$magnitude <- factor(matchFeature("Mag"), labels=c(NA, "Magnitude"))

## Extract Axis - X Y Z
n <- 3
y <- matrix(seq(1, n), nrow=n)
x <- matrix(c(matchFeature("-X"), 
              matchFeature("-Y"), matchFeature("-Z")), ncol=nrow(y))
allMelted$axis <- factor(x %*% y, labels=c(NA, "X", "Y", "Z"))


## ----------------------------------------------------------------------------
## Ensure extracting factors from "feature" reconciles  
r1 <- nrow(allMelted[, .N, by=c("feature")])
r2 <- nrow(allMelted[, .N, by=c("domain", "instrumentType", "accelType", 
                                "varType", "jerk", "magnitude", "axis")])
r1 == r2

## ----------------------------------------------------------------------------
setkey(allMelted, subject, activity, domain, instrumentType, 
       accelType, varType, jerk, magnitude, axis)

finalDT <- subset (allMelted, select = -c(feature))

rm (allMelted)

setcolorder(finalDT, c("subject", "activity", "instrumentType", "domain",
                       "accelType", "jerk", "magnitude", "axis", 
                       "varType", "value"))
setkey(finalDT, subject, activity, domain, instrumentType, accelType, varType, 
       jerk, magnitude, axis)

## independent tidy data set with the average of each variable for each activity
# and each subject
dtTidyOne <- finalDT[, list(count = .N, average = mean(value)), by=key(finalDT)]

tidyFile <- file.path(path, "TidyDatasetOfActivityTrackingUsingSmartphones.txt")
write.table(dtTidyOne, tidyFile, quote=FALSE, sep="\t", row.names=FALSE)

