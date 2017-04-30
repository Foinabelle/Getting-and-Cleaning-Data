library(data.table)


activitylabels<-fread("./UCI HAR Dataset/activity_labels.txt", col.names = c("Activity Level", "activity Name"))
  featurelabels<-fread("./UCI HAR Dataset/features.txt") 
  featureNames<-grep("*mean*|*std*", featurelabels$V2) 
 feature.names<-featurelabels[featureNames]
 #Rename the variables with descriptive names
 names_vector<- feature.names$V2
  names_vector<- gsub("^f", "frequency", names_vector)
  names_vector<- gsub ("^t", "time", names_vector)
  names_vector<- gsub("Acc", "accelorator", names_vector)
  names_vector<- gsub("Gyro", "gyroscope", names_vector)
  names_vector<- gsub ("()-", "", names_vector)
  names_vector<- gsub("BodyBody", "body", names_vector)
 names_vector<- gsub("Mag", "magnitude", names_vector)
 names_vector<-gsub ( "mean", "Mean", names_vector)
 
 
# Make a dataset for the Test data
testX<- fread("./UCI HAR Dataset/test/x_test.txt")[, featureNames, with=FALSE]
testsubj<-fread("./UCI HAR Dataset/test/subject_test.txt")
testY<-fread("./UCI HAR Dataset/test/y_test.txt", col.names = c("Activity"))
 testdata<-cbind(testsubj,testY, testX)
colnames(testdata)<- c("subject", "Activity",names_vector)
 
#make a dataset for the training data
trainX<-fread("./UCI HAR Dataset/train/X_train.txt")
 trainX<-trainX[, featureNames,with=FALSE]
 trainY<-fread("./UCI HAR Dataset/train/y_train.txt")
 trainsubj<- fread("./UCI HAR Dataset/train/subject_train.txt")
                
 colnames(trainX)<-(names_vector)
 colnames(trainsubj)<-"subject"
 colnames(trainY)<- "Activity"
 traindata<-cbind(trainsubj, trainY, trainX)
#combine both data sets
alldata<-rbind(testdata, traindata)
#Name the activities in the dataset - 
alldata$subject<- as.factor(alldata$subject)
alldata<-alldata[,Activity:=factor(Activity, levels = activitylabels$`Activity Level`, labels =activitylabels$`activity Name`)]

# make a clean dataset

alldata<- as.data.frame(alldata)
 alldatamolten<- melt(alldata, id=c("subject", "Activity"))
 alldataclean<-dcast(alldatamolten, subject + Activity ~ variable, mean)

