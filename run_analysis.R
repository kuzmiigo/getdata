library(data.table)

base.dir <- "UCI HAR Dataset"
activity.labels <- read.table(file.path(base.dir, "activity_labels.txt"),
                              col.names=c("ActivityCode", "Activity"))
feature.labels <- read.table(file.path(base.dir, "features.txt"))[,2]
selected.feature.labels <- grep("mean\\(\\)|std\\(\\)", feature.labels, value=TRUE)

read.data.set <- function(set.name) {
    s.path <- file.path(base.dir, set.name, paste0("subject_", set.name, ".txt"))
    y.path <- file.path(base.dir, set.name, paste0("y_", set.name, ".txt"))
    x.path <- file.path(base.dir, set.name, paste0("X_", set.name, ".txt"))
    s <- read.table(s.path, col.names="Subject")
    y <- read.table(y.path, col.names="ActivityCode")
    x <- read.table(x.path)
    colnames(x) <- feature.labels
    data <- cbind(s, y, x)
    data <- merge(data, activity.labels)
    data <- data[, c("Subject", "Activity", selected.feature.labels)]
    return(data)
}

main <- function() {
    training.set <- read.data.set("train")
    test.set <- read.data.set("test")
    full.set <- rbind(training.set, test.set)
    full.dt <- data.table(full.set)
    result <- full.dt[, lapply(.SD, mean), by=c("Subject","Activity")]
    write.csv(result, "HAR-tidy.txt", row.names=FALSE)
}

main()
