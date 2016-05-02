url <- "https://s3.amazonaws.com/coursera-uploads/peer-review/HkJsxW0yEeWEewoyD2Bc5Q/7d025a60f897e48bf450b43b0bd08db6/tidydata.txt"
d1 <- data.table(read.table(url, header = TRUE))

dim1 <- sprintf("%.0d rows, %.0d columns", nrow(d1), ncol(d1))
names(d1)
sapply(d1[, sapply(d1, is.factor), with = FALSE], levels)
d1[subject == 1 & activity == "LAYING", list(subject, activity, timeBodyAccelerometer.mean...X)]



url <- "https://s3.amazonaws.com/coursera-uploads/peer-review/HkJsxW0yEeWEewoyD2Bc5Q/d525e591901ba0450d4b3f18b03b1b69/cleanData.txt"
d2 <- data.table(read.table(url, header = TRUE))
sprintf("%.0d rows, %.0d columns", nrow(d2), ncol(d2))
names(d2)
sapply(d2[, sapply(d2, is.factor), with = FALSE], levels)
d2[Subject == 1 & ActivityLabelsDesc == "LAYING", list(Subject, ActivityLabelsDesc, tBodyAcc.mean...X)]


url <- "https://s3.amazonaws.com/coursera-uploads/peer-review/HkJsxW0yEeWEewoyD2Bc5Q/7cd91029fd25ed1659f7dec75c820985/tidy.txt"
d3 <- data.table(read.table(url, header = TRUE))
sprintf("%.0d rows, %.0d columns", nrow(d3), ncol(d3))
names(d3)
sapply(d3[, sapply(d3, is.factor), with = FALSE], levels)
d3[Subject == 1 & Activity == "LAYING", list(Subject, Activity, tBodyAccMeanX)]


url <- "https://s3.amazonaws.com/coursera-uploads/peer-review/HkJsxW0yEeWEewoyD2Bc5Q/96f87a09ef222e34b5c3f4b0ecdfb9a7/avg_tidy_dataset.txt"
d4 <- data.table(read.table(url, header = TRUE))
sprintf("%.0d rows, %.0d columns", nrow(d4), ncol(d4))
names(d4)
sapply(d4[, sapply(d4, is.factor), with = FALSE], levels)
d4[SUBJECTS == 1 & ACTIVITIES == "LAYING", list(SUBJECTS, ACTIVITIES, BodyAccX_Mean)]