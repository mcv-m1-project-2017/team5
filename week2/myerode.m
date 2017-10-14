function [ imeroded ] = myerode(im, se)
    % mydilate
    % Perform erode operation to a given image with a specific structural element
    %
    %    Parameter name      Value
    %    --------------      -----
    %    'im'               image to erode
    %    'se'               structural element to apply
    
    %Get sizes
    [rows, col, chan] = size(im);
    [se_sz_x, se_sz_y] = size(se);
    
    %Create result image with the same size of im
    imeroded = zeros(rows, col, chan,'uint8');
    
    %Calculate center of se
    se_center = floor((size(se)+1)/2);       
        
    for k=1:chan        
    	%Image center 
        for i=se_center(1):(rows-(se_sz_x-se_center(1)))
            for j=se_center(2):(col-(se_sz_y-se_center(2)))
                
                idx_x = [i-(se_center(1)-1), i+(se_sz_x-se_center(1))];
                idx_y = [j-(se_center(2)-1), j+(se_sz_y-se_center(2))];
                
                region = im(idx_x(1):idx_x(2), idx_y(1):idx_y(2),k);
                imeroded(i,j,k) = min(min(region(se>0)));  
            end
        end
        
        %Up border
        for i=1:se_center(1)-1
            for j=1:col
                idx_x = [i-(se_center(1)-1), i+(se_sz_x-se_center(1))];
                idx_y = [j-(se_center(2)-1), j+(se_sz_y-se_center(2))];

                region = im(       1        : idx_x(2),...
                            max(1,idx_y(1)) : min(col,idx_y(2)),k);

                se_act = se(1 + max(0,1-idx_x(1)) : se_sz_x + min(0,rows-idx_x(2)),...
                            1 + max(0,1-idx_y(1)) : se_sz_y + min(0,col-idx_y(2)));

                imeroded(i,j,k) = min(min(region(se_act>0)));        
            end
        end
        
        %Down border
        for i=(rows-se_center(1)+2):rows
            for j=1:col
                idx_x = [i-(se_center(1)-1), i+(se_sz_x-se_center(1))];
                idx_y = [j-(se_center(2)-1), j+(se_sz_y-se_center(2))];

                region = im(    idx_x(1)    : rows,...
                            max(1,idx_y(1)) : min(col,idx_y(2)),k);

                se_act = se(1 + max(0,1-idx_x(1)) : se_sz_x + min(0,rows-idx_x(2)),...
                            1 + max(0,1-idx_y(1)) : se_sz_y + min(0,col-idx_y(2)));

                imeroded(i,j,k) = min(min(region(se_act>0)));        
            end
        end
        
        %Left border
        for i=se_center(1):(rows-(se_sz_x-se_center(1)))-1
            for j=1:se_center(2)-1
                idx_x = [i-(se_center(1)-1), i+(se_sz_x-se_center(1))];
                idx_y = [j-(se_center(2)-1), j+(se_sz_y-se_center(2))];

                region = im(    idx_x(1)    : idx_x(2) ,...
                                   1        : idx_y(2) ,k);

                se_act = se(1 + max(0,1-idx_x(1)) : se_sz_x + min(0,rows-idx_x(2)),...
                            1 + max(0,1-idx_y(1)) : se_sz_y + min(0,col-idx_y(2)));

                imeroded(i,j,k) = min(min(region(se_act>0)));        
            end
        end
        
        %Right border
        for i=se_center(1):(rows-(se_sz_x-se_center(1)))-1
            for j=(col-se_center(2)+2):col
                idx_x = [i-(se_center(1)-1), i+(se_sz_x-se_center(1))];
                idx_y = [j-(se_center(2)-1), j+(se_sz_y-se_center(2))];

                region = im(    idx_x(1)   : idx_x(2) ,...
                                idx_y(1)   : col      ,k);

                se_act = se(1 + max(0,1-idx_x(1)) : se_sz_x + min(0,rows-idx_x(2)),...
                            1 + max(0,1-idx_y(1)) : se_sz_y + min(0,col-idx_y(2)));

                imeroded(i,j,k) = min(min(region(se_act>0)));        
            end
        end    
    end
    
    imeroded = cast(imeroded, 'like', im);
end

