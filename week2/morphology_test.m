im = imread('morph_test.png');
% im = rgb2gray(imread('foto_carnet.jpg'));

figure,imshow(im);

% se = [1 1 1;
%       0 1 0];
  
% se = [0 1 0;
%       1 1 1;
%       0 1 0];

% se = [1 1 1 1 1 1 1];

% se = ones(20);

% se = ones(20,1);

% se = ones(1, 20);
  
figure,
subplot(2,3,1), imshow(mydilate(im,se));
subplot(2,3,2), imshow(imdilate(im,se));
subplot(2,3,3), imshow(mydilate(im,se)-imdilate(im,se));
subplot(2,3,4), imshow(myerode(im,se));
subplot(2,3,5), imshow(imerode(im,se));
subplot(2,3,6), imshow(myerode(im,se)-imerode(im,se),[]);
