function [ pixelDataset ] = GeneratePixelDataset( directory, files, annotations )
    % GeneratePixelDataset
    % Extracts the pixels of the signs and saves them in a single dataset.
    %
    %    Parameter name      Value
    %    --------------      -----
    %    'directory'         Directory where the images to analize (.jpg) reside
    %    'files'             Names of the files where the signs are
    %    'annotations'       Window coordinades of each sign
    
    if size(files,1)~=size(annotations,1)
        error('Error: files and annotations vector length is not the same. Maybe files(fileIndex)) conversion is missing.');
    end
    
    pixelDataset = [];

    for i=1:size(files,1)

        % i

        % Read image
        im = imread(strcat(directory,'/',files(i).name));

        % Read annotation
        pixelAnnotation = imread(strcat(directory, '/mask/mask.', files(i).name(1:size(files(i).name,2)-3), 'png'))>0;

        % Cut the image and mask
        im = im(round(annotations(i).y : annotations(i).y+annotations(i).h), ...
            round(annotations(i).x : annotations(i).x+annotations(i).w),:);
        pixelAnnotation = pixelAnnotation(round(annotations(i).y : annotations(i).y+annotations(i).h), ...
            round(annotations(i).x : annotations(i).x+annotations(i).w));

        % Extract the pixels
        r = im(:,:,1);
        g = im(:,:,2);
        b = im(:,:,3);
        signPixels = [r(pixelAnnotation), g(pixelAnnotation), b(pixelAnnotation)];

        pixelDataset = [pixelDataset; signPixels];
    end
end
