clear;
%% �Ƿ�ʹ��Ԥѵ������
usePreNet = 1;

%% ��������
generateDATA;

%% ѵ���Ͳ���
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

%% ������Խ����ȷ��
accuracy = 0;
for i =1:length(res)
    if res(i,1)==res(i,2)
        accuracy= accuracy+1;
    end
end
accuracy = accuracy/(length(res));