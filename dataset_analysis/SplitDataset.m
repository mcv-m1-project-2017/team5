function SplitDataset( signTypeFrequency, maxSizeByType, minSizeByType, formFactor, fillingRatio, directory )
% SplittingDataset
% Divide dataset by characteristics of the signals: max
% and min size, form factor, filling ratio of each type of signal,
% frequency of appearance (using text annotations and ground-truth
% masks). Information of class frequencies computed in
% SignalCharacteristics().
%
%    Parameter name      Value
%    --------------      -----
%    'directory'         directory where the images to analize reside

    %directory does not exist
    if exist(directory, 'dir') ~= 7
        error('Directory not found \n');
    end
    
    files = ListFiles(directory);
    if size(files,1) == 0
        error('Directory is empty \n');
    end
    SignTypeIndex = 'A':'F';
    TotalByType = zeros(6,1);
    average      = ( maxSizeByType + minSizeByType ) ./2;
    quantity     = round(signTypeFrequency .* 0.3);
    for i=1:size(files,1)
        [annotations, Signs] = LoadAnnotations(strcat(directory, '/gt/gt.', files(i).name(1:size(files(i).name,2)-3), 'txt'));
        % Read image
        img = imread(strcat(directory, '/', files(i).name(1:size(files(i).name,2)-3), 'jpg'));
        % Read mask
        mask = imread(strcat(directory, '/mask/mask.', files(i).name(1:size(files(i).name,2)-3), 'png'))>0;
        for j=1:size(Signs,2)
            % Compute signal characteristics
            sIndex = SignTypeIndex==Signs{j};
            imgSize       = annotations(j).w * annotations(j).h;
            imgFormFactor = annotations(j).w / annotations(j).h;
            maskfillingRatio = sum(sum(mask(round(annotations(j).y : annotations(j).y+annotations(j).h), ...
            round(annotations(j).x : annotations(j).x+annotations(j).w))))...
            /  imgSize;
            if imgSize          >= average     (sIndex) - average     (sIndex) * 0.6 ...
            && imgSize          <= average     (sIndex) + average     (sIndex) * 0.6 ...
            && imgFormFactor    >= formFactor  (sIndex) - formFactor  (sIndex) * 0.6 ...
            && imgFormFactor    <= formFactor  (sIndex) + formFactor  (sIndex) * 0.6 ...
            && maskfillingRatio >= fillingRatio(sIndex) - fillingRatio(sIndex) * 0.6 ...
            && maskfillingRatio <= fillingRatio(sIndex) + fillingRatio(sIndex) * 0.6 ...
            && TotalByType(sIndex) <   quantity(sIndex) ...
            && size(Signs,2) == 1
                TotalByType(sIndex) = TotalByType(sIndex) + 1;
                path = strcat(directory, '/validation_split/', files(i).name(1:size(files(i).name,2)-3), 'jpg');
            else
                path = strcat(directory, '/train_split/', files(i).name(1:size(files(i).name,2)-3), 'jpg');
            end
            imwrite(img,path);
        end
    end

end
