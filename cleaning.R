library(dplyr)
library(tidyr)

#get data
setwd("C:/Users/dingjunjie/Documents/wearble/UCI HAR Dataset")
activity_labels<-read.table("activity_labels.txt")
features<-read.table("features.txt",stringsAsFactors = FALSE)
subject_train<-read.table("./train/subject_train.txt")
x_train<-read.table("./train/X_train.txt")
y_train<-read.table("./train/y_train.txt")

subject_test<-read.table("./test/subject_test.txt")
x_test<-read.table("./test/X_test.txt")
y_test<-read.table("./test/y_test.txt")

#Merges the training and the test sets to create one data set.
x<-rbind(x_train,x_test)
colnames(x)<-features$V2

#Extracts only the measurements on the mean and standard deviation for each measurement.
x_ms<-x[grep("mean\\(|std",features$V2)]

#Uses descriptive activity names to name the activities in the data set
y<-rbind(y_train,y_test)
y$V1[y$V1==1]<-"WALKING"
y$V1[y$V1==2]<-"WALKING_UPSTAIRS"
y$V1[y$V1==3]<-"WALKING_DOWNSTAIRS"
y$V1[y$V1==4]<-"SITTING"
y$V1[y$V1==5]<-"STANDING"
y$V1[y$V1==6]<-"LAYING"


subject<-rbind(subject_train,subject_test)
df<-data.frame(subject,y,x_ms)
write.csv(df,file="tidy_data.csv")
#Appropriately labels the data set with descriptive variable names.
colnames(df)[1:2]<-c("volunteer","activity")


#From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
df_sec<-df %>% group_by(volunteer,activity) %>% summarise_all(mean)
write.table(df_sec,file="second_data.txt", row.name=FALSE)
