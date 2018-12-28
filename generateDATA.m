%%  ѵ����������
classes={'beach','circular_farmland','desert','forest','harbor','meadow','railway'};
ext={'*.jpg'};
train_images = [];
train_labels = [];
test_images = [];
test_labels = [];
set = [];
id = [];
count = 1;
% ��ͼ�����Ԥ����������
% 1. תΪsingle����
% 2. ������ͼ���ÿһ��ͨ����ȥ����ѵ�����ݼ���ƽ��ֵ
mean1 = 0;
mean2 = 0;
mean3 = 0;

train_1=100;%ѵ�����е�ѵ��
train_2=20;%ѵ�����е�val
test_sample=100;
for i=1:length(classes)
    filepaths=  [];
    filepaths = cat(1,filepaths, dir(fullfile(['���ݼ�4(FNWPU_RESISC45)\',classes{i}], ext{1})));
    for j=1:train_1
        image = importdata(fullfile(['���ݼ�4(FNWPU_RESISC45)\',classes{i}],filepaths(j).name));
        image = single(image);
        train_images(:,:,:,count) = image(1:224,1:224,1:3);%VGG������һ��Ϊ224*224��RGB��ͨ����ѡȡ����Ĳ���
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
    filepaths = cat(1,filepaths, dir(fullfile(['���ݼ�4(FNWPU_RESISC45)\',classes{i}], ext{1})));
    for j=(train_1+1):(train_1+train_2)
        image = importdata(fullfile(['���ݼ�4(FNWPU_RESISC45)\',classes{i}],filepaths(j).name));
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
% setΪ1����ʾѵ������setΪ2����ʾѵ��ʱ�Ĳ��Լ�
set = [ones(1,7*(train_1)) 2*ones(1,7*(train_2))];
images = struct('id',id,'data',images,'label',labels,'set',set);
imdb = struct('images',images);
%% ����������������
images2 = [];
labels2 = [];
count = 1;
for i=1:length(classes)
    filepaths=  [];
    filepaths = cat(1,filepaths, dir(fullfile(['���ݼ�4(FNWPU_RESISC45)\',classes{i}], ext{1})));
    for j=(train_1+train_2+1):length(filepaths)
        image = importdata(fullfile(['���ݼ�4(FNWPU_RESISC45)\',classes{i}],filepaths(j).name));
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