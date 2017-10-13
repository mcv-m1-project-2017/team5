clear;clc; close all;
addpath(genpath('../..'))
directory = '../DataSet/train/validation_split';
%directory does not exist
if exist(directory, 'dir') ~= 7
    error('Directory not found');
end
files = ListFiles(directory);
if size(files,1) == 0
    error('Directory is empty');
end

if exist (strcat(directory, '/YcbCrAndHSV_mask' ), 'dir') ~= 7
    mkdir(strcat(directory, '/YcbCrAndHSV_mask' ));
end

[masks, txf] = YcbCrAndHSV(directory, files);
for i=1:length(files)
    maskpath = strcat(directory, '/YcbCrAndHSV_mask/',files(i).name(1:size(files(i).name,2)-3), 'png');
    mask = cell2mat(masks(i));
    imwrite(mask,maskpath );
end



