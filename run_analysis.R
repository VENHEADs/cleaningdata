### Original raw data must be placed in working directory. To find it type getwd()

train<-read.table("UCI HAR Dataset/train/X_train.txt")
test<-read.table("UCI HAR Dataset/test/X_test.txt")
install.packages("plyr")
install.packages("dplyr")
install.packages("Hmisc")
library(plyr)
library(dplyr)
library(Hmisc)
test_df<-tbl_df(test)
train_df<-tbl_df(train)
mg<-merge(train_df, test_df, by = intersect(names(train_df), names(test_df)),all=TRUE)
features<-read.table("UCI HAR Dataset/features.txt")

coln<-features[,2]
coln<-as.vector(coln)
colnames(mg)<-coln

valid_column_names <- make.names(names=names(mg), unique=TRUE, allow_ = TRUE)
names(mg) <- valid_column_names

mgs<-select(mg,matches("(mean|std)"))
ytest<-read.table("UCI HAR Dataset/test/y_test.txt")
ytrain<-read.table("UCI HAR Dataset/train/y_train.txt")
mgac<-bind_rows(ytrain, ytest)
mgac<-as.data.frame(mgac)
rown<-mgac[,1]
rown<-as.vector(rown)
row.f<-factor(rown,labels =c('WALKING', 'WALKING_UPSTAIRS' , 'WALKING_DOWNSTAIRS',  'SITTING', 'STANDING' , 'LAYING'))

mgs<-cbind(mgs,row.f)
walking<-filter(mgs,row.f == "WALKING")
walkingup<-filter(mgs,row.f == "WALKING_UPSTAIRS")
walkingdo<-filter(mgs,row.f == "WALKING_DOWNSTAIRS")
sitting<-filter(mgs,row.f == "SITTING")
standing<-filter(mgs,row.f == "STANDING")
laying<-filter(mgs,row.f == "LAYING")

walking <-summarise_each(walking,funs(mean), -row.f)
walkingup <-summarise_each(walkingup,funs(mean), -row.f)
walkingdo <-summarise_each(walkingdo,funs(mean), -row.f)
sitting <-summarise_each(sitting,funs(mean), -row.f)
standing <-summarise_each(standing,funs(mean), -row.f)
laying <-summarise_each(laying,funs(mean), -row.f)

walking<-cbind(walking,Activity="Walking")
walkingup<-cbind(walkingup,Activity="Walking_upstairs")
walkingdo<-cbind(walkingdo,Activity="Walking_downstairs")
sitting <-cbind(sitting,Activity="Sitting")
standing <-cbind(standing,Activity="Standing")
laying <-cbind(laying,Activity="Laying")

ac2<-merge(walking, walkingup, by = intersect(names(walking), names(walkingup)),all=TRUE)
ac3<-merge(ac2, walkingdo, by = intersect(names(ac2), names(walkingdo)),all=TRUE)
ac4<-merge(ac3, sitting, by = intersect(names(ac3), names(sitting)),all=TRUE)
ac5<-merge(ac4, standing, by = intersect(names(ac4), names(standing)),all=TRUE)
final<-merge(ac5, laying, by = intersect(names(ac5), names(laying)),all=TRUE)

col_idx <- grep("Activity", names(final))


final <- final[, c(col_idx, (1:ncol(final))[-col_idx])]
write.table(final,"final_solution.txt",row.name=FALSE )
















