clear;
addpath(genpath('..'))
[sFrequency ,maxSize ,minSize ,formFactor ,fillingRatio,sFrequencyPercent] = SignalCharacteristics('../Dataset/train');
SplitDataset( sFrequency ,maxSize ,minSize ,formFactor ,fillingRatio ,'../Dataset/train' )