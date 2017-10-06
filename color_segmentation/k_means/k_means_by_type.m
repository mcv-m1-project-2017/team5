clear;clc; 
addpath(genpath('..'))
directory = '../../DataSet';

% Load file annotations and names
[ files, fileIndex, annotations, signType ] = LoadAllFileAnnotations( strcat(directory ,'/train'));

% Segmentate each type of signal
kForEachType = [3, 2, 2, 2, 2, 3];
for t=1:6
    
    % Generate the pixel dataset with all the pixels appearing on signals of type t
    [ pixelDataset ] = GeneratePixelDataset( strcat(directory,'/train'), files(fileIndex(signType==t)), annotations(signType==t) );
    
    % Apply k-means    
    pixelDataset=double(pixelDataset);
    K=kForEachType(t);
    [idx,C] = kmeans(pixelDataset,K); %,'Start',init_centroids);
    
    % Plot the clusters
    PlotPixelClusters( pixelDataset, idx, C )

    % Get the segmentation parameters
    [ minvalues, maxvalues ] = ComputeSegmentationParameters( C, K, idx, pixelDataset, 1 );
    
    % Segment the images to see the results
    SegmentImages( strcat(directory,'/train'), files, fileIndex(signType==t), minvalues, maxvalues)
end


