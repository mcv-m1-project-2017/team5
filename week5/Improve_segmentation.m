clear;clc; close all;
addpath(genpath('../..'))
directory = '../DataSet/train/validation_split';
%directory does not exist
if exist(directory, 'dir') ~= 7
    error('Directory not found');
end
files = ListFiles(directory);
if size(files,1) == 0
    error('Directory is empty');
end

if exist (strcat(directory, '/MeanShift_mask_week5' ), 'dir') ~= 7
    mkdir(strcat(directory, '/MeanShift_mask_week5' ));
end
if exist( strcat(directory, '/MeanShift_equalize_mask_week5' ), 'dir') ~= 7
    mkdir(strcat(directory, '/MeanShift_equalize_mask_week5' ));
end

pPrecision   = 0;
pAccuracy    = 0;
pF1          = 0;
pRecall      = 0;
pSpecificity = 0;
pSensitivity = 0;
pixelTP      = 0;
pixelFP      = 0;
pixelTN      = 0;
pixelFN      = 0;
e = 0;
for i=1:size(files,1)
    t = cputime;
    % Read image
    im       = imread(  strcat(directory, '/'                              , files(i).name(1:size(files(i).name,2)-3), 'jpg'));
    path     =        strcat(directory, '/MeanShift_mask_week5/'         , files(i).name(1:size(files(i).name,2)-3), 'png');
    % convert HSV colorspace and watershed
    imHSV     = rgb2hsv(im);
    DL        = watershed(imHSV);
    DLH       = DL(:,:,1)>=0.5 & DL(:,:,1)<=0.8;
    DLV       = DL(:,:,3)>=55000 & DL(:,:,3)<=58000;
    FinalMask = DLH | DLV;
    oriMask = imread(strcat(directory, '/mask/mask.',files(i).name(1:size(files(i).name,2)-3), 'png'));
    % subtract generated mask to ground truth to find the differences
    % each number represents a diferent case
    [localPixelTP, localPixelFP, localPixelFN, localPixelTN] = PerformanceAccumulationPixel(FinalMask, oriMask);
    pixelTP = pixelTP + localPixelTP;
    pixelFP = pixelFP + localPixelFP;
    pixelFN = pixelFN + localPixelFN;
    pixelTN = pixelTN + localPixelTN;
    imwrite(FinalMask,path)
    e = e + cputime-t;
end
% calculate performance measures
pPrecision   = pixelTP    / (pixelTP+pixelFP);
pAccuracy    = (pixelTP+pixelTN) / (pixelTP+pixelFP+pixelFN+pixelTN);
pSpecificity = pixelTN    / (pixelTN+pixelFP);
pSensitivity = pixelTP    / (pixelTP+pixelFN);
pF1          = 2*(pixelTP)/(2*pixelTP+pixelFN+pixelFP);
pRecall      = pixelTP    / (pixelTP+pixelFN);
%Time average
e / size(files,1);