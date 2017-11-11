%% Parameters
clear;clc;
name_for_the_execution = 'Prueba';

% '../Dataset/train_split'
% '../Dataset/validation_split'
input_directory = '../Dataset/train_split';
show_output_images = 0;
% '../WindowResults/validation_split/FullProcess'
% '../WindowResults/train_split/FullProcess';
output_directory = '../WindowResults/train_split/FullProcess';

% Add needed paths
addpath(genpath('windows'))
addpath(genpath('dataset_analysis'))
addpath(genpath('color_segmentation'))
addpath(genpath('evaluation'))
addpath(genpath('morphology'))

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% CONSTANTS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fails = [24 26 41 42 46 52 53 54 55 56 57 59 61 63 64 65 68 69 79 82 83 85 90 95 96 103 107 113 117 118 125 130 131 138 142 146 147 148 151 ];
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Test begin
output_directory = strcat(output_directory,filesep,name_for_the_execution,'-',strrep(int2str(clock),' ',''),'/');

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
    fprintf('..%d',f);
    
    % Read file
    im = imread(strcat(input_directory, filesep, files(f).name(1:size(files(f).name,2)-3), 'jpg'));
    
    tic;
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %                   FILL THIS WITH THE TESTING CODE                       %
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    mask = colorSegmentationT4W2(im);
    mask = morphologyMyVersion(mask);
    detections = getCCMultiFilter(mask,im);
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Output: detections, mask
    tpf=tpf + toc;
    
    %Evaluate
    [pixelTP, pixelFN, pixelFP] = PerformanceAccumulationWindow(detections, annotations(fileIndex==f));
    
    [pixelPrecision, pixelSensitivity, pixelAccuracy] = PerformanceEvaluationWindow(pixelTP, pixelFN, pixelFP);
    pixelRecall = pixelTP/(pixelTP+pixelFN);
    pixelF1 = 2 * (pixelPrecision * pixelRecall)/(pixelPrecision + pixelRecall + ((pixelPrecision + pixelRecall)==0) );
    if pixelSensitivity~=1
        fprintf('<<');
        %show_output_images=1;
    end
    if show_output_images
        imshow(mask);
        hold on;
        for i=1:length(detections)
            rectangle('Position',[detections(i).x detections(i).y  detections(i).w detections(i).h],'EdgeColor',[1 0 0]);
        end
        for i=find(fileIndex==f)'
            rectangle('Position',[annotations(i).x annotations(i).y  annotations(i).w annotations(i).h],'EdgeColor',[0 1 0]);
        end
        hold off;
        pause;
        close;
        % imwrite(FinalMask,strcat(output_directory,'mask.', files(f).name(1:size(files(f).name,2)-3), 'png'));
    end
    show_output_images=0;
    
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
save(strcat(output_directory,'results.mat'),'total_time','tpf','precision','recall','f1','sensitivity','tp','fp','fn','accuracy');