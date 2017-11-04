clear;clc; close all;
addpath(genpath('..'));
%Launch getTemplates
[Templates] = get_templates('../DataSet/train/train_split',true,false);