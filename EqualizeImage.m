function [equalized_im] = EqualizeImage(im)
    % equalize_image 
    % Perform histogram equalization for each of the bands of the image.
    %    Parameter name      Value
    %    --------------      -----
    %    'im'               image to equalize
    
    im = uint8(im);
    
    %Split the 3 bands of the color image
    eq1 = im(:,:,1);
    eq2 = im(:,:,2);
    eq3 = im(:,:,3);
    
    
    % Compute histogram equalization of all bands (comment the bands you
    % don't want to equalize)    
    eq1 = histeq(eq1); 
    eq2 = histeq(eq2); 
    eq3 = histeq(eq3); 
    
    %Join the 3 bands
    equalized_im = cat(3,eq1,eq2,eq3);    
    
end

