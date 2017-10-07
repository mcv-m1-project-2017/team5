clear;clc; 
addpath(genpath('../..'))
directory = '../../../DataSet';

% Load file annotations and names
[ files, fileIndex, annotations, signType ] = LoadAllFileAnnotations( strcat(directory ,'/train'));

% Segmentate each type of signal
kForEachType = [3, 2, 2, 2, 2, 3];
SignTypeIndex = 'A':'F';
for t=5:6
    
    fprintf('Analizing sign type %s\n',SignTypeIndex(t));
    
    % Generate the pixel dataset with all the pixels appearing on signals of type t
    [ pixelDataset ] = GeneratePixelDataset( strcat(directory,'/train'), files(fileIndex(signType==t)), annotations(signType==t) );
    
    % Apply k-means
    pixelDataset=double(pixelDataset);
    K=kForEachType(t);
    [idx,C] = kmeans(pixelDataset(:,[2 3]),K); %,'Start',init_centroids);

    
    % Plot the clusters
    PlotPixelClusters( pixelDataset, idx, [ones(K,1)*120 C] )

    % Get the segmentation parameters
    [ minvalues, maxvalues ] = ComputeSegmentationParameters( C, K, idx, pixelDataset, 1 );
    
    % Segment the images to see the results
    SegmentImages( strcat(directory,'/train'), files, fileIndex(signType==t), minvalues, maxvalues)
end


