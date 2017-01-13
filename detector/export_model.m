% Export the trained ACF cascade model
model_path = fullfile('models_face', 'Face-ACF-DLIB-TRAIN-Detector.mat');

load(model_path);

opts = detector.opts;
clf  = detector.clf;

fids = clf.fids;
thrs = clf.thrs;
child = clf.child;
hs = clf.hs;
weights = clf.weights;
depth = clf.depth;

% size
fid = fopen(fullfile('models_face', 'acf_face_model.bin'), 'w');
fwrite(fid, size(fids), 'uint32');
fclose(fid);

% fids
fid = fopen(fullfile('models_face', 'acf_face_model.bin'), 'a');
fwrite(fid, fids, 'uint32');
fclose(fid);

% thrs
fid = fopen(fullfile('models_face', 'acf_face_model.bin'), 'a');
fwrite(fid, thrs, 'single');
fclose(fid);

% child
fid = fopen(fullfile('models_face', 'acf_face_model.bin'), 'a');
fwrite(fid, child, 'uint32');
fclose(fid);

% hs
fid = fopen(fullfile('models_face', 'acf_face_model.bin'), 'a');
fwrite(fid, hs, 'single');
fclose(fid);

% depth
fid = fopen(fullfile('models_face', 'acf_face_model.bin'), 'a');
fwrite(fid, depth, 'uint32');
fclose(fid);

fprintf('done!');

