clear;clc; close all;
addpath(genpath('..'));
%Launch getTemplates
[Templates] = get_templates('../DataSet/train/validation_split',true,false);