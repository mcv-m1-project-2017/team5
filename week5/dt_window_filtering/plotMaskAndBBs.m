function plotMaskAndBBs(mask,windowCandidates)
imshow(mask);
hold on;
for i=1:length(windowCandidates)
    rectangle('Position',[windowCandidates(i).x windowCandidates(i).y  windowCandidates(i).w windowCandidates(i).h],'EdgeColor',[1 0 0]);
end
% for i=find(fileIndex==f)'
%     rectangle('Position',[annotations(i).x annotations(i).y  annotations(i).w annotations(i).h],'EdgeColor',[0 1 0]);
% end
hold off;
end

