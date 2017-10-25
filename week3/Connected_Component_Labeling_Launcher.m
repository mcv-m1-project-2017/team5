clear;clc; close all;
addpath(genpath('../..'))
%The best algorithm was 4_3 ( Opening + Hole filling with sphere)
directory = '../DataSet/train/validation_split/YcbCrAndHSV_mask/4_3/';
%directory does not exist
if exist(directory, 'dir') ~= 7
    error('Directory not found');
end

files = ListFiles(directory);
if size(files,1) == 0
    error('Directory is empty');
end

if exist (strcat(directory, 'mat' ), 'dir') ~= 7
    mkdir(strcat(directory, 'mat' ));
end
%Get values from dataset with week1 function
[sFrequency ,maxSize ,minSize ,formFactor ,fillingRatio,sFrequencyPercent] = SignalCharacteristics('../DataSet/train/');

%Compute values averages
totMinSize      = 0;
totMaxSize      = 0;
totFillingRatio = 0;
for n=1:size(maxSize,2)
    totMinSize      = totMinSize + minSize(n);
    totMaxSize      = totMaxSize + maxSize(n);
    totFillingRatio = totFillingRatio + fillingRatio(n);
end
totFillingRatio = totFillingRatio / size(maxSize,2);
avgTotMinSize   = totMinSize      / size(maxSize,2);
avgTotMaxSize   = totMaxSize      / size(maxSize,2);

for i=1:size(files,1)
    % Read mask
    mask = imread(strcat(directory, files(i).name(1:size(files(i).name,2)-3), 'png'));
    CCL  = bwconncomp ( mask );
    CC   = regionprops( CCL,'basic' );
    figure;
    imshow(mask);
    hold on
    %Delete areas that are greater than area average or are less than area average
    Signals = CC([CC.Area] >= avgTotMinSize & [CC.Area] <= avgTotMaxSize);
    %Show areas in image
    for n=1:size(Signals,1)
        rectangle('Position',Signals(n).BoundingBox,'EdgeColor','g','LineWidth',2)
    end
end