addpath(genpath('..'));
cd(fileparts(which('acfFaceDemo.m')));
data_dir_dlib = fullfile('..', 'data', 'dlib_face_detection_dataset');
data_dir = data_dir_dlib;
% data_dir = fullfile('..', 'data', 'Data_WIDER', 'acf_val');
train_set = 'train'; % train or train_tiny
test_set = 'train';

opts=acfTrain();
opts.modelDs=[72 72];
opts.modelDsPad=[80 80];
%opts.nWeak=[64 512 1024 2048];
%opts.nWeak=[32 128 512 2048];
opts.pJitter=struct('flip',1);
opts.pBoost.pTree.fracFtrs=1/16;
pLoad={'lbls',{'face'},'squarify',{0,1}};
opts.pLoad = pLoad;
opts.name='models_face/Face-ACF-DLIB-TRAIN-';

opts.pPyramid.pChns.pColor.smooth=0;
opts.pPyramid.pChns.pGradHist.softBin=1;
opts.nWeak=[32 512 1024 2048 4096];
opts.pBoost.pTree.maxDepth=5;
%opts.pBoost.discrete=0;
%opts.pPyramid.pChns.shrink=2;
opts.nNeg=10000; 
opts.nAccNeg=20000;
opts.pNms.overlap = 0.5;

opts.posGtDir=fullfile(data_dir, train_set, 'posGt');
opts.posImgDir=fullfile(data_dir, train_set, 'pos');
opts.negImgDir=fullfile(data_dir_dlib, train_set, 'neg');

% train detector (see acfTrain)
detector = acfTrain( opts );

% modify detector (see acfModify)
%pNms = opts.pNms;
%pNms.overlap = 0.1;
%pModify=struct('cascThr',-1,'cascCal',-0.008, 'pNms', pNms);
pModify=struct('cascThr',-1,'cascCal', -0.008);
detector=acfModify(detector,pModify);

% run detector on a sample image (see acfDetect)
close all;
if 0
	imgNms=bbGt('getFiles',{fullfile(data_dir_dlib, test_set, 'pos')});
    I=imread(imgNms{100}); tic, bbs=acfDetect(I,detector); toc
    figure(1); im(I); bbApply('draw',bbs); pause(.1);
end

% test detector and plot roc (see acfTest)
if 1
    [miss,~,gt,dt]=acfTest('name',opts.name,'imgDir',fullfile(data_dir_dlib, test_set, 'pos'),...
        'gtDir',fullfile(data_dir_dlib, test_set, 'posGt'), 'pLoad',opts.pLoad,...
        'pModify',pModify, 'thr', 0.5, 'reapply',0,'show',2);
end

% optionally show top false positives ('type' can be 'fp','fn','tp','dt')
if 0
	imgNms=bbGt('getFiles',{fullfile(data_dir_dlib, test_set, 'pos')});
    bbGt('cropRes',gt,dt,imgNms,'type','fn','n',50,...
        'show',4, 'dims',opts.modelDs([1 1]));
end
