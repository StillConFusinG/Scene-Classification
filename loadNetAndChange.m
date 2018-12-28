net = load('imagenet-vgg-f');
fc8l = cellfun(@(a) strcmp(a.name, 'fc8'), net.layers)==1;
nCls = 7;
sizeW = size(net.layers{fc8l}.weights{1});
% 将权重初始化
if sizeW(4)~=nCls
  net.layers{fc8l}.weights = {zeros(sizeW(1),sizeW(2),sizeW(3),nCls,'single'), ...
    zeros(1, nCls, 'single')};
end
net.layers{end} = struct('name','loss', 'type','softmaxloss') ;