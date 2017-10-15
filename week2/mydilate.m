function [ imdilated ] = mydilate(im, se)
    % mydilate
    % Perform dilate operation to a given image with a specific structural element
    %
    %    Parameter name      Value
    %    --------------      -----
    %    'im'               image to dilate
    %    'se'               structural element to apply
    
    
    %Get sizes
    [rows, col, chan] = size(im);
    [se_sz_x, se_sz_y] = size(se);
    
    %Create result image with the same size of im
    imdilated = zeros(rows, col, chan,'uint8');
    
    %Calculate center of se
    se_center = floor((size(se)+1)/2);    
    
    %flip se anf se_center
    se = se(end:-1:1,end:-1:1);
    se_center = size(se) - (se_center-1);
    
    %Initializations
    se_x = se_center(1);
    se_y = se_center(2);
        
    limit_x = se_sz_x-se_x;
    limit_y = se_sz_y-se_y;
      
    for k=1:chan        
        %Image center                
        for i=se_x:(rows-limit_x)
            for j=se_y:(col-limit_y)
                
                idx_x_1 = i-(se_x-1);
                idx_x_2 = i+limit_x;
                idx_y_1 = j-(se_y-1);
                idx_y_2 = j+limit_y;
                
                region = im(idx_x_1:idx_x_2, idx_y_1:idx_y_2, k);
                imdilated(i,j,k) = max(max(region(se>0)));  
            end
        end
        
        %Up border
        for i=1:se_x-1
            for j=1:col
                
                idx_x_1 = i-(se_x-1);
                idx_x_2 = i+limit_x;
                idx_y_1 = j-(se_y-1);
                idx_y_2 = j+limit_y;

                region = im(       1        : idx_x_2,...
                            max(1,idx_y_1) : min(col,idx_y_2),k);

                se_act = se(1 + max(0,1-idx_x_1) : se_sz_x + min(0,rows-idx_x_2),...
                            1 + max(0,1-idx_y_1) : se_sz_y + min(0,col-idx_y_2));

                imdilated(i,j,k) = max(max(region(se_act>0)));        
            end
        end
        
        %Down border
        for i=(rows-se_x+2):rows
            for j=1:col
                
                idx_x_1 = i-(se_x-1);
                idx_x_2 = i+limit_x;
                idx_y_1 = j-(se_y-1);
                idx_y_2 = j+limit_y;

                region = im(    idx_x_1    : rows,...
                            max(1,idx_y_1) : min(col,idx_y_2),k);

                se_act = se(1 + max(0,1-idx_x_1) : se_sz_x + min(0,rows-idx_x_2),...
                            1 + max(0,1-idx_y_1) : se_sz_y + min(0,col-idx_y_2));

                imdilated(i,j,k) = max(max(region(se_act>0)));        
            end
        end
        
        %Left border
        for i=se_x:(rows-limit_x-1)
            for j=1:se_y-1
                
                idx_x_1 = i-(se_x-1);
                idx_x_2 = i+limit_x;
                idx_y_1 = j-(se_y-1);
                idx_y_2 = j+limit_y;

                region = im(    idx_x_1    : idx_x_2 ,...
                                   1        : idx_y_2 ,k);

                se_act = se(1 + max(0,1-idx_x_1) : se_sz_x + min(0,rows-idx_x_2),...
                            1 + max(0,1-idx_y_1) : se_sz_y + min(0,col-idx_y_2));

                imdilated(i,j,k) = max(max(region(se_act>0)));        
            end
        end
        
        %Right border
        for i=se_x:(rows-limit_x-1)
            for j=(col-se_center(2)+2):col
                
                idx_x_1 = i-(se_x-1);
                idx_x_2 = i+limit_x;
                idx_y_1 = j-(se_y-1);
                idx_y_2 = j+limit_y;

                region = im(    idx_x_1   : idx_x_2 ,...
                                idx_y_1   : col      ,k);

                se_act = se(1 + max(0,1-idx_x_1) : se_sz_x + min(0,rows-idx_x_2),...
                            1 + max(0,1-idx_y_1) : se_sz_y + min(0,col-idx_y_2));

                imdilated(i,j,k) = max(max(region(se_act>0)));        
            end
        end    
    end
    
    imdilated = cast(imdilated, 'like',im);
end

