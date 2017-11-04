function signals = get_templates(directory,grayscale,showImages)
% INPUT: 'directory' directory of the files provided for training
%        'type' Activate grayscale
%        'showImages' boolean if you want to show mask with CCL
    %directory does not exist
    if exist(directory, 'dir') ~= 7
        error('Directory not found');
    end

    files = ListFiles(directory);
    if size(files,1) == 0
        error('Directory is empty');
    end
    if exist(strcat(directory, '/templates'), 'dir') ~= 7
        mkdir(strcat(directory, '/templates'));
    end
   
    %[typeA, typeB, ..., typeF]
    SignTypeIndex = 'A':'F';
    signTypeFrequency = zeros(6,1);
    signals           = zeros(250,250,3,6); 
    for i=1:length(files)
        % Read annotations
        [annotations, Signs] = LoadAnnotations(...
                      strcat(directory, '/gt/gt.'    , files(i).name(1:size(files(i).name,2)-3), 'txt'));
        %Read image
        img  = imread(strcat(directory,'/'           , files(i).name(1:size(files(i).name,2)-3), 'jpg'));
        %Read mask
        mask = imread(strcat(directory, '/mask/mask.', files(i).name(1:size(files(i).name,2)-3), 'png'));
        %For each signal in the current image
        for j=1:size(Signs,2)
            %Get signal type
            sIndex = SignTypeIndex==Signs{j};
            %Add one to the frecuency
            signTypeFrequency(sIndex) = signTypeFrequency(sIndex) + 1;
            %Show signal
            imshow(mask( annotations(j).y : annotations(j).y+annotations(j).h...
                       , annotations(j).x : annotations(j).x+annotations(j).w)*255);
            %Get signal from image and mask
            img_signal  = img ( round(annotations(j).y : annotations(j).y+annotations(j).h)...
                              , round(annotations(j).x : annotations(j).x+annotations(j).w),:);
            mask_signal = mask( round(annotations(j).y : annotations(j).y+annotations(j).h)...
                              , round(annotations(j).x : annotations(j).x+annotations(j).w));
            %Multiply by mask
            current_signal(:,:,1) = img_signal(:,:,1) .* mask_signal;
            current_signal(:,:,2) = img_signal(:,:,2) .* mask_signal;
            current_signal(:,:,3) = img_signal(:,:,3) .* mask_signal;
            current_signal = double  (current_signal);
            %Resize image for a standar size
            current_signal = imresize(current_signal, [250 250]);
            signals(:,:,:,sIndex) = signals(:,:,:,sIndex) + current_signal;
            if showImages
                imshow(signal);
                figure; 
                imshow(img_signal);
            end
        end
    end
    %For each template
    for i=1:size(signals,1)
        %calculate average
        signals(:,:,:,i) = signals(:,:,:,i) / signTypeFrequency(i);
        %Apply grayscale
        if grayscale
            signals(:,:,:,i) = rgb2gray(uint8(signals(:,:,:,i)));
        end
        %Show images
        if showImages
            figure; 
            imshow(signals(:,:,:,i));
        end
        %Write templates
        imwrite(signals(:,:,:,sIndex),strcat(directory, '/templates/Template_',SignTypeIndex(i),'.png'));
    end
end