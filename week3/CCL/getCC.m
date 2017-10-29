function [ CC ] = getCC( mask, avgTotMinSize, avgTotMaxSize, totFillingRatio )
% INPUT: 'mask' mask to obtain CCL
    CCL  = bwconncomp ( mask );
    CC   = regionprops( CCL,'basic' );
    %Delete areas that are greater than area average or are less than area average
    Signals = CC([CC.Area] >= avgTotMinSize & [CC.Area] <= avgTotMaxSize);
    %BB structure [x, y, width, height]
    BB = [];
    for j=1:size(Signals,1)
        ActualBB.BoundingBox  = Signals(j).BoundingBox;
        ActualBB.x            = Signals(j).BoundingBox(1);
        ActualBB.y            = Signals(j).BoundingBox(2);
        ActualBB.w            = Signals(j).BoundingBox(3);
        ActualBB.h            = Signals(j).BoundingBox(4);
        ActualBB.Area         = Signals(j).Area;
        %ActualBB.fillingRatio = sum(sum(mask(round(ActualBB.y : ActualBB.y+ActualBB.h), ...
        %round(ActualBB.x : ActualBB.x+ActualBB.w)))) ...
        %/ ActualBB.Area;
        %if( ActualBB.fillingRatio >= totFillingRatio - totFillingRatio * 0.8 & ...
        %    ActualBB.fillingRatio <= totFillingRatio + totFillingRatio * 0.8 )
        %    BB = [BB,ActualBB];
        %end
        BB = [BB,ActualBB];
    end
end

