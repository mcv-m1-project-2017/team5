# icv-m1-project
Introduction to Human and Computer Vision project

WEEK 1:
* Project folder tree:

   |-- Dataset
        |-- test
        |-- train
            |-- gt
            |-- mask
            |--train_split
                |-- gt
                |-- mask
                |-- MeanShift_mask
            |--validation_split
                |-- gt
                |-- mask
    |-- circular_hough
    |-- colorspace
    |-- evaluation
    |-- dataset_analysis
    |-- color_segmentation
        |-- k_means
        |-- Mean_Shift
        |-- k_means_ycbcr
    
    * TASK 1 and TASK 2: To run these tasks you must to run launch_characteristics_extraction.m script that is available in dataset_analysis folder.
    
    * TASK 3: To run this task (that is in color_segmentation folder) you must to run algorithms scripts that has algorithm name like k_means.m, these scripts has folder for each one.
    
    * TASK 4: Run launch_detection.m with mask path in order to obtain performance evaluation.
    
    * TASK 5: Use EqualizeImage(Img) function in order to obtain a equalize image.
