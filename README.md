# Getting and Cleaning Data - Course Project
 
 This is the course project for the Getting and Cleaning Data Coursera course.
 The R script, `run_analysis.R`, does the following:
 
 1.Manually  Download the dataset and unzip the dataset and keep it the working directory
 2. Load the activity and feature info
 3. Loads both the training and test datasets, keeping only those columns which
    reflect a mean or standard deviation
 4. Loads the activity and subject data for each dataset, and merges those
    columns with the dataset
 5. Merges the two datasets
 6. Converts the `activity` and `subject` columns into factors
 
 
 The end result is shown in the file `TidyData.txt`.
