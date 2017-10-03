function [signTypeFrequency, maxSizeByType, minSizeByType, formFactorByType, fillingRatioByType ] = SignalCharacteristics( directory )
    % SignalCharacteristics
    % Determines the characteristics of the signals in the training set: max
    % and min size, form factor, filling ratio of each type of signal,
    % frequency of appearance (using text annotations and ground-truth
    % masks). Groups the signals according to their shape and color.
    %
    %    Parameter name      Value
    %    --------------      -----
    %    'directory'         directory where the images to analize reside

    files = ListFiles(directory);

    SignTypeIndex = 'A':'F';

    signTypeFrequency = zeros(6,1);
    maxSizeByType = -inf(6,1);
    minSizeByType = inf(6,1);
    formFactorByType = zeros(6,1);
    fillingRatioByType = zeros(6,1);

    for i=1:size(files,1),

        % i
        % Read annotations
        [annotations, Signs] = LoadAnnotations(strcat(directory, '/gt/gt.', files(i).name(1:size(files(i).name,2)-3), 'txt'));

        % Read mask
        mask = imread(strcat(directory, '/mask/mask.', files(i).name(1:size(files(i).name,2)-3), 'png'))>0;

        for j=1:size(Signs,2)
            % Compute signal characteristics
            sIndex = SignTypeIndex==Signs{j};
            signSize = annotations(j).w * annotations(j).h;
            formFactor = annotations(j).w / annotations(j).h;
            %imshow(mask(annotations(j).y : annotations(j).y+annotations(j).h, annotations(j).x : annotations(j).x+annotations(j).w)*255)
            fillingRatio = sum(sum(mask(round(annotations(j).y : annotations(j).y+annotations(j).h), ...
                round(annotations(j).x : annotations(j).x+annotations(j).w)))) ...
                / signSize;

            % Compute signal type appearance frequency
            signTypeFrequency(sIndex) = signTypeFrequency(sIndex) + 1;

            % Compute max and min size
            if maxSizeByType(sIndex)<signSize
                maxSizeByType(sIndex) = signSize;
            end
            if minSizeByType(sIndex)>signSize
                minSizeByType(sIndex) = signSize;
            end

            % Compute filling ratio (1)
            fillingRatioByType(sIndex) = fillingRatioByType(sIndex) + fillingRatio;

            % Compute form factor (1)
            formFactorByType(sIndex) = formFactorByType(sIndex) + formFactor;
        end
    end
    
    % Compute filling ratio (2)
    fillingRatioByType = fillingRatioByType ./ signTypeFrequency;

    % Compute form factor (2)
    formFactorByType = formFactorByType ./ signTypeFrequency;
end

