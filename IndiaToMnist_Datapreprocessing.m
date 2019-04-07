function [train_data, train_label, test_data, test_label] = IndiaToMnist_Datapreprocessing(Normalized,proportion)
%CNN_HSIDATEPROCESS Summary of this function goes here
%   Detailed explanation goes here
load Botswana
load Botswana_gt
data_3D = Botswana;
label_3D = Botswana_gt; 
[ m,n,d] = size(data_3D);
label_number = max(max(label_3D));
d1 = (floor(sqrt(d)))^2;
label_list = 1:label_number;
one = zeros(1,label_number);
for i= 1:1:label_number
    one(i)=length(find(label_3D==label_list(i)));
end
data_2D = hyperConvert2d(data_3D(:,:,1:d1));
u = mean(data_2D.').';
data_2D = data_2D - repmat(u, 1, m*n);
%%                πÈ“ªªØ
switch(Normalized)
    case 1 
        data_2D = hyperNormalize(data_2D); % 0 ~ 1
    case -1
        data_2D = mapminmax(data_2D);     %-1 ~ 1
    otherwise        
end
%%             
label_2D = reshape(label_3D,m*n,1);
label_data = [label_2D,data_2D'];
data_label_order_train = [];
data_label_order_test = [];
for i=1:1:label_number
    row_index = label_data(:,1) == label_list(i);
    data_label_unit = label_data(row_index,:);
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%very important%%%%%%%%%%%
    RandIndex = randperm(one(i)); 
    data_label_unit = data_label_unit( RandIndex,: );
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    train_one = floor(one(i)*proportion);
    test_one = one(i)-train_one;    
%       if (i==1||i==7||i==9||i==16)
%            K=train_one;
%            train_one = test_one;
%            test_one =K;
%       end
    label_train_mid = data_label_unit(1:train_one,:);
    label_test_mid = data_label_unit(train_one+1:one(i),:);
    data_label_order_train = [data_label_order_train;label_train_mid];
    data_label_order_test = [data_label_order_test;label_test_mid];
        
end
RandIndex = randperm( length( data_label_order_train ) ); 
data_label_random_train = data_label_order_train( RandIndex,: );
RandIndex = randperm( length( data_label_order_test ) );
data_label_random_test = data_label_order_test( RandIndex,: );
train_num = size(data_label_random_train,1);
test_num = size(data_label_random_test,1);
train_data = (data_label_random_train(:,2:d1+1))';
train_label =data_label_random_train(:,1)';
test_data = (data_label_random_test(:,2:d1+1))';
test_label = data_label_random_test(:,1)';
train_data = permute(reshape(train_data,sqrt(d1),sqrt(d1),train_num),[1 2 3]);
test_data = permute(reshape(test_data,sqrt(d1),sqrt(d1),test_num),[1 2 3]);
end
