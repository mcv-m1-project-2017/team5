clear;clc; close all;
addpath(genpath('../..'))
directory = '../../DataSet/train/validation_split';
%directory does not exist
if exist(directory, 'dir') ~= 7
    error('Directory not found');
end
files = ListFiles(directory);
if size(files,1) == 0
    error('Directory is empty');
end

if exist (strcat(directory, '/MeanShift_mask' ), 'dir') ~= 7
    mkdir(strcat(directory, '/MeanShift_mask' ));
end
if exist( strcat(directory, '/MeanShift_equalize_mask' ), 'dir') ~= 7
    mkdir(strcat(directory, '/MeanShift_equalize_mask' ));
end

% meanshift parameter
bw   = 0.2;% Mean Shift Bandwidth
e = 0;
for i=1:size(files,1)
    t = cputime;
    % Read image
    Img      = imread(strcat(directory, '/'                   , files(i).name(1:size(files(i).name,2)-3), 'jpg'));
    path     =        strcat(directory, '/MeanShift_mask/'    , files(i).name(1:size(files(i).name,2)-3), 'png');
    equpath  =        strcat(directory, '/MeanShift_equalize_mask/', files(i).name(1:size(files(i).name,2)-3), 'png');
    [Ims, Nms]   = Ms(Img,bw); % Mean Shift (color)
    EquImg = EqualizeImage(Ims);
    EquImg = rgb2gray(EquImg);
    Ims    = rgb2gray(Ims);
    [n,m] = size(Ims);
    % Create Mask
    Mask = zeros(n,m);
    for i = 1:n
        for j = 1:m
            if ( Ims(i,j) >= 0.15 && Ims(i,j) <= 0.45 )
                Mask(i,j) = 1;
            end
        end
    end
    [n,m] = size(EquImg);
    Mask1 = zeros(n,m);
    for i = 1:n
        for j = 1:m
            if ( EquImg(i,j) >= 0.15 && EquImg(i,j) <= 0.45 )
                Mask1(i,j) = 1;
            end
        end
    end
    imwrite(Mask ,path   );
    imwrite(Mask1,equpath);
    e = e + cputime-t;
end
%Time average
e / size(files,1)




