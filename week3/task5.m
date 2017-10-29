directory = '../../Dataset/validation_split/mask';

filling_ratio = .6;
fr_margin = .05;

window_w_maxmin=[42 50];
window_h_maxmin=[40 48];

joining_threshold = .5;

addpath('../../');
files = ListFiles(directory);
    
for i=1:size(files,1),
    % Read file
    im = imread(strcat(directory,'/',files(i).name));
     
    tic
    [rows,cols] = size(im);
    nSizes = 6;
    window_w_vector = round(linspace(window_w_maxmin(1),window_w_maxmin(2),nSizes));
    window_h_vector = round(linspace(window_h_maxmin(1),window_h_maxmin(2),nSizes));

    % Try different window sizes
    im_fr = zeros(rows,cols,nSizes);

    for s=1:nSizes    
        window_w = window_w_vector(s);
        window_h = window_h_vector(s);

        im_conv = conv2(double(im),ones(window_w_vector(s),window_h_vector(s)),'same');

        im_fr(:,:,s) = im_conv/(window_h*window_w);
    end

    fr_tresholded =(im_fr  < (filling_ratio+ fr_margin)) & (im_fr > (filling_ratio- fr_margin));

    CCL  = bwconncomp ( fr_tresholded(:,:,end) );
    CC   = regionprops( CCL,'basic' );

    bbox =  cat(1,CC.BoundingBox);
    toc
end