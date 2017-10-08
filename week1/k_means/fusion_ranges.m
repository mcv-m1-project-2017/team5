clear;clc;
addpath(genpath('../..'))
directory = '../../../DataSet/validation_split';
outputdirectory = '../../../DataSet/validation_split/masksfinalrgb/';

% A
minvaluesA =[36.7013   21.6586   16.5186];
maxvaluesA =[116.5352   57.7542   50.5392];

%C
minvaluesC =[65.1423   16.1873    9.0500];
maxvaluesC =[145.6106   70.5432   64.9889];

%D
minvaluesD =[20.8195   40.3323   49.1415];
maxvaluesD =[70.0966  100.7865  156.8609];

%E
minvaluesE =[-0.2097   35.2204   74.0284;
            38.2713   16.0125   13.8200];
maxvaluesE =[63.9962   86.3727  138.6699;
            113.4857   44.2830   46.1780];
        
% F
minvaluesF =[16.5922   33.8015   48.1827];
maxvaluesF =[58.7403   82.4327  126.4151];

K=2;
minvalues = [ mean( [minvaluesA; minvaluesC; minvaluesE(2,:)] ); %Reds
              mean( [minvaluesD; minvaluesF; minvaluesE(1,:)] ) ]; %Blues
          
maxvalues = [ mean( [maxvaluesA;  maxvaluesC; maxvaluesE(2,:)] ); %Reds
              mean( [minvaluesD; maxvaluesF; maxvaluesE(1,:)] ) ]; %Blues


% Load file annotations and names
[ files, fileIndex, annotations, signType ] = LoadAllFileAnnotations( directory);

mkdir(outputdirectory);

precision=0;
accuracy=0;
specifity=0;
sensitivity=0;

for f=1:length(files)
    fprintf('%d..',f);
    
    % Read file
    im = imread(strcat(directory,'/',files(f).name));
    pixelAnnotation = imread(strcat(directory, '/mask/mask.', files(f).name(1:size(files(f).name,2)-3), 'png'))>0;
    
    
    % Segment
    pixelCandidates = zeros(size(im,1),size(im,2));
    for k=1:K
        segmentedimK = ones(size(im,1),size(im,2));
        for c=1:3
            segmentedimK = segmentedimK & im(:,:,c)>minvalues(k,c) & im(:,:,c)<=maxvalues(k,c);
        end
        pixelCandidates = pixelCandidates | segmentedimK;
    end
    imwrite(pixelCandidates,strcat(outputdirectory,'mask.', files(f).name(1:size(files(f).name,2)-3), 'png'));
    
    %Evaluate
    [pixelTP, pixelFP, pixelFN, pixelTN] = PerformanceAccumulationPixel(pixelCandidates, pixelAnnotation);
    if (pixelTP+pixelFP)==0
        pixelFP = 1;
    end
    [pixelPrecision, pixelAccuracy, pixelSpecificity, pixelSensitivity] = PerformanceEvaluationPixel(pixelTP, pixelFP, pixelFN, pixelTN);
    
    precision= pixelPrecision + precision;
    accuracy = pixelAccuracy + accuracy;
    specifity = pixelSpecificity + specifity;
    sensitivity = pixelSensitivity + sensitivity;
end
precision = precision / length(files);
accuracy = accuracy / length(files);
specifity = specifity/ length(files);
sensitivity = sensitivity / length(files);
fprintf('\n');