clear;clc;
addpath(genpath('../..'))
directory = '../../DataSet/validation_split';
outputdirectory = '../../DataSet/validation_split/masksfinal/';

%directory does not exist
if exist(directory, 'dir') ~= 7
    error('Directory not found');
end
    

% A
minvaluesA =[102.2214  135.3313];
maxvaluesA =[124.9308  178.4536];

%B
minvaluesB =[93.3227  133.0266];
maxvaluesB =[120.7639  184.5449];

%C
minvaluesC =[106.2676  149.7578];
maxvaluesC =[119.2259  178.6840];

%E
minvaluesE =[111.0564  140.5468
            140.5185  102.0170];
maxvaluesE =[125.9229  168.1522
            163.5827  123.5862];
        
% F
minvaluesF =[139.1003   87.8192];
maxvaluesF =[179.8165  121.9042];

K=2;
minvalues = [ mean( [minvaluesA; minvaluesB; minvaluesC; minvaluesE(1,:)] ); %Reds
              mean( [minvaluesF; minvaluesE(2,:)] ) ]; %Blues
          
maxvalues = [ mean( [maxvaluesA; maxvaluesB; maxvaluesC; maxvaluesE(1,:)] ); %Reds
              mean( [maxvaluesF; maxvaluesE(2,:)] ) ]; %Blues


% Load file annotations and names
[ files, fileIndex, annotations, signType ] = LoadAllFileAnnotations( directory);

mkdir(outputdirectory);

precision=0;
accuracy=0;
specifity=0;
sensitivity=0;
F1=0;
Recall=0;

for f=1:length(files)
    fprintf('%d..',f);
    
    % Read file
    im = imread(strcat(directory,'/',files(f).name));
    pixelAnnotation = imread(strcat(directory, '/mask/mask.', files(f).name(1:size(files(f).name,2)-3), 'png'))>0;
    
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
    if (pixelTP+pixelFP)==0
        pixelFP = 1;
    end
    [pixelPrecision, pixelAccuracy, pixelSpecificity, pixelSensitivity,pixelF1,pixelRecall] = PerformanceEvaluationPixel(pixelTP, pixelFP, pixelFN, pixelTN);
    
    precision= pixelPrecision + precision;
    accuracy = pixelAccuracy + accuracy;
    specifity = pixelSpecificity + specifity;
    sensitivity = pixelSensitivity + sensitivity;
    F1          = pixelF1 +F1;
    Recall      = pixelRecall + Recall;
end
precision = precision / length(files);
accuracy = accuracy / length(files);
specifity = specifity/ length(files);
sensitivity = sensitivity / length(files);
F1 = F1 / length(files);
Recall = Recall / length(files);
fprintf('\n');