function F = customfeat_vgg( I, net, layer_idx )
% compute CNN feature from vgg network
%   F = vgg_featmap( I, net )
% INPUT:
%       - I:  inpute image (default: RGB image)
%       - net: loaded matconvnet
%       - layer_idx: the index of feature layer
% OUTPUT:
%       -F: output feature map

if isempty(I)
    F = [];
    return;
end

im = single(I) ; % note: 255 range
% padding
im_pad = single(zeros(size(im,1) + 8, size(im,2) + 8, size(im,3)));
im_pad(5:end-4, 5:end-4, :) = im;
%im_ = imresize(im_, net.meta.normalization.imageSize(1:2)) ;
%im_ = im_ - net.meta.normalization.averageImage ;
% 124, 117, 104
% mean = zeros(size(im_pad));
% mean(:,:,1) = 124;
% mean(:,:,2) = 117;
% mean(:,:,3) = 104;
% im_pad = im_pad - mean;

% Run the CNN.
res = vl_simplenn(net, im_pad);
F = res(layer_idx).x;
end