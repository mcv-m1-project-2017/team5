function [ files, fileIndex, annotations, signType ] = LoadAllFileAnnotations( directory )
    % LoadAllFileAnnotations
    % Loads all the annotations of the files in the dataset.
    %
    %    Parameter name      Value
    %    --------------      -----
    %    'directory'         directory where the images to analize reside
    
    files = ListFiles(strcat(directory));

    SignTypeIndex = 'A':'F';

    fileIndex = [];
    signType = [];
    annotations = [];

    for f = 1:size(files,1)

        % Read annotations
        [currentAnnotations, signs] = LoadAnnotations(strcat(directory, '/gt/gt.', files(f).name(1:size(files(f).name,2)-3), 'txt'));

        % For each sign in the file
        for s=1:size(signs,2)

            % Save its signal type and file reference
            signType = [signType; find(SignTypeIndex==signs{s})];
            fileIndex = [fileIndex; f];

        end

        % Save the window annotations
        annotations = [annotations; currentAnnotations];
    end
        
end

