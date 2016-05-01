Codebook
========

Variables in the output tidy data set
--------------------------------------

Name            | What It Means
----------------|---------------------------------------------------------------------------------------------
subject         | ID the subject who performed the activity for each window sample. Its range is from 1 to 30.
activity        | Activity name
domain          |  Time domain signal or frequency domain signal (Time or Freq)
instrumentType  |  Measuring instrument (Accelerometer or Gyroscope)
accType         |  Acceleration signal (Body or Gravity)
varType         |  mean or std
jerk            |  Jerk signal
magnitude       |  Magnitude of the signals calculated using the Euclidean Norm
axis            |  3-axial signals in the X, Y and Z directions (X, Y, or Z)
count           |  Count of observations used to compute `average`
average         |  Average of each variable for each activity and each subject

Dataset structure
-----------------


```
str(dtTidy)
```
```
> str(dtTidy)
Classes ‘data.table’ and 'data.frame':	11880 obs. of  11 variables:
 $ subject       : int  1 1 1 1 1 1 1 1 1 1 ...
 $ activity      : Factor w/ 6 levels "LAYING","SITTING",..: 1 1 1 1 1 1 1 1 1 1 ...
 $ domain        : Factor w/ 2 levels "Frequency","Time": 2 2 2 2 2 2 2 2 2 2 ...
 $ instrumentType: Factor w/ 2 levels "Accelerometer",..: 1 1 1 1 1 1 1 1 1 1 ...
 $ accelType     : Factor w/ 2 levels "Body","Gravity": 1 1 1 1 1 1 1 1 1 1 ...
 $ varType       : Factor w/ 2 levels "Mean","STD": 1 1 1 1 1 1 1 1 2 2 ...
 $ jerk          : Factor w/ 1 level "Jerk": NA NA NA NA 1 1 1 1 NA NA ...
 $ magnitude     : Factor w/ 1 level "Magnitude": NA NA NA 1 NA NA NA 1 NA NA ...
 $ axis          : Factor w/ 3 levels "X","Y","Z": 1 2 3 NA 1 2 3 NA 1 2 ...
 $ count         : int  50 50 50 50 50 50 50 50 50 50 ...
 $ average       : num  0.2216 -0.0405 -0.1132 -0.8419 0.0811 ...
 - attr(*, ".internal.selfref")=<externalptr> 
```

Sample Data
------------------------------

```
head(dtTidy)
```
```
   subject activity domain instrumentType accelType varType jerk magnitude axis count      average
1:       1   LAYING   Time  Accelerometer      Body    Mean   NA        NA    X    50  0.221598244
2:       1   LAYING   Time  Accelerometer      Body    Mean   NA        NA    Y    50 -0.040513953
3:       1   LAYING   Time  Accelerometer      Body    Mean   NA        NA    Z    50 -0.113203554
4:       1   LAYING   Time  Accelerometer      Body    Mean   NA Magnitude   NA    50 -0.841929152
5:       1   LAYING   Time  Accelerometer      Body    Mean Jerk        NA    X    50  0.081086534
6:       1   LAYING   Time  Accelerometer      Body    Mean Jerk        NA    Y    50  0.003838204
```
