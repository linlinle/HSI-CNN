function [] = cifar_India_Datapreprocessing()
%CNN_HSIDATEPROCESS Summary of this function goes here
%   Detailed explanation goes here
load Indian_pines_corrected
load Indian_pines_gt
data_3D = indian_pines_corrected;
label_3D = indian_pines_gt;
[m,n,d] = size(data_3D);
label_number = max(max(label_3D));
d1 = (floor(sqrt(d)))^2;
label_list = 1:label_number;
one = zeros(1,label_number);
for i= 1:1:label_number
    one(i)=length(find(label_3D==label_list(i)));
end
data_2D = hyperConvert2d(data_3D(:,:,1:d1));
%%                ¹éÒ»»¯
%data_2D = hyperNormalize(data_2D); % 0 ~ 1
%data_2D = mapminmax(data_2D);      %-1 ~ 1
%u = mean(data_2D.').';
%data_2D = data_2D - repmat(u, 1, m*n);
%%             
label_2D = reshape(label_3D,m*n,1);
data_2D_1 = data_2D';
label_data = [double(label_2D),data_2D_1];
data_label_order_train1 = [];
data_label_order_train2 = [];
data_label_order_train3 = [];
data_label_order_train4 = [];
data_label_order_train5 = [];
data_label_order_test = [];
train_test = [];
for i=1:1:label_number
    row_index = label_data(:,1) == label_list(i);
    data_label_mid = label_data(row_index,:);
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%very important%%%%%%%%%%%
    RandIndex = randperm(one(i)); 
    data_label_mid = data_label_mid( RandIndex,: );
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    train_one = floor(one(i)*1/6);
   %test_one = one(i)-5*train_one;  
    for j=1:1:6
        train_test(:,:,j) = data_label_mid(1+(j-1)*train_one:j*train_one,:);
    end
    

%     mid_train = data_label_mid(1:train_one,:);
%     mid_test = data_label_mid(train_one+1:one(i),:);
    data_label_order_test = [data_label_order_test;train_test(:,:,1)];
    data_label_order_train1 = [data_label_order_train1;train_test(:,:,2)];
    data_label_order_train2 = [data_label_order_train2;train_test(:,:,3)];
    data_label_order_train3 = [data_label_order_train3;train_test(:,:,4)];
    data_label_order_train4 = [data_label_order_train4;train_test(:,:,5)];
    data_label_order_train5 = [data_label_order_train5;train_test(:,:,6)];
    clear train_test;
        
end
RandIndex = randperm( length( data_label_order_test ) ); 
data_label_random_test = data_label_order_test( RandIndex,: );
RandIndex = randperm( length( data_label_order_train1 ) ); 
data_label_random_train1 = data_label_order_train1( RandIndex,: );
RandIndex = randperm( length( data_label_order_train2 ) ); 
data_label_random_train2 = data_label_order_train2( RandIndex,: );
RandIndex = randperm( length( data_label_order_train3 ) ); 
data_label_random_train3 = data_label_order_train3( RandIndex,: );
RandIndex = randperm( length( data_label_order_train4 ) ); 
data_label_random_train4 = data_label_order_train4( RandIndex,: );
RandIndex = randperm( length( data_label_order_train5 ) ); 
data_label_random_train5 = data_label_order_train5( RandIndex,: );
batch_label = 'testing batch 1 of 1';
data = data_label_random_test(:,2:d1+1);
labels = data_label_random_test(:,1);
save test_batch batch_label data labels
batch_label = 'training batch 1 of 5';
data = data_label_random_train1(:,2:d1+1);
labels = data_label_random_train1(:,1);
save data_batch_1 batch_label data labels
batch_label = 'training batch 2 of 5';
data = data_label_random_train2(:,2:d1+1);
labels = data_label_random_train2(:,1);
save data_batch_2 batch_label data labels
batch_label = 'training batch 3 of 5';
data = data_label_random_train3(:,2:d1+1);
labels = data_label_random_train3(:,1);
save data_batch_3 batch_label data labels
batch_label = 'training batch 4 of 5';
data = data_label_random_train4(:,2:d1+1);
labels = data_label_random_train4(:,1);
save data_batch_4 batch_label data labels
batch_label = 'training batch 5 of 5';
data = data_label_random_train5(:,2:d1+1);
labels = data_label_random_train5(:,1);
save data_batch_5 batch_label data labels
X = java_array('java.lang.String', 16);
X(1) = java.lang.String('Asphalt');
X(2) = java.lang.String('Meadows');
X(3) = java.lang.String('Gravel');
X(4) = java.lang.String('Trees');
X(5) = java.lang.String('Painted metal sheets');
X(6) = java.lang.String('Bare Soil	');
X(7) = java.lang.String('Bitumen');
X(8) = java.lang.String('Self-Blocking Bricks');
X(9) = java.lang.String('Shadows');
% X(10) = java.lang.String('Wheat');
% X(11) = java.lang.String('Woods');
% X(12) = java.lang.String('Buildings-Grass-Trees-Drives');
% X(13) = java.lang.String('Stone-Steel-Towers');
% X(14) = java.lang.String('Oats');
% X(15) = java.lang.String('Alfalfa');
% X(16) = java.lang.String('Grass-pasture-mowed');
label_names = cell(X);
save batches.meta.mat label_names
end
