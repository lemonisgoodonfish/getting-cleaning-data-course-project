

processDataSet = function(rawData){
  return(rawData[,c(1,2)])
}

lookupLabel = function(labelNumber,labelMap){
  return(labelMap[labelMap[1] == labelNumber,2][[1]])
}

processData = function(context){
  # training data
  subjectFileName = paste(context,"/","subject_",context,".txt",sep="")
  subjectData = read.table(subjectFileName)
  
  labelsFileName = paste(context,"/","y_",context,".txt",sep="")
  labelsData = read.table(labelsFileName)
  
  df = as.data.frame(matrix(ncol=3,nrow=nrow(subjectData)))
  
  dfNames = list("subjectId","context","label")

  df[,1] = subjectData[,1]
  df[,2] = context
  df[,3] = labelsData
  
  dfColNumber = 4
  featureNames = c("body_acc","body_gyro","total_acc")
  for (featureName in featureNames){
    for (axis in c('x','y','z')){
      fName = paste(featureName,"_",axis,"_",context,".txt",sep="")
      colName1 = paste(featureName,axis,"mean",sep="_")
      colName2 = paste(featureName,axis,"sd",sep="_")
      rawData = read.table(paste(context,"/Inertial Signals/",fName,sep=""))
      data = processDataSet(rawData)
      dfNames = c(dfNames,colName1,colName2)
      df[,dfColNumber] = rawData[,1]
      dfColNumber = dfColNumber + 1
      df[,dfColNumber] = rawData[,2]
      dfColNumber = dfColNumber + 1                     
    }
  }
  
  names(df) <- dfNames
  return(df)
}

getSubsetStats = function(df,activity,subjId){
    data = subset(df,label==activity & subjectId==subjId)
    colNames = c("body_acc_x_mean","body_acc_y_mean","body_acc_z_mean","body_gyro_x_mean","body_gyro_y_mean","body_gyro_z_mean","total_acc_x_mean","total_acc_y_mean","total_acc_z_mean")
    df = as.data.frame(matrix(ncol=0,nrow=1))
    df[1,"subject"] = subjId
    df[1,"activity"] = activity
    for (colName in colNames){
      df[1,colName] = mean(data[,colName])
    }
    return(df)
}

getSecondCleanDataSet = function(df){
  activityLabels = read.table("activity_labels.txt")
  
  colNames = c("activity","subject","body_acc_x_mean","body_acc_y_mean","body_acc_z_mean","body_gyro_x_mean","body_gyro_y_mean","body_gyro_z_mean","total_acc_x_mean","total_acc_y_mean","total_acc_z_mean")
  newDf = as.data.frame(matrix(nrow=0,ncol=length(colNames)))
  names(newDf) = colNames
  for (activity in activityLabels[,2]){
    for (subjectId in c(1,2,3,4,5,6,7,8,9)){
      d = getSubsetStats(df,activity,subjectId)
      newDf = rbind(newDf,d)
    }
  }
  return(newDf)
}

processAllData = function(){
  df1 = processData("train")
  df2 = processData("test")
  activityLabels = read.table("activity_labels.txt")
  
  df3 = rbind(df1,df2)
  labels = sapply(df3[,"label"],lookupLabel,labelMap=activityLabels)
  df3[,"label"] = labels
  return(df3)
}




