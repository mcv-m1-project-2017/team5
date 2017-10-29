clear;clc; close all;
addpath(genpath('../..'))
%Get values from dataset with week1 function
[sFrequency ,maxSize ,minSize ,formFactor ,fillingRatio,sFrequencyPercent] = SignalCharacteristics('../../DataSet/train/');
pDirectory = '../../DataSet/train';
%The best algorithm was 4_3 ( Opening + Hole filling with sphere)
directory = '../../DataSet/train/validation_split/YcbCrAndHSV_mask/12_3/';
CCL( directory,pDirectory, maxSize, minSize, fillingRatio,false, true );
%Second Algorithm
directory = '../../DataSet/train/validation_split/YcbCrAndHSV_mask/12_4/';
CCL( directory,pDirectory, maxSize, minSize, fillingRatio,false, true );
%Third Algorithm
directory = '../../DataSet/train/validation_split/YcbCrAndHSV_mask/12_5/';
CCL( directory,pDirectory, maxSize, minSize, fillingRatio,false, true );