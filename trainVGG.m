% 设置训练参数
trainOpts.continue = true ;
trainOpts.gpus = [] ;
trainOpts.learningRate = 0.001 ;


% 对图像进行预处理
imdb.images.data = single(imdb.images.data);


% 生成训练数据
% 如果使用gpu
if numel(trainOpts.gpus) > 0
  imdb.images.data = gpuArray(imdb.images.data) ;
end

% 训练网络
[net,info] = cnn_train1(net, imdb, @getBatch, trainOpts) ;

% 如果使用gpu
if numel(trainOpts.gpus) > 0
  net = vl_simplenn_move(net, 'cpu') ;
end

net.layers{end} =  struct('type', 'softmax') ;
net =  vl_simplenn_tidy(net) ;
%% 测试网络
for i = 1:size(testData.data,4)
    im = im2single(testData.data(:,:,:,i));
    res1 = vl_simplenn(net,im);
    res2 = squeeze(res1(end).x);
    [best,bestnum] = max(res2);
    res(i,1) = bestnum;
    res(i,2) = testData.label(i);
end

clear im res1 res2 best bestnum;

