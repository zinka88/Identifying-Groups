# Title: run riskadjustment
# Author: Anna Zink
# Date: 07/12/2019
# Updated: 01/22/2021
# Description: run risk adjustment model to get the residual for the 
#              main anaysis

library(glmnet)

# get residuals from the risk adjustment formula 
data<-read.csv('./data/simulated_data.csv')

data$age_21_24<-ifelse(data$AGE>20 & data$AGE<25,1,0)
data$age_25_29<-ifelse(data$AGE>=25 & data$AGE<30,1,0)
data$age_30_34<-ifelse(data$AGE>=30 & data$AGE<35,1,0)
data$age_35_39<-ifelse(data$AGE>=35 & data$AGE<40,1,0)
data$age_40_44<-ifelse(data$AGE>=40 & data$AGE<45,1,0)
data$age_45_49<-ifelse(data$AGE>=45 & data$AGE<50,1,0)
data$age_50_54<-ifelse(data$AGE>=50 & data$AGE<55,1,0)
data$age_55_59<-ifelse(data$AGE>=55 & data$AGE<60,1,0)
data$age_60_plus<-ifelse(data$AGE>=60, 1, 0)
data$geo<-as.factor(data$geo)

agevars<-c('age_21_24','age_25_29','age_30_34','age_35_39','age_40_44','age_45_49','age_50_54','age_55_59')

# run risk adjustment regression (excluding chronic conditions) on age x gedner
ra_data<-data[,!(names(data) %in% c('diab','heart','mh','cancer'))]
print(names(ra_data))
ra.ols<-lm(totpay ~., data=ra_data)
print(summary(ra.ols))

# collapse age groups and drop other ages
data$age_21_29<-ifelse(data$age_21_24 | data$age_25_29, 1, 0)
data$age_30_39<-ifelse(data$age_30_34 | data$age_35_39, 1, 0)
data$age_40_49<-ifelse(data$age_40_44 | data$age_45_49, 1, 0)
data$age_50_59<-ifelse(data$age_50_54 | data$age_55_59, 1, 0)
data<-data[,!(names(data) %in% agevars)]

# add in prediction and residual 
data$pred<-predict(ra.ols)
data$resid<-data$pred-data$totpay

write.csv(data, './data/residual_data.csv')


