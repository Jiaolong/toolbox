% Test a ACF face detector on WIDER validation set

show = false;
data_dir = fullfile('..', 'data', 'Data_WIDER');
images_root = fullfile(data_dir, 'WIDER_Val', 'images');

model_file = fullfile('models', 'Face-WIDER-VAL-Detector.mat');
save_name = 'pred_list.mat';
save_dir = fullfile(data_dir, 'eval_tools', 'detections-acf-wider-val');
if ~exist(save_dir, 'dir')
    mkdir(save_dir);
end
% Read validation set
load(fullfile(data_dir, 'v1', 'wider_face_val.mat'));
event_num = 61;
pred_list = cell(event_num, 1);

% Load detector
load(model_file);
% modify detector (see acfModify)
pModify=struct('cascThr',-1,'cascCal',-0.008);
detector=acfModify(detector,pModify);

% Run detector
for i=1:event_num
    fprintf('Detection: current event %d\n', i);
    img_list = file_list{i};
    img_num = size(img_list, 1);
    bbox_list = cell(img_num, 1);
    for j=1:img_num
        img_file = sprintf('%s/%s/%s.jpg', images_root, event_list{i}, img_list{j});
        I = imread(img_file);
        bbs = acfDetect(I, detector);
        if show
            figure(1); im(I); bbApply('draw',bbs); pause(.1);
        end
        % Write detections into file
        bbox_list{j} = bbs;
    end
    pred_list{i} = bbox_list;
end

% save detections
save(fullfile(save_dir, save_name), 'pred_list');
