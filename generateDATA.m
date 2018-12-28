%%  训练数据生成
classes={'beach','circular_farmland','desert','forest','harbor','meadow','railway'};
ext={'*.jpg'};
train_images = [];
train_labels = [];
test_images = [];
test_labels = [];
set = [];
id = [];
count = 1;
% 对图像进行预处理有两步
% 1. 转为single矩阵
% 2. 将所有图像的每一个通道减去整个训练数据集的平均值
mean1 = 0;
mean2 = 0;
mean3 = 0;

train_1=100;%训练集中的训练
train_2=20;%训练集中的val
test_sample=100;
for i=1:length(classes)
    filepaths=  [];
    filepaths = cat(1,filepaths, dir(fullfile(['数据集4(FNWPU_RESISC45)\',classes{i}], ext{1})));
    for j=1:train_1
        image = importdata(fullfile(['数据集4(FNWPU_RESISC45)\',classes{i}],filepaths(j).name));
        image = single(image);
        train_images(:,:,:,count) = image(1:224,1:224,1:3);%VGG的输入一定为224*224，RGB三通道，选取矩阵的部分
        mean1 = mean1 + mean(mean(train_images(:,:,1,count)))/ (7*train_1);
        mean2 = mean2 + mean(mean(train_images(:,:,2,count)))/ (7*train_1);
        mean3 = mean3 + mean(mean(train_images(:,:,3,count)))/ (7*train_1);
        train_labels(count) = i;
        count = count+1;
    end
end
count = 1;
for i=1:length(classes)
    filepaths=  [];
    filepaths = cat(1,filepaths, dir(fullfile(['数据集4(FNWPU_RESISC45)\',classes{i}], ext{1})));
    for j=(train_1+1):(train_1+train_2)
        image = importdata(fullfile(['数据集4(FNWPU_RESISC45)\',classes{i}],filepaths(j).name));
        image = single(image);
        test_images(:,:,:,count) = image(1:224,1:224,1:3);
        test_labels(count) = i;
        count = count+1;
    end
end
images = cat(4,train_images,test_images);
labels = cat(2,train_labels,test_labels);
images(:,:,1,:)  = images(:,:,1,:)- mean1;
images(:,:,2,:)  = images(:,:,2,:)- mean2;
images(:,:,3,:)  = images(:,:,3,:)- mean3;
id = 1:7*(train_1+train_2);
% set为1，表示训练集，set为2，表示训练时的测试集
set = [ones(1,7*(train_1)) 2*ones(1,7*(train_2))];
images = struct('id',id,'data',images,'label',labels,'set',set);
imdb = struct('images',images);
%% 测试数据数据生成
images2 = [];
labels2 = [];
count = 1;
for i=1:length(classes)
    filepaths=  [];
    filepaths = cat(1,filepaths, dir(fullfile(['数据集4(FNWPU_RESISC45)\',classes{i}], ext{1})));
    for j=(train_1+train_2+1):length(filepaths)
        image = importdata(fullfile(['数据集4(FNWPU_RESISC45)\',classes{i}],filepaths(j).name));
        image = single(image);
        images2(:,:,:,count) = image(1:224,1:224,1:3);
        labels2(count) = i;
        count = count+1;
    end
end
images2(:,:,1,:)  = images2(:,:,1,:)- mean1;
images2(:,:,2,:)  = images2(:,:,2,:)- mean2;
images2(:,:,3,:)  = images2(:,:,3,:)- mean3;
testData = struct('data',images2,'label',labels2);
clear ext i id count filepaths images images2 labels j labels ...
    maxnum num set sets image test_images test_labels...
    train_images train_labels mean1  mean2 mean3