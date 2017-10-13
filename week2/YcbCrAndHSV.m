function [masks, txf] = YcbCrAndHSV(img_dir, test_files)

% INPUT: 'img_dir' directory of the files provided for training
%        'test_files' cell array containing the name of all test files
%

masks = cell([1 length(test_files)]); % cell array to store output masks
time = zeros([1 length(test_files)]); % vector to store time per frame

for i=1:length(test_files)
    tic; % Start timer
    % Read current image and convert it to YCbCr and HSV colorspaces
    im = imread(strcat(img_dir,'/',test_files(i).name(1:size(test_files(i).name,2)-3), 'jpg'));
    imYCbCr= rgb2ycbcr(im);
    imHSV = rgb2hsv(im);
    % Use COLOR SEGMENTATION to create a mask
    % Red
    mask_Cr = imYCbCr(:,:,3) > 135 & imYCbCr(:,:,3) < 175;
    mask_RH = imHSV(:,:,1)>0.9 | imHSV(:,:,1)<0.03;
    mask_RED = and(mask_Cr,mask_RH);
    % Blue
    mask_Cb = imYCbCr(:,:,2) > 135 & imYCbCr(:,:,2) < 175 & imYCbCr(:,:,1) < 175;             
    mask_BH = imHSV(:,:,1)>0.55 & imHSV(:,:,1)<0.7;
    mask_BLUE = and(mask_Cb,mask_BH);   
    % Final
    final_mask = or(mask_BLUE,mask_RED);
    masks{i} = final_mask; % store current mask

    % stop timer and store required time to create the current mask
    time(i) = toc; 
end

txf = mean(time); % return average time per frame
end
