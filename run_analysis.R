library(dplyr)

#First set the working directory

setwd("E:/Documentos/R/Class/datasciencecoursera/getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset")

#Load all data 

features<-read.table("features.txt",sep=" ",header = FALSE,
                   col.names = c("number","feature"))

activity_label<-read.table("activity_labels.txt",sep=" ",header = FALSE,
                         col.names = c("id","activity"))


subject_test<-read.table("test/subject_test.txt",header = FALSE,
                   col.names = c("subject"))

x_test <- read.table("test/X_test.txt",col.names = features$feature)

y_test <- read.table("test/y_test.txt",col.names = "label")

subject_train<-read.table("train/subject_train.txt",header = FALSE,
                         col.names = c("subject"))

x_train <- read.table("train/X_train.txt",col.names = features$feature)

y_train <- read.table("train/y_train.txt",col.names = "label")


#1. Merge all data in one

x_df<-rbind(x_train,x_test)
y_df<-rbind(y_train,y_test)
subject_df<-rbind(subject_train,subject_test)

data_df<-cbind(subject_df,y_df,x_df)

#2. Extract mean and std data

final_df<- data_df %>% select(subject,label,contains("mean"),contains("std"))

#3. Substitute number for activity description

final_df$label<-activity_label[final_df$label,2]


#4. Check and correct the name of columns

names(final_df)

names(final_df)<-gsub("label","activity",names(final_df))
names(final_df)<-gsub("mean()","mean",names(final_df))
names(final_df)<-gsub("std()","std",names(final_df))
names(final_df)<-gsub("Acc",".accelerometer",names(final_df))
names(final_df)<-gsub("Gyro",".gyroscope",names(final_df))
names(final_df)<-gsub("Mag",".magnitude",names(final_df))
names(final_df)<-gsub("Freq",".frequency",names(final_df))
names(final_df)<-gsub("BodyBody","body",names(final_df))

names(final_df)<-tolower(names(final_df))


#5. Create an independent dataset average of each subject and activity

Tidy_df<- final_df %>% group_by(subject,activity) %>% summarise_all(mean)

write.table(Tidy_df, "Tidy_df.txt", row.name=FALSE)

# test the created file was correct

test<-read.table("Tidy_df.txt",header = TRUE)
