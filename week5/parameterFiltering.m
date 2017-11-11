function [BB] = parameterFiltering(BB)
% Filter by size and form factor
maxMinLimit = [BB.size] <= 54000 & [BB.size] >= 1000; %676 % 42000
squareFormFactor = [BB.ff] <= 1.2 & [BB.ff] >= .85;
strechedFormFactor = [BB.ff] <= .85 & [BB.ff] >= .55; 
strechedFormFactor2 = [BB.ff] <= 1/.55 & [BB.ff] >= 1/.85; 
% circleFillingRatio = [BB.fr] <= .84 & [BB.fr] >= .72;
% triangFillingRatio = [BB.fr] <= .7 & [BB.fr] >= .46;
% squareFillingRatio = [BB.fr] >= .8;
% BB = BB(maxMinLimit & (...
%     (squareFormFactor & (circleFillingRatio | triangFillingRatio | squareFillingRatio))...
%     | (strechedFormFactor & squareFillingRatio)...
%     ));
BB = BB(maxMinLimit & (squareFormFactor | strechedFormFactor | strechedFormFactor2));
if isempty(BB)
    BB=[];
end
end

