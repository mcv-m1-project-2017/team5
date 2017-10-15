clear;clc; close all;
addpath(genpath('../..'))
train_path = '../../../DataSet/train_split';
validation_path = '../../../DataSet/validation_split';
output_path = '../../../DataSet/validation_split/masks_hist_back_proj';
nbins = [30 100 100];
cspace = 'hsv';

[ files, fileIndex, annotations, signType ] = LoadAllFileAnnotations( train_path );

SignTypeIndexText = {'ABC','DF','E'};
SignTypeIndex = {[1 2 3],[4 6],5};
histograms = cell(length(SignTypeIndex),1);
edges = cell(length(SignTypeIndex),1);

for t=1:length(SignTypeIndex) % for each type of signal
    % Generate pixel dataset
    fprintf('Analizing sign type %s\n',SignTypeIndexText{t});
    signsOfTypeT = ismember(signType,SignTypeIndex{t});
    [ pixelDataset ] = GeneratePixelDataset( train_path, files(fileIndex(signsOfTypeT)), annotations(signsOfTypeT) );
    
    % Compute histogram
    [histogram_t,edges_t] = GenerateHistogram( pixelDataset, nbins(t), cspace);
    
    histograms{t}=histogram_t;
    edges{t}=edges_t;
end

% save('A');
% 
% load('A');

% Segment images
precision=0;
accuracy=0;
specifity=0;
sensitivity=0;
tp=0;
fp=0;
fn=0;
[ files, fileIndex, annotations, signType ] = LoadAllFileAnnotations( validation_path );
mkdir(output_path);

for f = 1:length(files) % fileIndex(ismember(signType,[1 2 3]))' 
    fprintf('%d..',f);
    
    % Read file
    im = imread(strcat(validation_path,'/',files(f).name));
    pixelAnnotation = imread(strcat(validation_path, '/mask/mask.', files(f).name(1:size(files(f).name,2)-3), 'png'))>0;
    
    % Segment
    thresholds = ones(length(SignTypeIndex),1)*0.5;
    pixelCandidates = SegmentImage(im,histograms,edges,thresholds,cspace);
    imwrite(pixelCandidates,strcat(output_path,'/mask.', files(f).name(1:size(files(f).name,2)-3), 'png'));
    
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
tp = tp / length(files);
fp = fp / length(files);
fn = fn / length(files);
precision = precision / length(files);
accuracy = accuracy / length(files);
specifity = specifity/ length(files);
sensitivity = sensitivity / length(files);
fprintf('\n');