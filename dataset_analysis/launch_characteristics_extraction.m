clear;
addpath(genpath('..'))
[sFrequency ,maxSize ,minSize ,formFactor ,fillingRatio] = SignalCharacteristics('./train');
SplitDataset( sFrequency ,maxSize ,minSize ,formFactor ,fillingRatio ,'./train' )


