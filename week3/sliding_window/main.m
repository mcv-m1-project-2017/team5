clear;
im = imread('mask3.png')>0;
filling_ratio = .6;
window_w=42;
window_h=48;
joining_threshold = .4;
tic
[ uniqueWindowCandidates ] = SlidingWindow( im, window_w, window_h,filling_ratio,joining_threshold,10);
toc
imshow(im);
hold on;
for i=1:length(uniqueWindowCandidates)
    rectangle('Position',[uniqueWindowCandidates(i).x uniqueWindowCandidates(i).y  window_w window_h],'EdgeColor',[1 1 0]);
end