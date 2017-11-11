function [ output_mask ] = morphologyMyVersion( mask )
    % Area filling
    mask = imfill(mask, 'holes');
    
    % Noise reduction
%     erodeMask  = imerode (mask,strel('disk',6));
%     output_mask = imdilate(erodeMask,strel('disk',6));
    output_mask = imopen(mask, strel('disk',6));
end

