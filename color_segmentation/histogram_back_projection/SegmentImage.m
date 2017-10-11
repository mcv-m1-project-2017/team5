function [ segmentedImage ] = SegmentImage( image, histograms, edges, thresholds ,cspace)
% SegmentImage
% Extracts the pixels of the signs and saves them in a single dataset.
%
%    Parameter name      Value
%    --------------      -----
%    'image'             The image to segment
%    'histograms'        The histograms to use as model
%    'edges'             Edges of the bins of these histograms
%    'thresholds'        Thresholds to use per each histogram segmentation
%    'cspace'            Color space to use to work
% Returns the segmented image

[height,width,~] = size(image);
switch cspace
    case 'hsv'
        dims = [1 2];
        image = round(rgb2hsv(image)*255);
        for t=1:length(edges)
            edges{t} = edges{t}*255;
        end
        
    case 'ycbcr'
        dims = [2 3];
        image = rgb2ycbcr(image);
        
    otherwise
        error('Incorrect color space defined');
end

segmentedImage = zeros(height,width);
for t=1:length(thresholds)
    
    indexConverter = [1 sum(bsxfun(@gt,repmat(1:255,length(edges{t}),1),edges{t}'))];
    
    auxSegmentedImage = zeros(height,width);
    h = histograms{t};
    for i=1:height
        for j=1:width
            auxSegmentedImage(i,j) = h(indexConverter(image(i,j,dims(1))+1),indexConverter(image(i,j,dims(2))+1)) > thresholds(t);
        end
        %i
    end
    segmentedImage = segmentedImage | auxSegmentedImage;
end
end

