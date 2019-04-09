% Spectral Curve Distribution of different Objects in Data Set

clc;
clear;
s = getDataSetBasicInformation('Indian_pines');
label=s.y;
image=permute(s.x,[3,1,2]);
d = ceil(sqrt(double(s.class_num)));


f1=figure(1);
set(f1,'Position',[0  0 1000 1000])

for i=1:1:double(s.class_num)
    one_class_index=find(label==i); 
    one_class_dataset=image(:,one_class_index)';
    subplot(d,d,i);
    for k=1:1:length(one_class_index)
        plot(one_class_dataset(k,:));
        hold on;
    end    
end



