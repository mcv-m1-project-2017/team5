clear;clc; close all;
addpath(genpath('../..'))
directory = '../../../DataSet';

% Load file annotations and names
[ files, fileIndex, annotations, signType ] = LoadAllFileAnnotations( strcat(directory ,'/train'));

% Generate the pixel dataset with all the pixels appearing on signals
% [ pixelDataset ] = GeneratePixelDataset( strcat(directory,'/train'), files(fileIndex), annotations );
% save('pixelDatasetFull','pixelDataset');
load('pixelDatasetFull');

% Apply K-means
pixelDataset=double(pixelDataset);
K=4;
[idx,C] = kmeans(pixelDataset,K);

% Plot the clusters
PlotPixelClusters( pixelDataset, idx, C )

% Get the segmentation parameters
[ minvalues, maxvalues ] = ComputeSegmentationParameters( C, K, idx, pixelDataset, 1 );

% Segment the images to see the results
SegmentImages( strcat(directory,'/train'), files, fileIndex, minvalues, maxvalues)
