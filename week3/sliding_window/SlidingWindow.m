function [ uniqueWindowCandidates ] = SlidingWindow( im, window_w, window_h,filling_ratio,joining_threshold,jump_interval)

[rows,cols] = size(im);

% Search for candidates
windowCandidates=[];
windowIdentifiers = [];
referenceWindows = [struct('x',-Inf,'y',-Inf,'w',0,'h',0)]; % Added to always have a reference
window_idx = 0;



for i=1:jump_interval:rows-window_h+1
    for j=1:jump_interval:cols-window_w+1
        % Compute window's frame rate
        window = im(i:i+window_h-1,j:j+window_w-1);
        window_fr = sum(window(:))/(window_h*window_w);
        
        if  window_fr >= filling_ratio
            % Look for another similar window
            sameWindow =    ([referenceWindows.x] - window_w*joining_threshold <= j ...
                                & [referenceWindows.x] + window_w*joining_threshold >= j) ...
                            & ([referenceWindows.y] - window_h*joining_threshold <= i ...
                                & [referenceWindows.y] + window_h*joining_threshold >= i);
            if max(sameWindow) == 0 
                % If there is no similar window add the new window as a new
                % independent window to have as reference
                window_idx = window_idx+1;
                windowIdentifiers = [windowIdentifiers window_idx];
                referenceWindows = [referenceWindows struct('x',j,'y',i,'w',window_w,'h',window_h)];
            else
                % If ther is another similar window mark it to join them
                % later
                windowIdentifiers = [windowIdentifiers find(sameWindow,1,'first')-1];
            end
            
            % Add the window to the window candidates
            windowCandidates = [windowCandidates struct('x',j,'y',i,'w',window_w,'h',window_h)];
        end
    end
end

% Unify similar window candidates by the mean of their coordinates
uniqueWindowIdentifiers = unique(windowIdentifiers);
uniqueWindowCandidates = [];
for idx = uniqueWindowIdentifiers
    uniqueWindowCandidates = [uniqueWindowCandidates ...
        struct('x',mean([windowCandidates(windowIdentifiers==idx).x]),...
        'y',mean([windowCandidates(windowIdentifiers==idx).y]),...
        'w',window_w,'h',window_h)];
end

end

