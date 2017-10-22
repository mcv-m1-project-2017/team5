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

if exist (strcat(directory, '/YcbCrAndHSV_mask' ), 'dir') ~= 7
    mkdir(strcat(directory, '/YcbCrAndHSV_mask' ));
end
[masks, txf] = YcbCrAndHSV(directory, files);
cross = [0,1,0;1,1,1;0,1,0];
left  = [1,1,0;1,0,0;1,0,0];
seList = [strel('line'     ,1,100 ) ...
         ,strel('cube'     ,4     ) ...
         ,strel('sphere'   ,6     ) ...
         ,strel('diamond'  ,5     ) ...
         ,strel('square'   ,6     ) ...
         ,strel('arbitrary',cross ) ...
         ,strel('arbitrary',left  )];
k = 8;
pPrecision   = zeros(k,size(seList,2));
pAccuracy    = zeros(k,size(seList,2));
pF1          = zeros(k,size(seList,2));
pRecall      = zeros(k,size(seList,2));
pSpecificity = zeros(k,size(seList,2));
pSensitivity = zeros(k,size(seList,2));
TP           = zeros(k,size(seList,2));
FP           = zeros(k,size(seList,2));
TN           = zeros(k,size(seList,2));
FN           = zeros(k,size(seList,2));
time         = 0;
for x=1:k
    for i=1:length(seList)
        se = seList(i);
        if exist (strcat(directory, '/YcbCrAndHSV_mask/',num2str(x),'_',num2str(i)), 'dir') ~= 7
            mkdir(strcat(directory, '/YcbCrAndHSV_mask/',num2str(x),'_',num2str(i)));
        end
        pixelTP=0; pixelFN=0; pixelFP=0; pixelTN=0;
        for j=1:length(files)
            tic; % Start timer
            mask = cell2mat(masks(j));
            switch(x)
                case 1
                    %Calculate erosion
                    FinalMask = imerode (mask,se);
                case 2
                    %Calculate dilate
                    dilateMask = imdilate(mask,se);
                case 3
                    %Calculate Opening
                    erodeMask = imerode (mask,se);
                    FinalMask = imdilate(erodeMask,se);
                case 4
                    %Calculate Opening with hole filling
                    erodeMask  = imerode (mask,se);
                    dilateMask = imdilate(erodeMask,se);
                    %Hole filling
                    FinalMask  = imfill(dilateMask,'holes');
                case 5
                    %Calculate Closing
                    dilateMask = imdilate(mask,se);
                    FinalMask  = imerode (dilateMask,se);
                case 6
                    %Calculate Closing with hole filling
                    dilateMask = imdilate(mask,se);
                    erodeMask  = imerode (dilateMask,se);
                    %Hole filling
                    FinalMask  = imfill(erodeMask,'holes');
                case 7
                    %Calculate tophat
                    FinalMask = imtophat(mask,se);
                case 8
                    %Calculate tophat with hole filling
                    topHatMask = imtophat(mask,se);
                    %Hole filling
                    FinalMask  = imfill(topHatMask,'holes');
                otherwise
                    error('Invalid bound stament');
            end
            %Create path
            maskpath = strcat(directory, '/YcbCrAndHSV_mask/',num2str(x),'_',num2str(i),'/mask.',files(j).name(1:size(files(j).name,2)-3), 'png');
            imwrite(FinalMask,maskpath );
            %Read current mask
            oriMask = imread(strcat(directory, '/mask/mask.',files(j).name(1:size(files(j).name,2)-3), 'png'));
            
            % subtract generated mask to ground truth to find the differences
            % each number represents a diferent case
            [localPixelTP, localPixelFP, localPixelFN, localPixelTN] = PerformanceAccumulationPixel(FinalMask, oriMask);
            pixelTP = pixelTP + localPixelTP;
            pixelFP = pixelFP + localPixelFP;
            pixelFN = pixelFN + localPixelFN;
            pixelTN = pixelTN + localPixelTN;
            % stop timer and store required time to create the current mask
            time =  time + toc; 
        end
        TP(x,i) = pixelTP;
        FP(x,i) = pixelFP;
        TN(x,i) = pixelTN;
        FN(x,i) = pixelFN;
        % calculate performance measures
        pPrecision  (x,i) = pixelTP    / (pixelTP+pixelFP);
        pAccuracy   (x,i) = (pixelTP+pixelTN) / (pixelTP+pixelFP+pixelFN+pixelTN);
        pSpecificity(x,i) = pixelTN    / (pixelTN+pixelFP);
        pSensitivity(x,i) = pixelTP    / (pixelTP+pixelFN);
        pF1         (x,i) = 2*(pixelTP)/(2*pixelTP+pixelFN+pixelFP);
        pRecall     (x,i) = pixelTP    / (pixelTP+pixelFN);
    end
end
% Average time per frame
txf = txf + time / ( length(files) * k * length(seList) ) ; 
