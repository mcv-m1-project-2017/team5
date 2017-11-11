 clear;clc; close all;
 addpath(genpath('..'))
 pDirectory = '../DataSet/train';
 templatesDirectory = '../DataSet/train/validation_split/templates/';
%Get values from dataset with week1 function
[sFrequency ,maxSize ,minSize ,formFactor ,fillingRatio,sFrequencyPercent] = SignalCharacteristics('../DataSet/train/validation_split/');
%The best algorithm was 12_8
directory = '../DataSet/train/validation_split/YcbCrAndHSV_mask/12_8/';
[pPrecisionw1,pAccuracyw1,pSensitivityw1,pF1w1,pRecallw1,windowTP1,windowFN1,windowFP1,pPrecision1,pAccuracy1,pSpecificity1,pSensitivity1,pF1_1,pRecall1 ] = CCL( directory,pDirectory, maxSize, minSize, fillingRatio,false, true,1 );
[pPrecisionw2,pAccuracyw2,pSensitivityw2,pF1w2,pRecallw2,windowTP2,windowFN2,windowFP2,pPrecision2,pAccuracy2,pSpecificity2,pSensitivity2,pF1_2,pRecall2 ] = ReadAndApplyTemplates(directory,pDirectory,templatesDirectory,false ,true,1, maxSize, minSize, fillingRatio);
%Second Algorithm 12_3
directory = '../DataSet/train/validation_split/YcbCrAndHSV_mask/12_3/';
[pPrecisionw3,pAccuracyw3,pSensitivityw3,pF1w3,pRecallw3,windowTP3,windowFN3,windowFP3,pPrecision3,pAccuracy3,pSpecificity3,pSensitivity3,pF1_3,pRecall3 ] = CCL( directory,pDirectory, maxSize, minSize, fillingRatio,false, true,1 );
[pPrecisionw4,pAccuracyw4,pSensitivityw4,pF1w4,pRecallw4,windowTP4,windowFN4,windowFP4,pPrecision4,pAccuracy4,pSpecificity4,pSensitivity4,pF1_4,pRecall4 ] = ReadAndApplyTemplates(directory,pDirectory,templatesDirectory,false ,true,1, maxSize, minSize, fillingRatio);
%Change window filter
%12_8
directory = '../DataSet/train/validation_split/YcbCrAndHSV_mask/12_8/';
[pPrecisionw5,pAccuracyw5,pSensitivityw5,pF1w5,pRecallw5,windowTP5,windowFN5,windowFP5,pPrecision5,pAccuracy5,pSpecificity5,pSensitivity5,pF1_5,pRecall5 ] = CCL( directory,pDirectory, maxSize, minSize, fillingRatio,false, true,2 );
[pPrecisionw6,pAccuracyw6,pSensitivityw6,pF1w6,pRecallw6,windowTP6,windowFN6,windowFP6,pPrecision6,pAccuracy6,pSpecificity6,pSensitivity6,pF1_6,pRecall6 ] = ReadAndApplyTemplates(directory,pDirectory,templatesDirectory,false ,true,2, maxSize, minSize, fillingRatio);
%12_3
directory = '../DataSet/train/validation_split/YcbCrAndHSV_mask/12_3/';
[pPrecisionw7,pAccuracyw7,pSensitivityw7,pF1w7,pRecallw7,windowTP7,windowFN7,windowFP7,pPrecision7,pAccuracy7,pSpecificity7,pSensitivity7,pF1_7,pRecall7 ] = CCL( directory,pDirectory, maxSize, minSize, fillingRatio,false, true,2 );
[pPrecisionw8,pAccuracyw8,pSensitivityw8,pF1w8,pRecallw8,windowTP8,windowFN8,windowFP8,pPrecision8,pAccuracy8,pSpecificity8,pSensitivity8,pF1_8,pRecall8 ] = ReadAndApplyTemplates(directory,pDirectory,templatesDirectory,false ,true,2, maxSize, minSize, fillingRatio);
