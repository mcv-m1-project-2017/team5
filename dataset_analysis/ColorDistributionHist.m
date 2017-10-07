function [minRGBValuesByType, maxRGBValuesByType] = ColorDistributionHist( directory )
    % ColorDistributionHist
    % 
    %   This function calculates the maximum and minimum values for each
    %   signal type in each color channel.  This is calculated depending on
    %   the number of pixels in each channel as a solution to discard
    %   outliers.
    %
    %    Parameter name      Value
    %    --------------      -----
    %    'directory'         directory where the images to analize reside

    % Directory does not exist
    if exist(directory, 'dir') ~= 7
        error('Directory not found');
    end
    files = ListFiles(directory);
    SignTypeIndex = 'A':'F';

    % Min and max values for each signal type and channel
    minRGBValuesByType = inf(6,3);
    maxRGBValuesByType = zeros(6,3);
    
    % Rule out both extremes min-max 
    % dark images, noise, too much white...
    minRBGlimit = 5;
    maxRGBlimit = 250;
    
    % Average increase factor
    % 1 = average
    hCuttingFactor = 1.9;
    
    for i=1:size(files,1),

        % i
        % Read annotations
        [annotations, Signs] = LoadAnnotations(strcat(directory, '/gt/gt.', files(i).name(1:size(files(i).name,2)-3), 'txt'));

        % Read image
        im = imread(strcat(directory,'/',files(i).name));
        %imshow(im);

        for j=1:size(Signs,2)
            % Compute signal characteristics
            sIndex = SignTypeIndex==Signs{j};
            signalIdx = find(sIndex);
            
            % Signal from the original image
            colorSignal = im(annotations(j).y : annotations(j).y+annotations(j).h, annotations(j).x : annotations(j).x+annotations(j).w, :);
            %imshow(colorSignal)
            
            % Split into RGB Channels
            Red = colorSignal(:,:,1);
            Green = colorSignal(:,:,2);
            Blue = colorSignal(:,:,3);

            % Get histValues for each channel
            [yRed, xRed] = imhist(Red);
            [yGreen, xGreen] = imhist(Green);
            [yBlue, xBlue] = imhist(Blue);
            
            % Average value of pixels in each channel
            meanR = sum(yRed) / numel(find(yRed));
            meanG = sum(yGreen) / numel(find(yGreen));
            meanB = sum(yBlue) / numel(find(yBlue));
            % Increasing/decreasing the average value
            meanR = meanR * hCuttingFactor;
            meanG = meanG * hCuttingFactor;
            meanB = meanB * hCuttingFactor;
            
            % Find the min and max value greater than average in histogram 
            minRIndexV = min(find(yRed>meanR));
            maxRIndexV = max(find(yRed>meanR));
            minGIndexV = min(find(yGreen>meanG));
            maxGIndexV = max(find(yGreen>meanG));
            minBIndexV = min(find(yBlue>meanB));
            maxBIndexV = max(find(yBlue>meanB));

            % Update the min and max values for each type of signal
            if minRGBValuesByType(signalIdx,1) > minRIndexV && minRIndexV > minRBGlimit
                minRGBValuesByType(signalIdx,1) = minRIndexV;
            end
            if maxRGBValuesByType(signalIdx,1) < maxRIndexV && maxRIndexV < maxRGBlimit
                maxRGBValuesByType(signalIdx,1) = maxRIndexV;
            end
            
            if minRGBValuesByType(signalIdx,2) > minGIndexV && minGIndexV > minRBGlimit
                minRGBValuesByType(signalIdx,2) = minGIndexV;
            end
            if maxRGBValuesByType(signalIdx,2) < maxGIndexV && maxGIndexV < maxRGBlimit
                maxRGBValuesByType(signalIdx,2) = maxGIndexV;
            end
            
            if minRGBValuesByType(signalIdx,3) > minBIndexV && minBIndexV > minRBGlimit
                minRGBValuesByType(signalIdx,3) = minBIndexV;
            end
            if maxRGBValuesByType(signalIdx,3) < maxBIndexV && maxBIndexV < maxRGBlimit
                maxRGBValuesByType(signalIdx,3) = maxBIndexV;
            end
                     
            % Visualize color distribution by channel 
            %{
            figure;
            subplot(4,1,1);    
            plot(xRed,yRed, 'Red');
            title('Red');
            subplot(4,1,2);  
            plot(xGreen,yGreen, 'Green');      
            title('Green');
            subplot(4,1,3);
            plot(xBlue, yBlue, 'Blue');
            title('Blue');
            subplot(4,1,4);
            plot(xRed, yRed, 'Red', xGreen, yGreen, 'Green', xBlue, yBlue, 'Blue');
            title('General');
             %}
        end
    end  
end

