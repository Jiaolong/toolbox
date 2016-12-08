% Test on FDDB dataset
addpath(genpath('..'));
show = false;
data_dir = fullfile('..', 'data', 'Data_FDDB');
save_folder = 'detections-acf-dlib-train';
if ~exist(fullfile(data_dir, save_folder), 'dir')
    mkdir(fullfile(data_dir, save_folder));
end
model_file = fullfile('models_face', 'Face-ACF-DLIB-TRAIN-Detector.mat');
% Load detector
load(model_file);
% modify detector (see acfModify)
pModify=struct('cascThr',-1,'cascCal',-0.008);
detector=acfModify(detector,pModify);

% Run detector
num_folds = 10;
for i=1:num_folds
    fprintf('Detecting on fold %d/%d\n', i, num_folds);
    flist_file = fullfile(data_dir, 'FDDB-folds',...
        sprintf('FDDB-fold-%02d.txt', i));

    % read image names
    fid = fopen(flist_file, 'r');
    C = textscan(fid, '%s');
    fclose(fid);
    img_names = C{1};
    num_images = length(img_names);
    boxes_list = cell(num_images,1);
    % detect on images
    parfor j=1:num_images
        img_file = sprintf('%s/%s.jpg', data_dir, img_names{j});
        I = imread(img_file);
        bbs = acfDetect(I, detector);
        if show
            figure(1); im(I); bbApply('draw',bbs); pause(.1);
        end
        % Write detections into file
        boxes_list{j} = bbs;
    end
    % write detections into file
    save_file = fullfile(data_dir, save_folder, sprintf('fold-%02d-out.txt', i));
    fid = fopen(save_file,'w');
    for j=1:num_images
        fprintf(fid, '%s\n', img_names{j});
        boxes = boxes_list{j};
        fprintf(fid, '%d\n', size(boxes, 1));
        for b=1:size(boxes,1)
            fprintf(fid, '%f %f %f %f %f\n', boxes(b, :));
        end
    end
end
