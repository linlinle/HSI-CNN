
% 程序信息  这是基本的SVM对HSI图像 Indian_pines的分类程序
% 从数据的导入，到最后给出分类精度，Kappa系数，以及对应
% 展示原始图和分类结果图
% 作者：赵振凯  南京师范大学计算机院-13级   邮箱  : zzkgo@qq.com   qq:691960830

clc;
clear;

load('Indian_pines_corrected');
load('Indian_pines_gt');
label=indian_pines_gt;
image=permute(indian_pines_corrected,[3,1,2]);

%其中共有16个类别-对应每个类别数据大小
%1.Alfalfa  46
%2.Corn-no till 1428
%3.Corn-min till 830
%4.Corn 237
%5.Hay-windowed 483
%6.Grass/trees 730
%7.Grass/pasture-mowed 28
%8.Grass/pasture  478
%9.Otas 20
%10.Soybeans-no till 972
%11.Soybeans-min till 2455
%12.Soybeans-clean till 593
%13.Wheat 205
%14.Woods 1265
%15.Bldg-Grass-Tree-Drives 386
%16. Stone-steel towers 93
classnum=16;

%选取其中的 10%作为训练集合
par=0.1;

train_index=[];
train_set=[];
train_label=[];

test_index=[];
test_set=[];
test_label=[];

for i=1:1:classnum
    index=find(label==i);
    len=length(index);
    
    t_index=randsample(index,round(par*len));
    train_index=[train_index;t_index];
    train_label=[train_label;label(t_index)];
    train_set=[train_set;image(:,t_index)'];
    
    tt_index=setdiff(index,t_index);
    test_index=[test_index;tt_index];
    test_label=[test_label;label(tt_index)];
    test_set=[test_set;image(:,tt_index)'];
    
end

%%                   归一化

% 
% for i=1:length(train_label)
%     train_set(i,:)=train_set(i,:)/norm(train_set(i,:));    
% end
train_set = mapminmax(train_set);


% for i=1:length(test_label)
% test_set(i,:)=test_set(i,:)/norm(test_set(i,:));
% 
% end
test_set = mapminmax(test_set);

%%                       随机模块
                  
trainlabel_data = [train_label,train_set];
testlabel_data = [test_label,test_set];
RandIndex = randperm( length( trainlabel_data ) ); 
data_label_random_train = trainlabel_data( RandIndex,: );
RandIndex = randperm( length( testlabel_data ) ); 
data_label_random_test = testlabel_data( RandIndex,: );
train_label = data_label_random_train(:,1);
train_set = data_label_random_train(:,2:201);
test_label = data_label_random_test(:,1);
test_set = data_label_random_test(:,2:201);
%%
[coef,score,latent,t2]=princomp(train_set);
x0 = bsxfun(@minus,train_set,mean(train_set,1));
train_set=x0*coef(:,1:80);
x0 = bsxfun(@minus,test_set,mean(test_set,1));
test_set=x0*coef(:,1:80);
% all_data=[train_set;test_set];
% for i=1:200
%    % all_data(:,i)=(all_data(:,i)-min(all_data(:,i)))/(max(all_data(:,i))-min(all_data(:,i)));
%     all_data(:,i)=all_data(:,i)/norm(all_data(:,i));
% end
% train_set=all_data(1:1027,:);
% test_set=all_data(1028:10249,:);


%    OPT_SVM的参数  
%其中的b是表示是否probability_estimates: whether to train a SVC or SVR model for probability estimates, 0 or 1 (default 0)

opt_svm='-s 0 -t 2 -c 1024 -g 2^-7 -b 1'
model=svmtrain(train_label,train_set,opt_svm);
[predict_label a cof]=svmpredict(test_label,test_set,model,'-b 1');


%展示顺序：计算误差矩阵   计算精度总体精度   计算平均精度   计算kappa系数
%绘制图像:   原始图   训练集合图   测试集合图    分类结果图 
%程序编写

%混淆矩阵计算得到
conf_m=zeros(classnum);
for i=1:1:classnum
    i_index=find(predict_label==i);
    i_test_label=test_label(i_index);
    for j=1:1:classnum
        id=find(i_test_label==j);
        conf_m(i,j)=length(id);
    end
end
%计算整体精度
Overall_accuracy=sum(diag(conf_m))/sum(sum(conf_m));
%计算平均精度
Overall_accuracy_PerClass=diag(conf_m)'./sum(conf_m);
%计算Kappa系数
kappa=kappa(conf_m);

%绘制图像    原始图   训练集合图   测试集合图    分类结果图 
Original_image=zeros(145,145);
Train_image=zeros(145,145);
Test_image=zeros(145,145);
Predic_image=zeros(145,145);

Original_image=label;
Train_image([train_index])=[train_label];
Test_image([test_index])=[test_label];

Predic_image([train_index;test_index])=[train_label;predict_label];
f=figure(1);set(f, 'Position',  [0 114 1400 600]); 
subplot(121);
imagesc(Original_image);
subplot(122);
imagesc(Predic_image);
f2=figure(2);
set(f2,'Position',[0  144 1400 600])
subplot(131);
imagesc(Predic_image);
subplot(132);
imagesc(Train_image);
subplot(133);
imagesc(Test_image);

