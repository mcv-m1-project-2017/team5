clear;clc; close all;
addpath(genpath('../..'))
%Get values from dataset with week1 function
[sFrequency ,maxSize ,minSize ,formFactor ,fillingRatio,sFrequencyPercent] = SignalCharacteristics('../../DataSet/train/');
pDirectory = '../../DataSet/train';
%The best algorithm was 12_8
directory = '../../DataSet/train/validation_split/YcbCrAndHSV_mask/12_8/';
[pPrecisionw1,pAccuracyw1,pSensitivityw1,pF1w1,pRecallw1,windowTP1,windowFN1,windowFP1 ] = CCL( directory,pDirectory, maxSize, minSize, fillingRatio,false, true,2 );
%Second Algorithm 12_3
directory = '../../DataSet/train/validation_split/YcbCrAndHSV_mask/12_3/';
[pPrecisionw2,pAccuracyw2,pSensitivityw2,pF1w2,pRecallw2,windowTP2,windowFN2,windowFP2 ] = CCL( directory,pDirectory, maxSize, minSize, fillingRatio,false, true,1 );
%Third Algorithm 12_4
directory = '../../DataSet/train/validation_split/YcbCrAndHSV_mask/12_4/';
[pPrecisionw3,pAccuracyw3,pSensitivityw3,pF1w3,pRecallw3,windowTP3,windowFN3,windowFP3 ] = CCL( directory,pDirectory, maxSize, minSize, fillingRatio,false, true,1 );