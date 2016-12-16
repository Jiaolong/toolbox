%--------------------------------------------------
% ULSEE-ACF-Detector
%
% Create caltech format ground truth for wider dataset
%
% Copyright (c) 2016
% Written by Jiaolong Xu
%--------------------------------------------------
function create_wider_dataset_cal_format()
setname = 'train';
img_dir = fullfile(sprintf('WIDER_%s', setname), 'images');
load(fullfile('v1', sprintf('wider_face_%s.mat', setname)));
event_num = size(event_list, 1);

display = false;
minsize = 20;
max_num_per_set = 10;

dst_dir = ['acf_' setname];

if exist(dst_dir, 'dir')
    rmdir(dst_dir, 's');
end
mkdir(fullfile(dst_dir, 'pos'));
mkdir(fullfile(dst_dir, 'posGt'));

id = 0;
for i=1:event_num
    fprintf('Creating ACF ground truth: event %d/%d\n', i, event_num);
    img_list = file_list{i};
    bbox_list = face_bbx_list{i};
    img_num = size(img_list, 1);
    inner_count = 0;
    for j=1:img_num
        img_file = sprintf('%s/%s/%s.jpg', img_dir, event_list{i}, img_list{j});
        new_name = sprintf('I%05d', id);
        new_name_img = [new_name '.jpg'];
        new_name_gt  = [new_name '.txt'];
        boxes = bbox_list{j};
        
        if isempty(boxes), continue; end

        if all(boxes == 0), continue; end
        
        im = imread(img_file);
        wm = size(im, 2);
        hm = size(im, 1);
        boxes(:,1) = max(boxes(:, 1), 1);
        boxes(:,2) = max(boxes(:, 2), 2);
        boxes(:,1) = min(boxes(:, 1), wm);
        boxes(:,2) = min(boxes(:, 2), hm);
        boxes(:,3) = min(boxes(:, 3), wm-boxes(:,1));
        boxes(:,4) = min(boxes(:, 4), hm-boxes(:,2));
        
        boxes(boxes(:,3) < minsize, :) = [];
        boxes(boxes(:,4) < minsize, :) = [];
        if isempty(boxes), continue; end
        
        if display
            im = draw_boxes(im, boxes);
        end
       
        if mod(id, 100) == 0
            fprintf('%d\n', id);
        end
        
        if inner_count >= max_num_per_set
            break;
        end
        
        gt_file = fullfile(dst_dir, 'posGt', new_name_gt);
        img_file_dst = fullfile(dst_dir, 'pos', new_name_img);
        
        % Convert to ACF ground truth format
        fid = fopen(gt_file, 'wb');
        fprintf(fid, '%% bbGt version=3\n');
        for b=1:size(boxes,1)
           fprintf(fid, 'face %f %f %f %f 0 0 0 0 0 0 0\n', boxes(b,:));
        end
        fclose(fid);
        % copy image file
        copyfile(img_file, img_file_dst);
        id = id + 1;
        inner_count = inner_count + 1;
    end
end
end

function im = draw_boxes(im, boxes)
image(im);
axis image;
axis off;
boxes(:, 3:4) = boxes(:,1:2) + boxes(:,3:4);
for i=1:size(boxes,1)
    x1 = boxes(i,1);
    y1 = boxes(i,2);
    x2 = boxes(i,3);
    y2 = boxes(i,4);
    line([x1 x1 x2 x2 x1 x1]', [y1 y2 y2 y1 y1 y2]', 'color', 'r',...
    'linewidth', 1, 'linestyle', '-');
end
end
