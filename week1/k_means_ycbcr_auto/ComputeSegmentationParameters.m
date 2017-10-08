function [ minvalues, maxvalues ] = ComputeSegmentationParameters( centroids, K, idx, pixelDataset, lambda )
    % ComputeSegmentationParameters
    % Extracts the pixels of the signs and saves them in a single dataset.
    %
    %    Parameter name      Value
    %    --------------      -----
    %    'centroids'         Centroids (mean) of each pixel cluster
    %    'K'                 Number of clusters
    %    'idx'               Index of the cluster belonging of each pixel
    %    'pixelDataset'      Dataset of all the pixels
    %    'lambda'            Parameter to control the narrowness
    
    minvalues = zeros(K,size(centroids,2));
    maxvalues = zeros(K,size(centroids,2));
    
    if length(lambda)==1
        lambda = ones(K,1)*lambda;
    end

    for k=1:K
        stdval = std(pixelDataset(idx==k,2:3));
        minvalues(k,:) = centroids(k,:) - lambda(k) * stdval;
        maxvalues(k,:) = centroids(k,:) + lambda(k) * stdval;
    end
end

