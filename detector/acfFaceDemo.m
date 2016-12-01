addpath(genpath('..'));
cd(fileparts(which('acfFaceDemo.m')));
data_dir_dlib = fullfile('..', 'data', 'dlib_face_detection_dataset');
data_dir = data_dir_dlib;
% data_dir = fullfile('..', 'data', 'Data_WIDER', 'acf_val');
train_set = 'train'; % train or train_tiny
test_set = 'train_tiny';

opts=acfTrain();
opts.modelDs=[72 72];
opts.modelDsPad=[80 80];
opts.nWeak=[32 128 512 2048];
opts.pJitter=struct('flip',1);
opts.pBoost.pTree.fracFtrs=1/16;
pLoad={'lbls',{'face'},'squarify',{0,1}};
opts.pLoad = pLoad;
opts.name='models/Face';

opts.posGtDir=fullfile(data_dir, train_set, 'posGt');
opts.posImgDir=fullfile(data_dir, train_set, 'pos');
opts.negImgDir=fullfile(data_dir_dlib, train_set, 'neg');

% train detector (see acfTrain)
detector = acfTrain( opts );

% modify detector (see acfModify)
pNms = opts.pNms;
pNms.overlap = 0.5;
% pModify=struct('cascThr',-1,'cascCal',-0.008, 'pNms', pNms);
pModify=struct('cascThr',-1,'cascCal', -0.008);
detector=acfModify(detector,pModify);

% run detector on a sample image (see acfDetect)
close all;
imgNms=bbGt('getFiles',{fullfile(data_dir, train_set, 'pos')});
if 0
    I=imread(imgNms{100}); tic, bbs=acfDetect(I,detector); toc
    figure(1); im(I); bbApply('draw',bbs); pause(.1);
end

% test detector and plot roc (see acfTest)
if 1
    [miss,~,gt,dt]=acfTest('name',opts.name,'imgDir',fullfile(data_dir_dlib, test_set, 'pos'),...
        'gtDir',fullfile(data_dir_dlib, test_set, 'posGt'), 'pLoad',opts.pLoad,...
        'pModify',pModify, 'thr', 0.5, 'reapply',1,'show',2);
end

% optionally show top false positives ('type' can be 'fp','fn','tp','dt')
if 0
    bbGt('cropRes',gt,dt,imgNms,'type','fp','n',50,...
        'show',4);%'dims',opts.modelDs([1 1]));
end
