function [ BB ] = getCCMultiFilter( mask)
% INPUT: 'mask' mask to obtain CCL
    CCL  = bwconncomp ( mask );
    CC   = regionprops( CCL,'basic' );
    CC2 = [];
    for i=1:length(CC)
        CC2 = [CC2 struct('x',CC(i).BoundingBox(1),...
            'y',CC(i).BoundingBox(2),...
            'w',CC(i).BoundingBox(3),...
            'h',CC(i).BoundingBox(4),...
            'size',CC(i).BoundingBox(3)*CC(i).BoundingBox(4),...
            'fr',CC(i).Area / (CC(i).BoundingBox(3)*CC(i).BoundingBox(4)),...
            'ff',(CC(i).BoundingBox(3)/CC(i).BoundingBox(4))...
            )];
    end
    %Delete areas that are greater than area average or are less than area average
    if ~isempty(CC2)
        maxMinLimit = [CC2.size] <= 4.1384e+04 & [CC2.size] >= 1200;
        squareFormFactor = [CC2.ff] <= 1.2 & [CC2.ff] >= .85;
        strechedFormFactor = [CC2.ff] <= .85 & [CC2.ff] >= .7 & [CC2.h] > [CC2.w];
        circleFillingRatio = [CC2.fr] <= .84 & [CC2.fr] >= .72;
        triangFillingRatio = [CC2.fr] <= .7 & [CC2.fr] >= .46;
        squareFillingRatio = [CC2.fr] >= .8;
        BB = CC2(maxMinLimit & (...
            (squareFormFactor & (circleFillingRatio | triangFillingRatio | squareFillingRatio))...
            | (strechedFormFactor & squareFillingRatio)...
            ));
        if isempty(BB)
            BB=[];
        end
    else
        BB=[];
    end
    
    %BoundingBox structure [x, y, width, height]
%     BB = [];
%     for j=1:size(Signals,1)
%         ActualBB.x            = Signals(j).BoundingBox(1);
%         ActualBB.y            = Signals(j).BoundingBox(2);
%         ActualBB.w            = Signals(j).BoundingBox(3);
%         ActualBB.h            = Signals(j).BoundingBox(4);
%         BB = [BB,ActualBB];
%     end
end

