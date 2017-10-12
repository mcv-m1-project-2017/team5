function [ imdilated ] = mydilate(im, se)
    % mydilate
    % Perform dilate operation to a given image with a specific structural element
    %
    %    Parameter name      Value
    %    --------------      -----
    %    'im'               image to dilate
    %    'se'               structural element to apply
    
    
    [sz_x, sz_y] = size(im);
    imdilated = zeros(sz_x, sz_y);
    
    [se_sz_x, se_sz_y] = size(se);
    se_center = floor((size(se)+1)/2);    
    
    %flip se
    se = se(end:-1:1,end:-1:1);
    se_center = size(se) - (se_center-1);
    
    for i=1:sz_x
        for j=1:sz_y
            idx_x = [i-(se_center(1)-1), i+(se_sz_x-se_center(1))];
            idx_y = [j-(se_center(2)-1), j+(se_sz_y-se_center(2))];
            
            region = im(max(1,idx_x(1)) : min(sz_x,idx_x(2)),...
                        max(1,idx_y(1)) : min(sz_y,idx_y(2)));
                    
            se_act = se(1 + max(0,1-idx_x(1)) : se_sz_x + min(0,sz_x-idx_x(2)),...
                        1 + max(0,1-idx_y(1)) : se_sz_y + min(0,sz_y-idx_y(2)));
                    
            imdilated(i,j) = max(max(region.*se_act));        
        end
    end
end

