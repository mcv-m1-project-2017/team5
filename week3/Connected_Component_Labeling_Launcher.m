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

[sFrequency ,maxSize ,minSize ,formFactor ,fillingRatio,sFrequencyPercent] = SignalCharacteristics('../Dataset/train/');


for i=1:size(files,1)
    % Read mask
    mask  = imread(strcat(directory, files(i).name(1:size(files(i).name,2)-3), 'png'));
    figure;
    imshow(mask);
    CC      = bwconncomp ( mask );
    allAreas = regionprops( CC,'basic' );
    hold on;
    %Show all areas in image
    for n=1:size(allAreas,1)
        rectangle('Position',allAreas(n).BoundingBox,'EdgeColor','g','LineWidth',2)
    end
    areas=find([allAreas.Area]<0.004);
    %Show areas that are less than area average
    for n=1:size(areas,2)
        rectangle('Position',allAreas(areas(n)).BoundingBox,'EdgeColor','r','LineWidth',2)
    end
    for n=1:size(areas,2)
        d=round(allAreas(areas(n)).BoundingBox);
        mask(d(2):d(2)+d(4),d(1):d(1)+d(3))=0;
    end
end