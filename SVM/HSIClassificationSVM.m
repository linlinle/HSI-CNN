
clc;
clear;
s = getDataSetBasicInformation('Indian_pines');
label=s.y;
image=permute(s.x,[3,1,2]);
%[p m n] = size(image);

% Proportional Division of Training Set and Test Set
ratio=0.1;  % Proportion of training set

train_index=[];
train_set=[];
train_label=[];

test_index=[];
test_set=[];
test_label=[];

for i=1:1:s.class_num
    index=find(label==i);
    sample_number=length(index);
        
    train_oen_index=randsample(index,round(ratio*sample_number));
    train_index=[train_index;train_oen_index];
    train_label=[train_label;label(train_oen_index)];
    train_set=[train_set;image(:,train_oen_index)'];
    
    test_oen_index=setdiff(index,train_oen_index);
    test_index=[test_index;test_oen_index];
    test_label=[test_label;label(test_oen_index)];
    test_set=[test_set;image(:,test_oen_index)'];    
end

% normalization
for i=1:length(train_label)
    train_set(i,:)=train_set(i,:)/norm(train_set(i,:));    
end
for i=1:length(test_label)
    test_set(i,:)=test_set(i,:)/norm(test_set(i,:));
end

% PCA
[coef,score,latent,t2]=princomp(train_set);
x0 = bsxfun(@minus,train_set,mean(train_set,1));
train_set=x0*coef(:,1:80);
x0 = bsxfun(@minus,test_set,mean(test_set,1));
test_set=x0*coef(:,1:80);

% SVM 
opt_svm = '-s 0 -t 2 -c 1024 -g 2^-7 -b 1';
model=svmtrain(train_label,train_set,opt_svm);
[predict_label, a, cof]=svmpredict(test_label,test_set,model,'-b 1');

% Confusion matrix
conf_m=zeros(s.class_num);
for i=1:1:s.class_num
    i_index=find(predict_label==i);
    i_test_label=test_label(i_index);
    for j=1:1:s.class_num
        id=find(i_test_label==j);
        conf_m(i,j)=length(id);
    end
end

% Overall accuracy
Overall_accuracy = sum(diag(conf_m))/sum(sum(conf_m));
% Average accuracy
Average_accuracy = diag(conf_m)'./sum(conf_m);
% Kappa
kappa = kappa(conf_m);

% Drawing plot
Train_image=zeros(s.H,s.W);
Test_image=zeros(s.H,s.W);
Predic_image=zeros(s.H,s.W);

Original_image=label;
Train_image([train_index])=[train_label];
Test_image([test_index])=[test_label];

Predic_image([train_index;test_index])=[train_label;predict_label];
f=figure(1);
set(f, 'Position',  [0 114 1400 600]); 
subplot(121);
imagesc(Original_image);
subplot(122);
imagesc(Predic_image);
changeColorbar(s.class_num);
f2=figure(2);
set(f2,'Position',[0  144 1400 600])
subplot(121);
imagesc(Train_image);
subplot(122);
imagesc(Test_image);
changeColorbar(s.class_num);