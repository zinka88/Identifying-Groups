# Title: clean_groups.R
# Author: Anna Zink
# Date: 12/1/2019
# Description: Clean up groups from rf output 
library(stringr)
library(hash) 

cleangrps<-function(infile, ntrees,outfile) { 

data<-read.csv(infile)

# first define whether male or female (if gender was used as a split)
data$gender<-ifelse(grepl("female=1", data$groups),'female','male')
data$gender<-ifelse(grepl("female", data$groups), data$gender, '')

# then define distinct age group (if any age variables were included in the split)
agevars<-c('age_21_29','age_30_39','age_40_49','age_50_59','age_60_plus')

# set default to all ages 
findage<-function(dsn) {
    string<-dsn['groups']
	agehash<-hash(keys=agevars, values=rep(1, length(agevars)))
	for (age in agevars) {
		# if any age variables are 1 then that is the age
		age_found1<-grepl(paste0(age,'=1'),string)
		if (age_found1) {
			# set hash to zero except age and break the loop
			agehash[agevars]=rep(0,length(agevars))
			agehash[[age]]=1
			break
		}
		# if any age variables are 0 then it is the complement age
		age_found0<-grepl(paste0(age,'=0'),string)
		if (age_found0) {
			agehash[[age]]=0
		}
	}
    # use hash to create the text  
    ages<-values(agehash)[values(agehash)==1]
    age_str<-names(ages)
 
    nones<-sum(values(agehash))
    nages<-length(agevars)
    if ( (nages == nones) | (nones == 0) ) {
      age_str<-''
    }
    return(age_str)
}

data$age<-apply(data, 1, findage)

# finally list any chronic conditions they have - if more groups
data$cancer<-ifelse(grepl("cancer=1", data$groups),'cancer','')
data$diab<-ifelse(grepl("diab=1", data$groups),'diabetes','')
data$heart<-ifelse(grepl("heart=1", data$groups),'heart disease','')
data$mental<-ifelse(grepl("mh=1", data$groups),'mental','')

# identify groups without conditions (different from people with or without)
data$nocancer<-ifelse(grepl("cancer=0", data$groups),'no cancer','')
data$nodiab<-ifelse(grepl("diab=0", data$groups),'no diabetes','')
data$noheart<-ifelse(grepl("heart=0", data$groups),'no heart disease','')
data$nomental<-ifelse(grepl("mh=0", data$groups),'no mental','')

data<-within(data, chronic<-paste(cancer, diab, heart, mental, sep=' '))
data$chronic<-trimws(data$chronic)

data<-within(data, nochronic<-paste(nocancer, nodiab, noheart, nomental, sep=' '))
data$nochronic<-trimws(data$nochronic)

# create final group string - in gender / age / chronic order 
data<-within(data, group_updt<-paste(gender, age, chronic, nochronic, sep=' '))

# output
data<-apply(data, 2, as.character)
keepvars<-c('group_updt','avgresid','counts')
write.csv(data[,keepvars], paste0('./output/',outfile),row.names=FALSE) 

}

