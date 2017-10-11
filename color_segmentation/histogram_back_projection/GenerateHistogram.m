function [nPixels, edges] = GenerateHistogram( pixelDataset, nbins, cspace )
% GenerateHistogram
% Extracts the pixels of the signs and saves them in a single dataset.
%
%    Parameter name      Value
%    --------------      -----
%    'pixelDataset'      Dataset of pixels to work with
%    'nbins'             Number of bins of the histogram per axis
%    'cspace'            Color space in which convert the pixels first
% Returns the histogram in nPixels and the edges for each bin where a
% bin i represents pixels in the range  edges(i) - edges(i+1)
switch cspace
    case 'hsv'
        edges = linspace(0,1,nbins+1);
        
        pixelDataset = permute(pixelDataset,[1 3 2]);
        pixelDataset = rgb2hsv(pixelDataset);
        pixelDataset = permute(pixelDataset(:,:,[1 2]),[1 3 2]);
        
    case 'ycbcr'
        edges = linspace(0,255,nbins+1);
        
        pixelDataset = permute(pixelDataset,[1 3 2]);
        pixelDataset = rgb2ycbcr(pixelDataset);
        pixelDataset = permute(pixelDataset(:,:,[2 3]),[1 3 2]);
        
    otherwise
        error('Incorrect color space defined');
end

pixelDataset = double(pixelDataset);
nPixels = hist3(pixelDataset,'Edges',{edges edges});

% Add the pixels on the edge's superior limit to the last bin
nPixels= [nPixels(:,1:end-2) nPixels(:,end-1)+nPixels(:,end)];
nPixels= [nPixels(1:end-2,:); nPixels(end-1,:)+nPixels(end,:)];

% Normalize histogram to use values as probabilities
nPixels = nPixels/max(max(nPixels));
end

