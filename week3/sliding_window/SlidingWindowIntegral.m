function [ uniqueWindowCandidates ] = SlidingWindowIntegral( im, window_w_maxmin, window_h_maxmin,filling_ratio,joining_threshold,jump_interval)

[rows,cols] = size(im);

ext_im=false(rows+2,cols+2);
ext_im(2:end-1,2:end-1)=im;

iim = cumsum(cumsum(double(ext_im)),2);
nSizes = 6;
window_w_vector = round(linspace(window_w_maxmin(1),window_w_maxmin(2),nSizes));
window_h_vector = round(linspace(window_h_maxmin(1),window_h_maxmin(2),nSizes));

% Search for candidates
windowCandidates=[];
windowIdentifiers = [];
referenceWindows = [struct('x',-Inf,'y',-Inf,'w',0,'h',0)]; % Added to always have a reference
window_idx = 0;

for i=2:jump_interval:rows-window_h_maxmin(2)+2
    for j=2:jump_interval:cols-window_w_maxmin(2)+2
        % Try different window sizes
        last_window_fr = -Inf;
        for s=1:nSizes
            window_w = window_w_vector(s);
            window_h = window_h_vector(s);
            
            adjusted_i = i+floor((window_w_maxmin(2)-window_w)/2);
            adjusted_j = j+floor((window_h_maxmin(2)-window_h)/2);
            if adjusted_i==0
                adjusted_i
            end
            if adjusted_j==0
                adjusted_j
            end
            % Compute window's filling rate
            window_integral = iim(adjusted_i+window_h-1, adjusted_j+window_w-1) ...
                - iim(adjusted_i-1, adjusted_j+window_w-1) ...
                - iim(adjusted_i+window_h-1,adjusted_j-1) ...
                + iim(adjusted_i-1,adjusted_j-1);
%             window = im(adjusted_i:adjusted_i+window_h-1, adjusted_j:adjusted_j+window_w-1);
            window_fr = window_integral/(window_h*window_w);
            
            if window_fr<filling_ratio
                break
            end
            last_window_fr = window_fr;
        end
        if window_fr<filling_ratio && s>1
            window_w = window_w_vector(s-1);
            window_h = window_h_vector(s-1);
            adjusted_i = i+floor((window_w_maxmin(2)-window_w)/2)-1;
            adjusted_j = j+floor((window_h_maxmin(2)-window_h)/2)-1;
        end
        
        if  last_window_fr >= filling_ratio
            % Look for another similar window
            sameWindow =    ([referenceWindows.x] - window_w_maxmin(2)*joining_threshold <= adjusted_j ...
                & [referenceWindows.x] + window_w_maxmin(2)*joining_threshold >= adjusted_j) ...
                & ([referenceWindows.y] - window_h_maxmin(2)*joining_threshold <= adjusted_i ...
                & [referenceWindows.y] + window_h_maxmin(2)*joining_threshold >= adjusted_i);
            if max(sameWindow) == 0
                % If there is no similar window add the new window as a new
                % independent window to have as reference
                window_idx = window_idx+1;
                windowIdentifiers = [windowIdentifiers window_idx];
                referenceWindows = [referenceWindows struct('x',adjusted_j,'y',adjusted_i,'w',window_w,'h',window_h)];
            else
                % If ther is another similar window mark it to join them
                % later
                windowIdentifiers = [windowIdentifiers find(sameWindow,1,'first')-1];
            end
            
            % Add the window to the window candidates
            windowCandidates = [windowCandidates struct('x',adjusted_j,'y',adjusted_i,'w',window_w,'h',window_h)];
        end
    end
end

% Unify similar window candidates by the mean of their coordinates
uniqueWindowIdentifiers = unique(windowIdentifiers);
uniqueWindowCandidates = [];
if ~isempty(uniqueWindowIdentifiers)
    for idx = uniqueWindowIdentifiers
        uniqueWindowCandidates = [uniqueWindowCandidates ...
            struct('x',mean([windowCandidates(windowIdentifiers==idx).x]),...
            'y',mean([windowCandidates(windowIdentifiers==idx).y]),...
            'w',mean([windowCandidates(windowIdentifiers==idx).w]),...
            'h',mean([windowCandidates(windowIdentifiers==idx).h]))];
    end
end
end

