function [train_set,train_label,train_index,test_set,test_label,test_index]=TrainAndTestGet(image,image_label,classnum,ratio)
%数据处理----从原始数据---->获得训练集和测试集
%原始数据要求
% image   145*145*200     200代表数据特征维数    image_label 145*145大小 代表类别标签 1,2,3,4,5,6，...16 
%classnum 代表其中类别数目
%获取到的数据集 已经



label=image_label;
image=permute(image,[3,1,2]);


classnum=16;

%选取其中的 10%作为训练集合
par=ratio;

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




for i=1:length(train_label)
    train_set(i,:)=train_set(i,:)/norm(train_set(i,:));    
end


for i=1:length(test_label)
test_set(i,:)=test_set(i,:)/norm(test_set(i,:));

end

