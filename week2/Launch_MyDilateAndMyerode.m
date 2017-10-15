clear;clc; close all;
addpath(genpath('../..'))
directory = '../week2';
%directory does not exist
if exist(directory, 'dir') ~= 7
    error('Directory not found');
end
img = imread(strcat(directory, '/lenna.jpg'));

%DILATE
%Create SE
se = ones(10);
%Launch imdilate and mydilate
dilateImg   = imdilate(img,se);
MyDilateImg = mydilate(img,se);
%Save Dilate
imwrite(dilateImg ,strcat(directory, '/lenna_dilate.jpg') );
%Save MyDilate
imwrite(MyDilateImg,strcat(directory, '/lenna_mydilate.jpg') );
%Image differences
Diff = MyDilateImg - dilateImg;
%Save differences
imwrite(Diff      ,strcat(directory, '/lenna_dilate_differences.jpg') );

%ERODE
%Launch imdilate and mydilate
erodeImg   = imerode(img,se);
MyErodeImg = myerode(img,se);
%Save Dilate
imwrite(erodeImg ,strcat(directory, '/lenna_erode.jpg') );
%Save MyDilate
imwrite(MyErodeImg,strcat(directory, '/lenna_myerode.jpg') );
%Image differences
Diff = MyErodeImg - erodeImg;
%Save differences
imwrite(Diff      ,strcat(directory, '/lenna_erode_differences.jpg') );