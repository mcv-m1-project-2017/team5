function [pixelPrecision, pixelAccuracy, pixelSpecificity, pixelSensitivity,pixelF1,pixelRecall] = PerformanceEvaluationPixel(pixelTP, pixelFP, pixelFN, pixelTN)
    % PerformanceEvaluationPixel
    % Function to compute different performance indicators (Precision, accuracy, 
    % specificity, sensitivity) at the pixel level
    %
    % [pixelPrecision, pixelAccuracy, pixelSpecificity, pixelSensitivity] = PerformanceEvaluationPixel(pixelTP, pixelFP, pixelFN, pixelTN)
    %
    %    Parameter name      Value
    %    --------------      -----
    %    'pixelTP'           Number of True  Positive pixels
    %    'pixelFP'           Number of False Positive pixels
    %    'pixelFN'           Number of False Negative pixels
    %    'pixelTN'           Number of True  Negative pixels
    %
    % The function returns the precision, accuracy, specificity and sensitivity

    pixelPrecision = pixelTP / (pixelTP+pixelFP);
    pixelAccuracy = (pixelTP+pixelTN) / (pixelTP+pixelFP+pixelFN+pixelTN);
    pixelSpecificity = pixelTN / (pixelTN+pixelFP);
    pixelSensitivity = pixelTP / (pixelTP+pixelFN);
    pixelF1          = 2*(pixelTP)/(2*pixelTP+pixelFN+pixelFP);
    pixelRecall      = pixelTP    / (pixelTP+pixelFN);
end
