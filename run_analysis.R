library(data.table)

base.dir <- "UCI HAR Dataset"  # Base directory of data
output.file <- "HAR-tidy.txt"

# Read activity and feature labels
activity.labels <- read.table(file.path(base.dir, "activity_labels.txt"),
                              col.names=c("ActivityCode", "Activity"))
feature.labels <- read.table(file.path(base.dir, "features.txt"))[,2]

# Select features with "mean()" or "std()" in names
selected.feature.labels <- grep("mean\\(\\)|std\\(\\)", feature.labels, value=TRUE)

## read.data.set reads and prepares the data set with the given name
## (training or test)
read.data.set <- function(set.name) {
    s.path <- file.path(base.dir, set.name, paste0("subject_", set.name, ".txt"))
    y.path <- file.path(base.dir, set.name, paste0("y_", set.name, ".txt"))
    x.path <- file.path(base.dir, set.name, paste0("X_", set.name, ".txt"))
    s <- read.table(s.path, col.names="Subject")
    y <- read.table(y.path, col.names="ActivityCode")
    x <- read.table(x.path)
    colnames(x) <- feature.labels
    # Combine subject, activity and measurements tables into one
    data <- cbind(s, y, x)
    # Merge activity labels to be used instead of activity codes
    data <- merge(data, activity.labels)
    # Extract columns we are interested in
    data <- data[, c("Subject", "Activity", selected.feature.labels)]
    return(data)
}

main <- function() {
    # Read and merge training and test data sets
    training.set <- read.data.set("train")
    test.set <- read.data.set("test")
    full.set <- rbind(training.set, test.set)
    # Use data.table to compute averages by subject and activity
    full.dt <- data.table(full.set)
    result <- full.dt[, lapply(.SD, mean), by=c("Subject","Activity")]
    # Write the resulting tidy data set as CSV
    write.csv(result, output.file, row.names=FALSE)
}

main()
