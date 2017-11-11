function [pPrecisionw,pAccuracyw,pSensitivityw,pF1w,pRecallw,windowTP,windowFN,windowFP,pPrecision,pAccuracy,pSpecificity,pSensitivity,pF1,pRecall] = CCL(directory,performanceDirectory,maxSize,minSize,fillingRatio,showImages, performance, method)
% INPUT: 'directory' directory of the files provided for training
%        'performanceDirectory' directory to test
%        'maxSize' Max signals size
%        'minSize' Min signals size
%        'fillingRatio' Filling ratio of week1
%        'showImages' boolean if you want to show mask with CCL
    %directory does not exist
    if exist(directory, 'dir') ~= 7
        error('Directory not found');
    end

    files = ListFiles(directory);
    if size(files,1) == 0
        error('Directory is empty');
    end

    if exist (strcat(directory, 'gt' ), 'dir') ~= 7
        mkdir(strcat(directory, 'gt' ));
    end
    
    if exist (strcat(directory, 'mat_',int2str(method) ), 'dir') ~= 7
        mkdir(strcat(directory, 'mat_',int2str(method) ));
    end

    %Compute values averages
    totMinSize      = 0;
    totMaxSize      = 0;
    totFillingRatio = 0;
    for n=1:size(maxSize,2)
        totMinSize      = totMinSize + minSize(n);
        totMaxSize      = totMaxSize + maxSize(n);
        totFillingRatio = totFillingRatio + fillingRatio(n);
    end
    totFillingRatio = totFillingRatio / size(fillingRatio,2);
    avgTotMinSize   = totMinSize      / size(minSize     ,2);
    avgTotMaxSize   = totMaxSize      / size(maxSize     ,2);
    
    pixelTP=0; pixelFN=0; pixelFP=0; pixelTN=0;
    windowTP=0; windowFN=0; windowFP=0;
    pPrecisionw = 0;pAccuracyw = 0; pSensitivityw = 0;pF1w = 0;pRecallw = 0;
    time=0;
    for i=1:size(files,1)
        tic; % Start timer
        % Read mask
        mask   = imread(strcat(directory, files(i).name(1:size(files(i).name,2)-3), 'png'));
        switch(method)
            case 1
                [windowCandidates] = getCC(mask, avgTotMinSize, avgTotMaxSize, totFillingRatio);
            case 2
                [windowCandidates] = getCCMultiFilterWithoutImage(mask);
            otherwise
                error('Method is not valid');
        end
        save([strcat(directory,'mat_',int2str(method),'/',files(i).name(1:size(files(i).name,2)-3), 'mat')],'windowCandidates');
        if showImages
            figure;
            imshow(mask);
            hold on
            %Show areas in image
            for n=1:size(windowCandidates,2)
                rectangle('Position',windowCandidates(:,n).BoundingBox,'EdgeColor','g','LineWidth',2)
            end
        end
        if performance
            % Accumulate pixel performance of the current image %%%%%%%%%%%%%%%%%
            pixelAnnotation = imread(strcat(performanceDirectory, '/mask/', files(i).name(1:size(files(i).name,2)-3), 'png'))>0;
            [localPixelTP, localPixelFP, localPixelFN, localPixelTN] = PerformanceAccumulationPixel(mask, pixelAnnotation);
            pixelTP = pixelTP + localPixelTP;
            pixelFP = pixelFP + localPixelFP;
            pixelFN = pixelFN + localPixelFN;
            pixelTN = pixelTN + localPixelTN;
            % Accumulate object performance of the current image %%%%%%%%%%%%%%%%
            windowAnnotations = LoadAnnotations(strcat(performanceDirectory, '/gt/gt.', files(i).name(6:size(files(i).name,2)-3), 'txt'));
            [localWindowTP, localWindowFN, localWindowFP] = PerformanceAccumulationWindow(windowCandidates, windowAnnotations);
            windowTP = windowTP + localWindowTP;
            windowFN = windowFN + localWindowFN;
            windowFP = windowFP + localWindowFP;
            time =  time + toc; 
        end
    end
    if performance
        pPrecision   = pixelTP    / (pixelTP+pixelFP);
        pAccuracy    = (pixelTP+pixelTN) / (pixelTP+pixelFP+pixelFN+pixelTN);
        pSpecificity = pixelTN    / (pixelTN+pixelFP);
        pSensitivity = pixelTP    / (pixelTP+pixelFN);
        pF1          = 2*(pixelTP)/(2*pixelTP+pixelFN+pixelFP);
        pRecall      = pixelTP    / (pixelTP+pixelFN);

        pPrecisionw   = windowTP    / (windowTP+windowFP);
        pAccuracyw    = windowTP / (windowTP+windowFP+windowFN);
        pSensitivityw = windowTP    / (windowTP+windowFN);
        pF1w          = 2*(windowTP)/(2*windowTP+windowFN+windowFP);
        pRecallw      = windowTP    / (windowTP+windowFN);
        % Average time per frame
        txf = time / length(files) ; 
    end
end