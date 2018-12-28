clear;
%% 是否使用预训练网络
usePreNet = 1;

%% 生成数据
generateDATA;

%% 训练和测试
if usePreNet
    loadNetAndChange;
    trainOpts.batchSize = 10 ;
    trainOpts.numEpochs = 3;
    trainOpts.expDir = 'data_fnwpu/vggPreTest' ;
else
    initializeVGG;
    trainOpts.batchSize = 20 ;
    trainOpts.numEpochs = 20;
    trainOpts.expDir = 'data_fnwpu/vggTest' ;
end

trainVGG;

%% 计算测试结果正确率
accuracy = 0;
for i =1:length(res)
    if res(i,1)==res(i,2)
        accuracy= accuracy+1;
    end
end
accuracy = accuracy/(length(res));