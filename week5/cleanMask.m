function [ cleanedMask ] = cleanMask( mask, windowCandidates )
%cleanMask clean a given mask with a list of window candidates
    [rows,cols] = size(mask);
    cleanedMask = zeros(rows, cols); 
    
    for i=1:size(windowCandidates)        
        ymin = max(1,floor(windowCandidates(i).x));
        ymax = min(cols,round(windowCandidates(i).x + windowCandidates(i).w));
        xmin = max(1,floor(windowCandidates(i).y));
        xmax = min(rows,floor(windowCandidates(i).y + windowCandidates(i).h));
        cleanedMask(xmin:xmax, ymin:ymax) = mask(xmin:xmax, ymin:ymax);
    end

end

