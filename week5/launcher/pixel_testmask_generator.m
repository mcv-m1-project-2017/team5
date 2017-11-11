%% Parameters
clear;clc;
name_for_the_execution = 'MyVersion-T4Disk6'
% training_directory = '../../Dataset/train_split';
%validation_split
input_directory = '../Dataset/test';
write_output_images = 1;
output_directory = '../Results/test';

% Add needed paths
addpath(genpath('color_segmentation'))
addpath(genpath('morphology'))
addpath(genpath('evaluation'))

%% Test begin
output_directory = strcat(output_directory,'/',name_for_the_execution,'-',strrep(int2str(clock),' ',''),'/');

% Load file annotations and names
files = ListFiles(strcat(input_directory));

mkdir(output_directory);

for f=1:length(files) 
    fprintf('%d..',f);
    
    % Read file
    im = imread(strcat(input_directory,'/',files(f).name));
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %                   FILL THIS WITH THE TESTING CODE                       %
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    mask=colorSegmentationT4W2(im);
    FinalMask = morphologyMyVersion(mask);
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Output: FinalMask
    
    if write_output_images
        imwrite(FinalMask,strcat(output_directory,'mask.', files(f).name(1:size(files(f).name,2)-3), 'png'));
    end
end