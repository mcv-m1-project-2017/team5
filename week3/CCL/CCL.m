function CCL(directory,performanceDirectory,maxSize,minSize,fillingRatio,showImages)

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
    time=0;
    for i=1:size(files,1)
        tic; % Start timer
        % Read mask
        mask = imread(strcat(directory, files(i).name(1:size(files(i).name,2)-3), 'png'));
        CCL  = bwconncomp ( mask );
        CC   = regionprops( CCL,'basic' );
        %Delete areas that are greater than area average or are less than area average
        Signals = CC([CC.Area] >= avgTotMinSize & [CC.Area] <= avgTotMaxSize);
        %BB structure [x, y, width, height]
        BB = [];
        for j=1:size(Signals,1)
            ActualBB.BoundingBox  = Signals(j).BoundingBox;
            ActualBB.x            = Signals(j).BoundingBox(1);
            ActualBB.y            = Signals(j).BoundingBox(2);
            ActualBB.w            = Signals(j).BoundingBox(3);
            ActualBB.h            = Signals(j).BoundingBox(4);
            ActualBB.Area         = Signals(j).Area;
            %ActualBB.fillingRatio = sum(sum(mask(round(ActualBB.y : ActualBB.y+ActualBB.h), ...
            %round(ActualBB.x : ActualBB.x+ActualBB.w)))) ...
            %/ ActualBB.Area;
            %if( ActualBB.fillingRatio >= totFillingRatio - totFillingRatio * 0.8 & ...
            %    ActualBB.fillingRatio <= totFillingRatio + totFillingRatio * 0.8 )
            %    BB = [BB,ActualBB];
            %end
            BB = [BB,ActualBB];
        end
        save([strcat(directory,'gt/gt.',files(i).name(6:size(files(i).name,2)-3), 'mat')],'BB');
        if showImages
            figure;
            imshow(mask);
            hold on
            %Show areas in image
            for n=1:size(BB,1)
                rectangle('Position',BB(n).BoundingBox,'EdgeColor','g','LineWidth',2)
            end
        end
        % Accumulate pixel performance of the current image %%%%%%%%%%%%%%%%%
        pixelAnnotation = imread(strcat(performanceDirectory, '/mask/', files(i).name(1:size(files(i).name,2)-3), 'png'))>0;
        [localPixelTP, localPixelFP, localPixelFN, localPixelTN] = PerformanceAccumulationPixel(mask, pixelAnnotation);
        pixelTP = pixelTP + localPixelTP;
        pixelFP = pixelFP + localPixelFP;
        pixelFN = pixelFN + localPixelFN;
        pixelTN = pixelTN + localPixelTN;
        % Accumulate object performance of the current image %%%%%%%%%%%%%%%%
        windowAnnotations = LoadAnnotations(strcat(performanceDirectory, '/gt/gt.', files(i).name(6:size(files(i).name,2)-3), 'txt'));
        [localWindowTP, localWindowFN, localWindowFP] = PerformanceAccumulationWindow(BB, windowAnnotations);
        windowTP = windowTP + localWindowTP;
        windowFN = windowFN + localWindowFN;
        windowFP = windowFP + localWindowFP;
        time =  time + toc; 
    end
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