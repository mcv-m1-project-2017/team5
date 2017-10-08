function SegmentImages( directory, files, fileIndex, minvalues, maxvalues)
    % SegmentImages
    % Segments the images according to the ranges minvalue-maxvalue.
    %
    %    Parameter name      Value
    %    --------------      -----
    %    'directory'         Directory where the images to analize (.jpg) reside
    %    'files'             Names of the files where the signs are
    %    'fileIndex'         Indexes of the files array of the images to segment
    %    'minvalues'         Minimum value of each range
    %    'maxvalues'         Maximum value of each range

    K = size(minvalues,1);
    
    if size(fileIndex,2)==1
        fileIndex=fileIndex';
    end
    
    for f=fileIndex
        % Read file
        im = imread(strcat(directory,'/',files(f).name));
        
        imshow(im);
        title('original');
        
        im = rgb2ycbcr(im);

        for k=1:K
            segmentedim = ones(size(im,1),size(im,2));
            for c=1:2
                segmentedim = segmentedim & im(:,:,c+1)>=minvalues(k,c) & im(:,:,c+1)<=maxvalues(k,c);
            end
            figure;
            imshow(imresize(segmentedim,round(size(segmentedim)*0.25)));
            title(int2str(k));
        end
        fprintf('Press any key to close figures and continue...\n');
        pause;
        close all;
    end
end

