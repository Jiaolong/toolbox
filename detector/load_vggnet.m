function net = load_vggnet(path_matconvnet, model_name)

% add matconvnet into path
addpath(fullfile(path_matconvnet, 'matlab'));
% setup
vl_setupnn ;
% model path
model_path = fullfile(path_matconvnet, 'models', model_name);
% Load a model and upgrade it to MatConvNet current version.
net = load(model_path) ;
net = vl_simplenn_tidy(net) ;
end