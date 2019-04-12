#STEP-1
#Download file and unzip
download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
              ,destfile = "zip")
unzip("zip",exdir = "unzip")

#Load 6 target file 
xtest<-read.table("./unzip/UCI HAR Dataset/test/X_test.txt",stringsAsFactors = F)
ytest<-read.table("./unzip/UCI HAR Dataset/test/Y_test.txt",stringsAsFactors = F)
stest<-read.table("./unzip/UCI HAR Dataset/test/subject_test.txt",stringsAsFactors = F)
xtrain<-read.table("./unzip/UCI HAR Dataset/train/X_train.txt",stringsAsFactors = F)
ytrain<-read.table("./unzip/UCI HAR Dataset/train/Y_train.txt",stringsAsFactors = F)
strain<-read.table("./unzip/UCI HAR Dataset/train/subject_train.txt",stringsAsFactors = F)

#Bind train file and test file by row
X<-rbind(xtrain,xtest)
Y<-rbind(ytrain,ytest)
subject<-rbind(strain,stest)

#Bind X, Y, and subject by column
data<-cbind(Y,X)
data<-cbind(subject,data)

#STEP-2
#Extract mean and std from text and rename columns
colname<-read.table("./unzip/UCI HAR Dataset/features.txt",stringsAsFactors = F)
colname<-c("subject","activity",colname$V2)
chosen<-grepl("mean|std",colname)&
        !grepl("meanFreq()",colname)
chosen[1:2]<-c(T,T)
colnames(data)<-colname

#STEP-3
#Describe activity by char instead of number
act<-c("WALKING","WALKING_UPSTAIRS",
       "WALKING_DOWNSTAIRS","SITTING",
       "STANDING","LAYING")
for (i in 1:10299) {
        data[,2][data[,2]==i]<-act[i]
}

#STEP-4
#Rename variable names
data<-data[,chosen]

#STEP-5
#Tidy data by subjects and activities and 
#calculate their mean 
final_data<-data%>%
        group_by(subject,activity)%>%
        summarise_all(mean)

#Remove temporary subject
rm(xtrain,xtest,X,ytrain,ytest,Y,
   strain,stest,subject,chosen,colname,act,i,data)

#final_data
head(final_data)

write.table(final_data, "FinalData.txt", row.name=FALSE)
