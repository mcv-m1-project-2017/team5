clear;clc;
addpath(genpath('../..'))
directory = '../../../DataSet/train_split';
validationdirectory = '../../../DataSet/validation_split';
outputdirectory = '../../../DataSet/validation_split/masksfinalauto/';

% Load file annotations and names
[ files, fileIndex, annotations, signType ] = LoadAllFileAnnotations( directory);

mkdir(strcat(directory, '/maskresults/'));


% Segmentate each type of signal
kForEachType = [2, 2, 2, 2, 2, 2]; % ONLY WORKING FOR K=2
SignTypeIndex = 'A':'F';
bestRangesPerType = [];
for t=1:6
    
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
    
    lambdavalues = 0:.5:1.5;
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
                
                % imwrite(pixelCandidates,strcat(directory, '/maskresults/',SignTypeIndex(t),'mask.', files(f).name(1:size(files(f).name,2)-3),num2str(l1),'-',num2str(l2), '.png'));
                
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
    
    % Select best lambdas
    geom_mean = nthroot(precision.*specifity.*sensitivity,3);
    [geom_mean,bestl1] = max(geom_mean);
    [geom_mean, bestl2] = max(geom_mean);
    bestl1 = bestl1(bestl2);
    fprintf('\nBest lambdas l1=%.2f | l2=%.2f with geom. mean %f\n', ...
        lambdavalues(bestl1), lambdavalues(bestl2),geom_mean); 
    
    % Compute best range
    [ minvalues, maxvalues ] = ComputeSegmentationParameters( C, K, idx, ...
        pixelDataset, [lambdavalues(bestl1) lambdavalues(bestl2)]);
    
    % Clean unused ranges
    samerange = logical(prod(minvalues==maxvalues,2));
    minvalues = minvalues(~samerange,:);
    maxvalues = maxvalues(~samerange,:);

    bestRangesPerType = [bestRangesPerType; struct('minvalues',minvalues,'maxvalues',maxvalues,'geom_mean',geom_mean)];
    save(num2str(t));
%     save(strcat('results',int2str(t),'-',strrep(int2str(clock),' ','')),'precision','accuracy','specifity','sensitivity','lambdavalues','t','K','idx','C');
end
%%
% Fusion ranges
minvalues = zeros(2, size(bestRangesPerType(1).minvalues,2));
maxvalues = zeros(2, size(bestRangesPerType(1).minvalues,2));
reds=0;
blues=0;
for i=1:length(bestRangesPerType)
    auxminvalues = bestRangesPerType(i).minvalues;
    auxmaxvalues = bestRangesPerType(i).maxvalues;
    auxgeom_mean = bestRangesPerType(i).geom_mean;
    
    for j=1:size(auxminvalues,1)
        if auxminvalues(j,2)>120 %red
            'r'
            reds=reds+auxgeom_mean;
            minvalues(1,:)=minvalues(1,:)+auxgeom_mean*auxminvalues(j,:);
            maxvalues(1,:)=maxvalues(1,:)+auxgeom_mean*auxmaxvalues(j,:);
        else %blue
            'b'
            blues=blues+auxgeom_mean;
            minvalues(2,:)=minvalues(2,:)+auxgeom_mean*auxminvalues(j,:);
            maxvalues(1,:)=maxvalues(1,:)+auxgeom_mean*auxmaxvalues(j,:);
        end
    end
end
minvalues(1,:) = minvalues(1,:) / reds; 
minvalues(2,:) = minvalues(2,:) / blues; 
maxvalues(1,:) = maxvalues(1,:) / reds; 
maxvalues(2,:) = maxvalues(2,:) / blues; 

save('presegment');
%%
[ files, fileIndex, annotations, signType ] = LoadAllFileAnnotations( validationdirectory);


mkdir(outputdirectory);

precision=0;
accuracy=0;
specifity=0;
sensitivity=0;
tp=0;
fp=0;
fn=0;

for f=1:length(files)
    fprintf('%d..',f);
    
    % Read file
    im = imread(strcat(validationdirectory,'/',files(f).name));
    pixelAnnotation = imread(strcat(validationdirectory, '/mask/mask.', files(f).name(1:size(files(f).name,2)-3), 'png'))>0;
    
    im = rgb2ycbcr(im);
    
    % Segment
    pixelCandidates = zeros(size(im,1),size(im,2));
    for k=1:K
        segmentedimK = ones(size(im,1),size(im,2));
        for c=1:2
            segmentedimK = segmentedimK & im(:,:,c+1)>minvalues(k,c) & im(:,:,c+1)<=maxvalues(k,c);
        end
        pixelCandidates = pixelCandidates | segmentedimK;
    end
    imwrite(pixelCandidates,strcat(outputdirectory,'mask.', files(f).name(1:size(files(f).name,2)-3), 'png'));
    
    %Evaluate
    [pixelTP, pixelFP, pixelFN, pixelTN] = PerformanceAccumulationPixel(pixelCandidates, pixelAnnotation);
    tp=tp+pixelTP;
    fp=fp+pixelFP;
    fn=fn+pixelFN;
    if (pixelTP+pixelFP)==0
        pixelFP = 1;
    end
    [pixelPrecision, pixelAccuracy, pixelSpecificity, pixelSensitivity] = PerformanceEvaluationPixel(pixelTP, pixelFP, pixelFN, pixelTN);
    
    precision= pixelPrecision + precision;
    accuracy = pixelAccuracy + accuracy;
    specifity = pixelSpecificity + specifity;
    sensitivity = pixelSensitivity + sensitivity;
end
fprintf('\n');
tp = tp / length(files)
fp = fp / length(files)
fn = fn / length(files)
precision = precision / length(files)
accuracy = accuracy / length(files)
specifity = specifity/ length(files)
sensitivity = sensitivity / length(files)
