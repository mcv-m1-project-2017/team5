function PlotPixelClusters( pixelDataset, idx, centroids )
    % PlotPixelClusters
    % Plots the pixels of each cluster and the color of the centroid
    % pixels.
    %
    %    Parameter name      Value
    %    --------------      -----
    %    'pixelDataset'      Dataset of all the pixels
    %    'idx'               Index of the cluster belonging of each pixel
    %    'centroids'         Centroids (mean) of each pixel cluster
    
    K=size(centroids,1);
    figures = zeros(K+1,1);

    % Show cluster centroid color
    figures(K+1)=figure;
    imshow(uint8(round(permute(centroids, [1 3 2]))),'InitialMagnification',2000)

    % Plot clusters
    for k=1:K
        
        figures(k)=figure;
        
        scatter3(pixelDataset(idx==k,1),pixelDataset(idx==k,2),pixelDataset(idx==k,3),10,...
            double(pixelDataset(idx==k,:))/255,'.')
        
        title(int2str(k));
        
        xlim([0,255]);
        ylim([0,255]);
        zlim([0,255]);
    end
    pause;

    % Close figures
    close(figures);
end

