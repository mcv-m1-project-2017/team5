function [ imdilated ] = mydilate(im, se)
    % mydilate
    % Perform dilate operation to a given image with a specific structural element
    %
    %    Parameter name      Value
    %    --------------      -----
    %    'im'               image to dilate
    %    'se'               structural element to apply
    
       
    [rows, col, chan] = size(im);
    imdilated = zeros(rows, col, chan,'uint8');
    
    [se_sz_x, se_sz_y] = size(se);
    se_center = floor((size(se)+1)/2);    
    
    %flip se
    se = se(end:-1:1,end:-1:1);
    se_center = size(se) - (se_center-1);

    for k=1:chan
        for i=1:rows
            for j=1:col
                idx_x = [i-(se_center(1)-1), i+(se_sz_x-se_center(1))];
                idx_y = [j-(se_center(2)-1), j+(se_sz_y-se_center(2))];

                region = im(max(1,idx_x(1)) : min(rows,idx_x(2)),...
                            max(1,idx_y(1)) : min(col,idx_y(2)),k);

                se_act = se(1 + max(0,1-idx_x(1)) : se_sz_x + min(0,rows-idx_x(2)),...
                            1 + max(0,1-idx_y(1)) : se_sz_y + min(0,col-idx_y(2)));

                imdilated(i,j,k) = max(max(region(se_act>0)));        
            end
        end
    end    
end

