%% Parameters
clear;clc;
name_for_the_execution = 'MyVersion-T4Disk6'
% training_directory = '../../Dataset/train_split';
%validation_split
input_directory = '../Dataset/validation_split';
write_output_images = 0;
output_directory = '../Results/validation_split';

% Add needed paths
addpath(genpath('color_segmentation'))
addpath(genpath('morphology'))
addpath(genpath('evaluation'))

%% Test begin
output_directory = strcat(output_directory,'/',name_for_the_execution,'-',strrep(int2str(clock),' ',''),'/');

% Load file annotations and names
[ files, fileIndex, annotations, signType ] = LoadAllFileAnnotations( input_directory);

mkdir(output_directory);

precision=0;
recall=0;
f1=0;
sensitivity=0;
tpf=0;
tp=0;
fp=0;
fn=0;
accuracy=0;

init_clock = clock;
f_vector = 1:length(files); % fileIndex(ismember(signType,[1 2 3]))'  [4 6]
for f=f_vector
    fprintf('%d..',f);
    
    % Read file
    im = imread(strcat(input_directory,'/',files(f).name));
    pixelAnnotation = imread(strcat(input_directory, '/mask/mask.', files(f).name(1:size(files(f).name,2)-3), 'png'))>0;
    
    tic;
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %                   FILL THIS WITH THE TESTING CODE                       %
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    mask=colorSegmentationT4W2(im);
    FinalMask = morphologyMyVersion(mask);
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Output: FinalMask
    tpf=tpf + toc;
    
    %Evaluate
    [pixelTP, pixelFP, pixelFN, pixelTN] = PerformanceAccumulationPixel(FinalMask, pixelAnnotation);
    
    [pixelPrecision, pixelAccuracy, pixelSpecificity, pixelSensitivity] = PerformanceEvaluationPixel(pixelTP, pixelFP, pixelFN, pixelTN);
    pixelRecall = pixelTP/(pixelTP+pixelFN);
    pixelF1 = 2 * (pixelPrecision * pixelRecall)/(pixelPrecision + pixelRecall + ((pixelPrecision + pixelRecall)==0) );
    
    if write_output_images
        imwrite(FinalMask,strcat(output_directory,'mask.', files(f).name(1:size(files(f).name,2)-3), 'png'));
    end
    
    precision= pixelPrecision + precision;
    recall = pixelRecall + recall;
    f1 = pixelF1 + f1;
    sensitivity = pixelSensitivity + sensitivity;
    tp=pixelTP + tp;
    fp=pixelFP + fp;
    fn=pixelFN + fn;
    accuracy=pixelAccuracy + accuracy;
end
precision = precision / length(f_vector);
recall = recall / length(f_vector);
f1 = f1/ length(f_vector);
sensitivity = sensitivity / length(f_vector);
tpf = tpf / length(f_vector);
tp = tp / length(f_vector);
fp = fp / length(f_vector);
fn = fn / length(f_vector);
accuracy = accuracy / length(f_vector);
fprintf('\n');
end_clock = clock;
total_time = etime(end_clock,init_clock);
fprintf('Total time consumed %.3f seconds\n',total_time);
fprintf('Time per frame: %.3f seconds\n',tpf);
fprintf('Precision: %.3f\n',precision);
fprintf('Recall: %.3f\n',recall);
fprintf('F1: %.3f\n',f1);
fprintf('Sensitivity: %.3f\n',sensitivity);
fprintf('Accuracy: %.3f\n',accuracy);
fprintf('TP: %.3f\n',tp);
fprintf('FP: %.3f\n',fp);
fprintf('FN: %.3f\n',fn);
save(strcat(output_directory,'results.mat'),'total_time','tpf','precision','recall','f1','sensitivity');