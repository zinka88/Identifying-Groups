# Identifying-GroupsCode for identifying groups under and overpredicted by heatlh plan payment risk 
Code for identifying groups under and overpredicted by health plan payment risk 

# Programs
*run_risk_adjustment.R - This program uses OLS to predict annual spending given demographics and 
health conditions and calculates the residual. 

*subgroup_detection.R - This program uses the random forest to predict the residual from the 
risk adjustment given age, sex, and 4 chronic conditions. It saves the groups formed in the 
nodes of each tree using a hash object.

*clean_groups.R - This function cleans and returns the groups returned from the random forest.

# Data
The programs use the simulated data in the .\Data folder. This simulated data contains information on
individual age, sex, health conditions categories (HCCs), geographic location, and annual health spending.
 
