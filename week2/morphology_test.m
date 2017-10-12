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
% im = rgb2gray(imread('foto_carnet.jpg'));
% im = imread('foto_carnet.jpg');
im = rgb2gray(imread('00.005893.jpg'));
% im = imread('00.005893.jpg');

% figure,imshow(im,[]);

% Diferent Structural Elements to test
% se = [1 1 1;
%       0 1 0];

% se = [0 1 0;
%       1 1 1;
%       0 1 0];
  
% se = [1 1 1 1 1 1 1];
se = ones(20);
% se = ones(20,1);
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

fprintf('dilate : %f\n', mydil_time/dil_time);

fprintf('erode : %f\n', myero_time/ero_time);
