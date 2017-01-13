addpath(genpath('..'));
name = 'Face-ACF-DLIB-TRAIN';
model_file = fullfile('models_face', [name '-Detector.mat']);
% Load detector
load(model_file);
% modify detector (see acfModify)
pModify=struct('cascThr',-1,'cascCal',-0.008);
detector=acfModify(detector,pModify);
% detector.opts.pPyramid.pChns.pGradHist.binSize = 2;
I=imread('../data/test_data/test2.jpg'); 
tic, bbs=acfDetect(I,detector); toc
bbs
figure(1); 
im(I); 
bbApply('draw',bbs);