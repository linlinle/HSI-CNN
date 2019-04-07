function [find_array] = Hyperspectral_display()
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
load Indian_pines_corrected
load Indian_pines_gt
data_3D = indian_pines_corrected;
label_3D = double(indian_pines_gt);
d= size(data_3D,3);
%label_number = max(max(label_3D));
find_array = zeros(100,d);
%for i=1:1:label_number;
    [row,col] = find(label_3D==9);
    for j=1:1:10;
        find_array(j,:) = data_3D(row(j),col(j),:);
    end
%end

f1=figure(1);
set(f1,'Position',[0  0 1000 1000])
for k=1:1:10
    plot(find_array(k,:));
    hold on;
end

end

