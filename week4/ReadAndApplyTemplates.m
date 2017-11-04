function [ pPrecisionw,pAccuracyw,pSensitivityw,pF1w,pRecallw,windowTP,windowFN,windowFP ] = ReadAndApplyTemplates( directory,performanceDirectory,templatesDirectory,showImages,performance,method )
% INPUT: 'directory' directory of the files provided for training
%        'performanceDirectory' directory to test
%        'showImages' boolean if you want to show mask with CCL
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
    
    if exist (strcat(directory, 'mat_',int2str(method),'_Templates' ), 'dir') ~= 7
        mkdir(strcat(directory, 'mat_',int2str(method),'_Templates' ));
    end
    
    %Read All templates
    templates_files = ListFiles(templatesDirectory);
    templates = zeros(250,250,size(templates_files,1));
    for i=1:size(templates_files,1)
        currentTemplate = imread(strcat(templatesDirectory,templates_files(i).name(1:size(templates_files(i).name,2)-3),'png'));
        templates(:,:,i) = currentTemplate;
    end
    
    pixelTP=0; pixelFN=0; pixelFP=0; pixelTN=0;
    windowTP=0; windowFN=0; windowFP=0;
    pPrecisionw = 0;pAccuracyw = 0; pSensitivityw = 0;pF1w = 0;pRecallw = 0;
    time=0;
    for i=1:size(files,1)
        tic; % Start timer
        % Read mask
        mask   = imread(strcat(directory, files(i).name(1:size(files(i).name,2)-3), 'png'));
        % Read windowsCandidates
        windowCandidates = load(strcat(directory,'/mat_',int2str(method),'/', files(i).name(1:size(files(i).name,2)-3), 'mat'),'windowCandidates');
        % Apply Templates
        bIsWindow = false(1,size(windowCandidates,2));
        for j=1:size(windowCandidates,2)
            mask_signal = mask( round( windowCandidates(j).windowCandidates.y :... 
                                       windowCandidates(j).windowCandidates.y  ...
                                     + windowCandidates(j).windowCandidates.h) ...
                              , round( windowCandidates(j).windowCandidates.x :...
                                       windowCandidates(j).windowCandidates.x  ...
                                     + windowCandidates(j).windowCandidates.w));
            mask_signal = imresize(mask_signal, [250 250]);
            for k=1:size(templates,3)
                if mask_signal | templates(:,:,k)
                    bIsWindow(j)=true;
                end
            end
        end
        finalWindowCandidates = [];
        for j=1:size(windowCandidates,2)
            if(bIsWindow(j))
                finalWindowCandidates = [finalWindowCandidates,windowCandidates(j)];
            end
        end
        windowCandidates = finalWindowCandidates;
        % Save new windowsCandidates
        save([strcat(directory,'mat_',int2str(method),'_Templates/',files(i).name(1:size(files(i).name,2)-3), 'mat')],'windowCandidates');
        if showImages
            figure;
            imshow(mask);
            hold on
            %Show areas in image
            for n=1:size(windowCandidates,2)
                rectangle('Position',windowCandidates(n).windowCandidates.BoundingBox,'EdgeColor','g','LineWidth',2)
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
            for j=1:size(windowCandidates,2)
                [localWindowTP, localWindowFN, localWindowFP] = PerformanceAccumulationWindow(windowCandidates(j).windowCandidates, windowAnnotations);
                windowTP = windowTP + localWindowTP;
                windowFN = windowFN + localWindowFN;
                windowFP = windowFP + localWindowFP;
            end
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

