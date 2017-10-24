clear;
addpath(genpath('..'))
[sFrequency ,maxSize ,minSize ,formFactor ,fillingRatio,sFrequencyPercent] = SignalCharacteristics('../DataSet/train');
SplitDataset( sFrequency ,maxSize ,minSize ,formFactor ,fillingRatio ,'../DataSet/train' )