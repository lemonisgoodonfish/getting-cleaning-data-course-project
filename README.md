# getting-cleaning-data-course-project

This script is to be used with the UCI HAR Dataset from https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 

Download this data set and unzip it.
Place "run_analysis.R" into the top level folder - i.e. "UCI HAR Dataset"
In R, change directory to where "UCI HAR Dataset" is.
Load the source file for "run_analysis.R"

running processAllData() will create the first tidy data set.
running getSecondCleanDataSet() on the result of this will produce the second tidy data set.

e.g.

firstTidyDataSet = processAllData()
secondTidyDataSet = getSecondCleanDataSet(firstTidyDataSet)
