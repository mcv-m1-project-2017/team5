function [ BB ] = getCCMultiFilter( mask,im)
% INPUT: 'mask' mask to obtain CCL
BB = getCCLs(mask);
if isempty(BB)
    return
end

% Size and form factor filtering
BB = parameterFiltering(BB);
% Resize window to 250x250 Best way to resize binary image?
% Do DT
%BB=DTfiltering(BB,mask);
% Multiply to get the distance value, use hough to detect which mask to
% use?
BB=HoughFiltering(BB,mask,im);
% Apply threshold (different for each type?)
% Apply color matching using Pedro's templates

%Delete areas that are greater than area average or are less than area average



end

