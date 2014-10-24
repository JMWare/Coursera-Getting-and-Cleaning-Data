##	Coursera Getting and Cleaning Data Course - Project
##	Part 5 : Calculating the activity means
##	Function to analyse the merged and subset data file from Parts 1 : 4

run_analysis<-function()
{	options(warn = -1)
	options(stringsAsFactors=FALSE)
	options(digits=5)
	CurrentDir<-getwd()

##	check whether the original files are already ordered and subset
##	If not, create the file
	if(!file.exists("X_merged.txt"))	DataMerge()

##	Read the merged and subset file
	setwd("C:\\G&CDataProject\\UCI HAR Dataset")
	Data<-read.table("X_merged.txt",header=TRUE)
	NrRows<-length(Data[,1])
	NrCols<-length(Data)
	setwd(CurrentDir)

##	Determine break points for subject_ID (column 2) 
	Activity<-Data[1,1]
	Subject<-Data[1,2]
	Break_point<-1
	for(i in 2:NrRows)
	{	if(Data[i,2] != Subject)
		{	Break_point<-c(Break_point, i)
			Subject<-Data[i,2]
		}
	}
	NrBreaks<-length(Break_point)

##	Assemble data.frame of mean values with activity and subject ID in 
##	columns 1 and 2
	MeanDat=data.frame()
	for(i in 1:NrBreaks)
	{	MeanDat[i,1]<-Data[Break_point[i],1]
		MeanDat[i,2]<-Data[Break_point[i],2]
		if(i == NrBreaks)
		{	x<-Break_point[i]
			y<-NrRows
		}
		else
		{	x<-Break_point[i]
			y<-Break_point[i+1]-1
		}
		for(j in 3:NrCols)
		{	MeanDat[i,j]<-mean(Data[x:y,j])
		}
	}		

##	Save the completed file
	setwd("C:\\G&CDataProject\\UCI HAR Dataset")
	ColLabels<-read.table("Labels.txt")
	write.table(MeanDat, file = "Activity_means.txt", sep = " ", quote=FALSE, row.names = FALSE, col.names = ColLabels[,])
	setwd(CurrentDir)

	return(MeanDat[1:10,1:6])
}


##	Function for merging and subsetting the physical activity data sets
##	Project - parts 1 to 4
DataMerge<-function()
{	options(warn = -1)
	options(stringsAsFactors=FALSE)
	CurrentDir<-getwd()

##	Read the label files from 'UCI HAR Dataset' folder
##	Determine which column names refer to 'mean' or 'std' for subsetting
	setwd("C:\\G&CDataProject\\UCI HAR Dataset")
	Activity_labels<-read.table("activity_labels.txt")
	Temp<-read.table("features.txt")
	ColIndex<-COLNRS(Temp[ ,2])
	NrCols<-length(ColIndex)
	Feature_labels<-Labels(Temp[ ,2],ColIndex)

##	Read the 'test' data file and associated ID files
	setwd("C:\\G&CDataProject\\UCI HAR Dataset\\test")
	TestDat<-read.table("X_test.txt")
	TestSubject_ID<-read.table("subject_test.txt")
	TestActivity_ID<-read.table("y_test.txt")	

##	Read the 'train' data file and associated ID files
	setwd("C:\\G&CDataProject\\UCI HAR Dataset\\train")
	TrainDat<-read.table("X_train.txt")
	TrainSubject_ID<-read.table("subject_train.txt")
	TrainActivity_ID<-read.table("y_train.txt")

##	Merge the 'train' and 'test' data sets  
	DataDat<-rbind(TrainDat, TestDat)
	Subject_ID<-rbind(TrainSubject_ID, TestSubject_ID)
	Activity_ID<-rbind(TrainActivity_ID, TestActivity_ID)
	NrRows<-length(DataDat[,1])

##	Garbage collection - release the componenent files from memory
	rm(TestDat, TestSubject_ID, TestActivity_ID, TrainDat, TrainSubject_ID, TrainActivity_ID)

##	Subset mean and std measurements ordered on Activity_ID and Subject_ID
	ORDER<-order(Activity_ID, Subject_ID)
	ActivityDat=data.frame()
	for(i in 1:NrRows)
	{	Index<-ORDER[i]
		ActInd<-Activity_ID[Index,]
		ActivityDat[i, 1]<-Activity_labels[ActInd,2]
		ActivityDat[i, 2]<-Subject_ID[Index,]		
		for(j in 1:NrCols)
		{	ActivityDat[i, j+2] <- DataDat[Index, ColIndex[j]]
		}
	}

##	Create column labels and save dataset
	Feature_labels<-Labels(Temp[,2], ColIndex)	
	setwd("C:\\G&CDataProject\\UCI HAR Dataset")
	write.table(ActivityDat, file = "X_merged.txt", sep = " ", quote=FALSE, row.names = FALSE, col.names=Feature_labels)
	write.table(Feature_labels, file = "Labels.txt", sep = " ", quote=FALSE, row.names = FALSE, col.names=FALSE)	

##	Clean up and exit
	rm(DataDat)
	setwd(CurrentDir)
	return(ActivityDat[1:10,1:6])
}

##	Coursera Getting and Cleaning Data Course - Project part 5

## Function for subsetting column numbers

COLNRS<-function(COLNAMES)
{	ColNr<-NULL
	for(i in 1:length(COLNAMES))
	{	if((grepl("mean",COLNAMES[i],fixed=TRUE)) || (grepl("std",COLNAMES[i],fixed=TRUE)))
		{	 ColNr<-c(ColNr, i)
		}
	}
	return(ColNr)	
}

## Function for subsetting column names

Labels<-function(F_labels, Index)
{	Col_labels<-c("Activity","Subject_ID")
	for(i in 1:length(Index))
	{	Col_labels<-c(Col_labels, F_labels[Index[i]])
	}
	return(Col_labels)
}
