% Diferent Images to test
% im = uint8([0, 0, 0, 0, 0, 0;
%             0, 1, 0, 0, 0, 0;
%             0, 0, 0, 0, 0, 0;
%             0, 0, 0, 1, 0, 0;
%             0, 1, 0, 0, 0, 0;
%             0, 0, 0, 0, 0, 0;]);

% im = uint8([0, 0, 0, 0, 0, 0;
%             0, 1, 0, 3, 0, 0;
%             0, 0, 2, 0, 7, 0;
%             0, 0, 0, 1, 0, 0;
%             0, 1, 5, 0, 0, 0;
%             0, 0, 0, 0, 0, 0;]);
        
% im = imread('morph_test.png');
% im = imread('DilationErosionTest.png');
% im = imread('cameraman.tif');
%im = rgb2gray(imread('00.005893.jpg'));
im = imread('00.005893.jpg');

% figure,imshow(im,[]);

% Diferent Structural Elements to test
% se = [1 1 1;
%       0 1 0];

%  se = [0 1 0;
%        1 1 1;
%        0 1 0];
  
% se = [1 1 1 1 1 1 1];
% se = ones(20);
se = ones(20,2);
% se = ones(1, 20);
  
tic
mydil = mydilate(im,se);
mydil_time = toc;

tic
dil = imdilate(im,se);
dil_time = toc;

tic
myero = myerode(im,se);
myero_time = toc;

tic
ero = imerode(im,se);
ero_time = toc;

figure,
subplot(2,3,1), imshow(mydil,[])    , title('mydilate');
subplot(2,3,2), imshow(dil,[])      , title('imdilate');
subplot(2,3,3), imshow(mydil-dil,[]), title('difference');
subplot(2,3,4), imshow(myero,[])    , title('myerode');
subplot(2,3,5), imshow(ero,[])      , title('imerode');
subplot(2,3,6), imshow(myero-ero,[]), title('difference');


% opening = myOpeningClosing(im, se, 0);
% closing = myOpeningClosing(im, se, 1);
% topHat = myTopHat(im, se, 0);
% topHatDual = myTopHat(im, se, 1);
% 
% figure,
% subplot(2,2,1), imshow(opening,[]), title('Opening');
% subplot(2,2,2), imshow(closing,[]), title('Closing');
% subplot(2,2,3), imshow(topHat,[]), title('Top Hat');
% subplot(2,2,4), imshow(topHatDual,[]), title('Top Hat Dual');

fprintf('\n');
fprintf('imdilate : %f sec\n', dil_time);
fprintf('mydilate : %f sec\n', mydil_time);
fprintf('efficency : %f %%\n', 100*(mydil_time/dil_time));
fprintf('\n');
fprintf('imerode : %f sec\n', ero_time);
fprintf('efficency : %f sec\n', myero_time);
fprintf('erode : %f %%\n', 100*(myero_time/ero_time));
fprintf('\n');
