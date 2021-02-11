# Identifying-Groups
Code for identifying groups under and overpredicted by heatlh plan payment risk 
adjustment formulas. 

# Programs
run_risk_adjustment.R - This program predicts annual spending given demographics and 
health conditions and calculates the residual. 
subgroup_detection.R - This program uses the random forest to predict the residual from the 
risk adjustment given age, sex, and 4 chronic conditions. It saves the groups formed in the 
nodes of each tree using a hash object.
clean_groups.R - This function cleans and returns the groups returned from the random forest.

# Data
in the .\Data folder there is a simulated data set that contains information individual age, sex, health conditions
categories (HCCs), geographic location, and annual health spending.
 
