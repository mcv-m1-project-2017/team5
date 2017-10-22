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

%if exist (strcat(directory, '/YcbCrAndHSV_mask' ), 'dir') ~= 7
%    mkdir(strcat(directory, '/YcbCrAndHSV_mask' ));
%end


for i=1:size(files,1)
    % Read mask
    mask = imread(strcat(directory, files(i).name(1:size(files(i).name,2)-3), 'png'));
    CCL = bwlabeln(mask);

end