function [ imopenclose ] = myOpeningClosing(im, se, type)
    % mydilate
    % Perform erode operation to a given image with a specific structural element
    %
    %    Parameter name      Value
    %    --------------      -----
    %    'im'               image to erode
    %    'se'               structural element to apply
    %    'type'             0 for Opening, 1 for Closing 
    
    if ~type
        imopenclose = myerode(im, se);
        imopenclose = mydilate(imopenclose, se);
    else
        imopenclose = mydilate(im, se);
        imopenclose = myerode(imopenclose, se);
    end

end

