function [masks, txf] = YcbCrAndHSV(img_dir, test_files, type)

% INPUT: 'img_dir' directory of the files provided for training
%        'test_files' cell array containing the name of all test files
%        'type' 0 YCbCr AND HSV
%        'type' 1 HSV

masks = cell([1 length(test_files)]); % cell array to store output masks
time = zeros([1 length(test_files)]); % vector to store time per frame

for i=1:length(test_files)
    tic; % Start timer
    im = imread(strcat(img_dir,'/',test_files(i).name(1:size(test_files(i).name,2)-3), 'jpg'));
    switch(type)
        case 0
            % convert image to YCbCr and HSV colorspaces
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
            masks{i} = or(mask_BLUE,mask_RED); % store current mask
        case 1
            % Convert image to HSV color space
            imHSV = rgb2hsv(im);
            % Split the channels
            h = imHSV(:,:,1).*360;
            s = imHSV(:,:,2);
            v = imHSV(:,:,3);
            %Define Red and blue thresholds
            hred   = [350 20];
            hblueA = [180 250];
            hblueB = [210 300];
            sred = 0.45;
            sblueA = 0.4;
            sblueB = [0.15 0.4];
            vred = 0;
            vblueB = 0.3;
            %Create red and blue masks
            red = ((((h<hred(2))&(h>=0))|((h<=360)&(h>hred(1))))&(s>sred)&(v>vred));
            blueA = ((h<hblueA(2)) & (h>hblueA(1)) & (s>sblueA));
            blueB = ((h<hblueB(2)) & (h>hblueB(1)) & (s>sblueB(1)) & (s<sblueB(2))) &(v<vblueB);
            %Create final mask
            masks{i} = or(or(red,blueA),blueB);% store current mask
        otherwise
            error('stament is not valid, try with 0 or 1');
    end
    % stop timer and store required time to create the current mask
    time(i) = toc; 
end

txf = mean(time); % return average time per frame
end
