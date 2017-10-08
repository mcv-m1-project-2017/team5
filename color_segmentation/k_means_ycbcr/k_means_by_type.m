clear;clc;
addpath(genpath('../..'))
directory = '../../../DataSet/train_split';

% Load file annotations and names
[ files, fileIndex, annotations, signType ] = LoadAllFileAnnotations( directory);

mkdir(strcat(directory, '/maskresults/'));


% Segmentate each type of signal
kForEachType = [2, 2, 2, 2, 2, 2]; % ONLY WORKING FOR K=2
SignTypeIndex = 'A':'F';
for t=6:6
    
    fprintf('Analizing sign type %s\n',SignTypeIndex(t));
    
    % Generate the pixel dataset with all the pixels appearing on signals of type t
    [ pixelDataset ] = GeneratePixelDataset( directory, files(fileIndex(signType==t)), annotations(signType==t) );
    
    % Apply k-means
    pixelDataset=double(pixelDataset);
    K=kForEachType(t);
    [idx,C] = kmeans(pixelDataset(:,[2 3]),K); %,'Start',init_centroids);
    
    
    % Plot the clusters
    % PlotPixelClusters( pixelDataset, idx, [ones(K,1)*120 C] )
    
    % Get the segmentation parameters
    % [ minvalues, maxvalues ] = ComputeSegmentationParameters( C, K, idx, pixelDataset, 1 );
    
    % Segment the images to see the results
    % SegmentImages( strcat(directory,'/train'), files, fileIndex(signType==t), minvalues, maxvalues)
    
    lambdavalues = 0:.5:2;
    precision = zeros(length(lambdavalues),length(lambdavalues));
    accuracy = zeros(length(lambdavalues),length(lambdavalues));
    specifity = zeros(length(lambdavalues),length(lambdavalues));
    sensitivity = zeros(length(lambdavalues),length(lambdavalues));

    i=1;
    for f=fileIndex(signType==t)'
        
        fprintf('%d..',i);
        i=i+1;
        
        % Read file
        im = imread(strcat(directory,'/',files(f).name));
        pixelAnnotation = imread(strcat(directory, '/mask/mask.', files(f).name(1:size(files(f).name,2)-3), 'png'))>0;
        
        im = rgb2ycbcr(im);
        
        for l1=lambdavalues
            for l2=lambdavalues
                
                % Compute range
                [ minvalues, maxvalues ] = ComputeSegmentationParameters( C, K, idx, pixelDataset, [l1 l2]); %l3]);
                
                % Segment image
                pixelCandidates = zeros(size(im,1),size(im,2));
                for k=1:K
                    segmentedimK = ones(size(im,1),size(im,2));
                    for c=1:2
                        segmentedimK = segmentedimK & im(:,:,c+1)>minvalues(k,c) & im(:,:,c+1)<=maxvalues(k,c);
                    end
                    pixelCandidates = pixelCandidates | segmentedimK;
                end
                
                imwrite(pixelCandidates,strcat(directory, '/maskresults/',SignTypeIndex(t),'mask.', files(f).name(1:size(files(f).name,2)-3),num2str(l1),'-',num2str(l2), '.png'));
                
                % Evaluate
                [pixelTP, pixelFP, pixelFN, pixelTN] = PerformanceAccumulationPixel(pixelCandidates, pixelAnnotation);
                if (pixelTP+pixelFP)==0 % To avoid NaN
                    pixelFP = 1;
                end
                
                [pixelPrecision, pixelAccuracy, pixelSpecificity, pixelSensitivity] = PerformanceEvaluationPixel(pixelTP, pixelFP, pixelFN, pixelTN);

                precision(l1==lambdavalues,l2==lambdavalues) = pixelPrecision + precision(l1==lambdavalues,l2==lambdavalues);
                accuracy(l1==lambdavalues,l2==lambdavalues) = pixelAccuracy + accuracy(l1==lambdavalues,l2==lambdavalues);
                specifity(l1==lambdavalues,l2==lambdavalues) = pixelSpecificity + specifity(l1==lambdavalues,l2==lambdavalues);
                sensitivity(l1==lambdavalues,l2==lambdavalues) = pixelSensitivity + sensitivity(l1==lambdavalues,l2==lambdavalues);
                
            end
        end
        
    end
    
    precision = precision / sum(signType==t);
    accuracy = accuracy / sum(signType==t);
    specifity = specifity/ sum(signType==t);
    sensitivity = sensitivity / sum(signType==t);
    
    save(strcat('results',int2str(t),'-',strrep(int2str(clock),' ','')),'precision','accuracy','specifity','sensitivity','lambdavalues','t','K','idx','C');
end


