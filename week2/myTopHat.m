function [ imtophat ] = myTopHat(im, se, type)
    % mydilate
    % Perform erode operation to a given image with a specific structural element
    %
    %    Parameter name      Value
    %    --------------      -----
    %    'im'               image to erode
    %    'se'               structural element to apply
    %    'type'             0 Top-Hat, 1 Dual Top-Hat

    if ~type
        imtophat = im - myOpeningClosing(im, se, 0);
    else
        imtophat = myOpeningClosing(im, se, 1) - im;
    end
end

