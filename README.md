# cleaningdata
######Readme
Hello everybody. I will describe here how my script works. 
I know it is not perfect and I can optimize it, make it faster and smaller, but it is another story. 
At least it works and I ll describe how.

* train<-read.table("UCI HAR Dataset/train/X_train.txt")
* test<-read.table("UCI HAR Dataset/test/X_test.txt")

We are reading raw data from the folder UCI HAR Dataset in working directory 

* install.packages("plyr")
* install.packages("dplyr")
* install.packages("Hmisc")
* library(plyr)
* library(dplyr)
* library(Hmisc)

This one is to be sure that all packages are installed

* test_df<-tbl_df(test)
* train_df<-tbl_df(train)

We will convert the data into the local data frame to use plyr and dplyr package

* mg<-merge(train_df, test_df, by = intersect(names(train_df), names(test_df)),all=TRUE)

The mg is the merged dataset (10299x561)

* features<-read.table("UCI HAR Dataset/features.txt")

Taking the name of variables (561)

* coln<-features[,2]
* coln<-as.vector(coln)
* colnames(mg)<-coln

Here we are using this name from features to our merged dataset

* valid_column_names <- make.names(names=names(mg), unique=TRUE, allow_ = TRUE)
* * names(mg) <- valid_column_names

I found out that R does count some column names from features as duplicate.
This is a solution to give them a Unique name and solve this problem
So, now mg is a data set 10299x561 with unique column names

* mgs<-select(mg,matches("(mean|std)"))

And we need columns with only mean and std in it (10299x86)

* ytest<-read.table("UCI HAR Dataset/test/y_test.txt")
* ytrain<-read.table("UCI HAR Dataset/train/y_train.txt")

We need to find out which observation for which activity. This information can be found in this two files




* mgac<-bind_rows(ytrain, ytest)
* mgac<-as.data.frame(mgac)
* rown<-mgac[,1]
* rown<-as.vector(rown)

We need to merge name of observation in one set and take a vector of it. 
So we have a vector of 10299 which consist only of digitals from 1 to 6

* row.f<-factor(rown,labels =c('WALKING', 'WALKING_UPSTAIRS' , 'WALKING_DOWNSTAIRS',  'SITTING', 'STANDING' , 'LAYING'))

Making a factor of it with name of each activity

*mgs<-cbind(mgs,row.f)

Append this vector for data set with selected variables of mean and std

* walking<-filter(mgs,row.f == "WALKING")
* walkingup<-filter(mgs,row.f == "WALKING_UPSTAIRS")
* walkingdo<-filter(mgs,row.f == "WALKING_DOWNSTAIRS")
* sitting<-filter(mgs,row.f == "SITTING")
* standing<-filter(mgs,row.f == "STANDING")
* laying<-filter(mgs,row.f == "LAYING")

We are making 6 data sets, each set has observation for only one Activity

* walking <-summarise_each(walking,funs(mean), -row.f)
* walkingup <-summarise_each(walkingup,funs(mean), -row.f)
* walkingdo <-summarise_each(walkingdo,funs(mean), -row.f)
* sitting <-summarise_each(sitting,funs(mean), -row.f)
* standing <-summarise_each(standing,funs(mean), -row.f)
* laying <-summarise_each(laying,funs(mean), -row.f)

Taking average of each variable for  for only one Activity and excluding column name which cannot be averaged(name of activity)

* walking<-cbind(walking,Activity="Walking")
* walkingup<-cbind(walkingup,Activity="Walking_upstairs")
* walkingdo<-cbind(walkingdo,Activity="Walking_downstairs")
* sitting <-cbind(sitting,Activity="Sitting")
* standing <-cbind(standing,Activity="Standing")
* laying <-cbind(laying,Activity="Laying")

Now we have 6 data sets with 1 observation and 86 variables, variables are averaged from previous one. We need to add a column with the name of activity

* ac2<-merge(walking, walkingup, by = intersect(names(walking), names(walkingup)),all=TRUE)
* ac3<-merge(ac2, walkingdo, by = intersect(names(ac2), names(walkingdo)),all=TRUE)
* ac4<-merge(ac3, sitting, by = intersect(names(ac3), names(sitting)),all=TRUE)
* ac5<-merge(ac4, standing, by = intersect(names(ac4), names(standing)),all=TRUE)
* final<-merge(ac5, laying, by = intersect(names(ac5), names(laying)),all=TRUE)

We need to merge this 6 data sets into the one. It has 6 observation and 87 variables.

* col_idx <- grep("Activity", names(final))


* final <- final[, c(col_idx, (1:ncol(final))[-col_idx])]

We need to order columns, so the Name of activity is the first. 
Of course we could use row names, but it is written than we have to use row.name=FALSE when we ll write the file

* write.table(final,"final_solution.txt",row.name=FALSE,col.names = FALSE  )

File is recorded




