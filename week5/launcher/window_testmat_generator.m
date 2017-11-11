%% Parameters
clear;clc;
name_for_the_execution = 'Chanfer10d'

% training_directory = '../Dataset/train_split';
input_directory = '../Dataset/test';
mask_directory = '../Results/test/MyVersion-T4Disk6-20171029185311';%'../Results/train_split/MyVersion-Disk6-2017102817133';
write_output_images = 0;
output_directory = '../WindowResults/test/MyVersion-T4Disk6-20171029185311'; %'../WindowResults/train_split/MyVersion-Disk6-2017102817133';

% Add needed paths
addpath(genpath('windows'))
addpath(genpath('dataset_analysis'))
addpath(genpath('evaluation'))

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% CONSTANTS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
filling_ratio = .45;
jump_interval = 4;
window_w=[40 140];
window_h=[40 140];
joining_threshold = .8;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Test begin
output_directory = strcat(output_directory,'/',name_for_the_execution,'-',strrep(int2str(clock),' ',''),'/');

% Load file annotations and names
files = ListFiles(strcat(input_directory));

mkdir(output_directory);

windowCandidates = [];
for f=1:length(files)
    fprintf('%d..',f);
    
    % Read file
    mask = imread(strcat(mask_directory, '/mask.', files(f).name(1:size(files(f).name,2)-3), 'png'))>0;
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %                   FILL THIS WITH THE TESTING CODE                       %
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    [ detections ] = Chanfer( mask);   
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Output: windowCandidates
    save(strcat(output_directory,files(f).name(1:size(files(f).name,2)-3),'mat'),'windowCandidates');
end