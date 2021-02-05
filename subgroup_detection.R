# Title: subgroup detection
# Author: Anna Zink
# Date: 07/12/2019
# Updated: 11/10/2019
# Description: mode residuals of risk adjustment formula using random forest and create
#              subgroup importance measures 

library(randomForest)
library(hash)

source('clean_groups.R')

#### RUN RANDOM FOREST
run_rf<-function(Xmat,Y,filename,ntrees=1000,grpsize=500, complexity=250, all=1) {

rf<-randomForest(x=Xmat, y=Y, ntree=ntrees, nodesize=grpsize, maxnodes=complexity, importance=TRUE, keep.forest=TRUE)

# Recursively create and count groups
get_subgroup<-function(df,grp_list, row){
  # if node create or count group 
  if (is.na(row$split)) {
    final_group = toString(sort(grp_list))
    prediction = row$prediction
    # IF GROUP IDENTIFIED ALREADY ADD IT TO THE HASH
    if (has.key(final_group, h)) {
      count<-h[[final_group]][1]
      sumpred<-h[[final_group]][2]
      h[final_group]<-c(count+1, sumpred+prediction)
    }
    # ELSE ADD NEW GROUP TO THE HASH with a count of 1 and its 
    else {
      h[final_group]<-c(1,prediction)
    }
  } 
  else {
    get_subgroup(df, c(grp_list, paste0(row$split, '=0')), df[row$left,])
    get_subgroup(df, c(grp_list, paste0(row$split, '=1')), df[row$right,])
  }
}

# get subgroups from the tree
h<-hash()
for (i in 1:rf$ntree) {
  treei<-getTree(rf, k=i, labelVar=TRUE)
  ngrps = sum(treei$status==-1)
  names(treei)<-c('left','right','split','point','status','prediction')
  get_subgroup(treei, c(), treei[1,])
}

print('get information stored in hash')
vals<-values(h)
counts<-vals[1,]
sumresid<-vals[2,]
df<-data.frame(counts, sumresid)
df$groups<-rownames(df)
df$avgresid<-df$sumresid/df$counts

print(names(df))
print(dim(df))

write.csv(df,'./data/raw_results.csv',row.names=FALSE)

print('clean groups') 
cleangrps('./data/raw_results.csv', ntrees, filename)

}

# run subgroup_detection given inputs 
run_subgroup_detect<-function(size=100, depth=64, fn='default') {

#data<-read.csv(paste0('./data/subgroup_sample_million_with_pred',yr,'.csv'))
data<-read.csv('./data/residual_data.csv')

# create feature list - you can update this for whatever 
# group components you want
vars<-names(data)
agevars<-vars[(grep('age_*',vars))]
chronicvars<-c('mh','diab','cancer','heart')
features<-c(chronicvars, agevars, 'female')
print('selected variables')
print(features)
xupdt = data[,features]

# set # of trees 
ntr<-1000
file<-paste0('groups_',ntr,'trees.csv')
run_rf(xupdt, data$resid, file,ntrees=ntr,grpsize=size, complexity=depth, all=0)

# end run_year function 
}

# run most complex groups (size = 100 with depth of 64)
run_subgroup_detect(size = 100, depth = 64, fn = 'sz100dp64')


