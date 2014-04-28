# Cleaning UCI HAR Dataset

`run_analysis.R` script is used to prepare UCI HAR Dataset for further analysis. It expects data in `UCI HAR Dataset` directory. A full description of the data is available at the site where it was obtained:

http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones 

Here are the data for the project:

https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

`run_analysis.R` script does the following:

1. Reads training and test data sets. For each set:
   1. reads subject, activity and measurements tables from three files;
   2. merges them into one table;
   3. merges activity labels to be used instead of activity codes;
   4. extracts columns we are interested in (subject, activity, means and standard deviations for different measurements).
2. Merges the training and the test data sets.
3. Computes averages of the selected measurements by subject and activity.
4. Writes the resulting tidy data set as CSV to `HAR-tidy.txt`.
