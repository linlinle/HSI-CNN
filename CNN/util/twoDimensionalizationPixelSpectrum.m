% Two-Dimensionalization of Pixel Spectrum

function [x1,y1,x2,y2] = twoDimensionalizationPixelSpectrum(s,Normalized,proportion)

Total_sample_num = s.H*s.W;
Category_Sort = 1:s.class_num;
Each_category_num = zeros(1,s.class_num);
for i= 1:1:s.class_num
    Each_category_num(i)=length(find(s.y==Category_Sort(i)));
end
before_reshape_x = hyperConvert2d(s.x(:,:,1:s.dd));
u = mean(before_reshape_x.').';
before_reshape_x = before_reshape_x - repmat(u, 1, Total_sample_num);

%                normalization
switch(Normalized)
    case 1 
        before_reshape_x = hyperNormalize(before_reshape_x); % 0 ~ 1
    case -1
        before_reshape_x = mapminmax(before_reshape_x);     %-1 ~ 1
    otherwise        
end
           
before_reshape_y = reshape(s.y,Total_sample_num,1);
before_reshape_yx = [before_reshape_y,before_reshape_x'];
yx_train = [];
yx_test = [];
for i=1:1:s.class_num
    row_index = before_reshape_yx(:,1) == Category_Sort(i);
    Single_category_yx = before_reshape_yx(row_index,:);
    
    RandIndex = randperm(Each_category_num(i));             %Random order
    Single_category_yx = Single_category_yx( RandIndex,: );

    train_index = floor(Each_category_num(i)*proportion);
    Single_category_yx_train = Single_category_yx(1:train_index,:);
    Single_category_yx_test = Single_category_yx(train_index+1:Each_category_num(i),:);
    yx_train = [yx_train;Single_category_yx_train];
    yx_test = [yx_test;Single_category_yx_test];
        
end

RandIndex = randperm( length( yx_train ) );         %   Random order between categories
yx_train_random = yx_train( RandIndex,: );
RandIndex = randperm( length( yx_test ) );
yx_test_random = yx_test( RandIndex,: );

train_set_num = size(yx_train_random,1);
test_set_num = size(yx_test_random,1);
train_set_x = (yx_train_random(:,2:s.dd+1))';         %   split x and y
y1 =yx_train_random(:,1)';
test_set_x = (yx_test_random(:,2:s.dd+1))';
y2 = yx_test_random(:,1)';


x1 = permute(reshape(train_set_x,sqrt(s.dd),sqrt(s.dd),train_set_num),[1 2 3]);
x2 = permute(reshape(test_set_x,sqrt(s.dd),sqrt(s.dd),test_set_num),[1 2 3]);
end
