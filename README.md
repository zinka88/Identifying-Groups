# Code for "Identifying Undercompensated Groups Defined by Multiple Attributes in Risk Adjustment" 
Code for identifying groups under and overpredicted by the health care payment system.

# Programs
*run_risk_adjustment.R - This program uses OLS to predict annual spending given demographics and 
health conditions and calculates the residual. 

*subgroup_detection.R - This program predicts the residual given age, sex, and 4 chronic conditions 
using the random forests algorithm. The groups formed in the 
nodes of each tree are saved using a hash object.

*clean_groups.R - This function cleans and returns the groups returned from the random forests.

# Data
The programs use simulated data found in the "data" folder. This simulated data contains information on
individual age, documented sex, health conditions categories (HCCs), geographic location, and annual health spending.
 
