function [ uniqueWindowCandidates ] = SlidingWindow( im, window_w_maxmin, window_h_maxmin,filling_ratio,joining_threshold,jump_interval)

[rows,cols] = size(im);
nSizes = 6;
window_w_vector = round(linspace(window_w_maxmin(1),window_w_maxmin(2),nSizes));
window_h_vector = round(linspace(window_h_maxmin(1),window_h_maxmin(2),nSizes));

% Search for candidates
windowCandidates=[];
windowIdentifiers = [];
referenceWindows = [struct('x',-Inf,'y',-Inf,'w',0,'h',0)]; % Added to always have a reference
window_idx = 0;

for i=1:jump_interval:rows-window_h_maxmin(2)+1
    for j=1:jump_interval:cols-window_w_maxmin(2)+1
        % Try different window sizes
        last_window_fr = -Inf;
        for s=1:nSizes
            window_w = window_w_vector(s);
            window_h = window_h_vector(s);
            
            desp_w = (window_w_maxmin(2)-window_w)/2-1;
            desp_h = (window_h_maxmin(2)-window_h)/2-1;
            
            % Compute window's filling rate
            window = im(i+desp_h:i+desp_h+window_h-1,j+desp_w:j+desp_w+window_w-1);
            window_fr = sum(window(:))/(window_h*window_w); 
            
            if window_fr<filling_ratio
                break
            end
            last_window_fr = window_fr;
        end
        if window_fr<filling_ratio && s>1
            window_w = window_w_vector(s-1);
            window_h = window_h_vector(s-1);
        end
        
        if  last_window_fr >= filling_ratio
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
        'w',mean([windowCandidates(windowIdentifiers==idx).w]),...
        'h',mean([windowCandidates(windowIdentifiers==idx).h]))];
end

end
