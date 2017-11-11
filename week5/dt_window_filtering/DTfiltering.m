function [BB] = DTfiltering(BB, mask)
% Load templates
template_path = mfilename('fullpath');
template_path = strcat(template_path(1:end-11),'mask_templ');
templ_files = ListFiles(template_path);
templates = cell(length(templ_files),1);
for t=1:length(templ_files)
    templates{t} = edge(imread(strcat(template_path,filesep,templ_files(t).name)),'canny');
end

thresholds = [1100 % A
    1100 % B 
    1600 % CDE
    16000 % F
    %1100 % F1
    16000 % F1sl
    16000 % F1sr
    16000 % F1slr
    16000 % F1srr
    ];

% Compute DT
%edgeim=edge(mask,'canny');
%dt=bwdist(edgeim);
distances = zeros(length(BB),length(templates));
for b=1:length(BB)
    window = mask(floor(BB(b).y):floor(BB(b).y+BB(b).h),floor(BB(b).x):floor(BB(b).x+BB(b).w));
    for t=1:length(templates)
        distances(b,t) = sum(sum(bwdist(edge(imresize(window,size(templates{t})),'canny')).*templates{t}));
    end
end

BB = BB(max(bsxfun(@lt, distances, thresholds'),[],2));

if isempty(BB)
    BB=[];
end
end

