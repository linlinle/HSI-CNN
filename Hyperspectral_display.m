function [find_array] = Hyperspectral_display()
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
load Salinas_corrected
load Salinas_gt
data_3D = salinas_corrected;
label_3D = double(salinas_gt);
d= size(data_3D,3);
d1 = (floor(sqrt(d)))^2;
label_number = max(max(label_3D));
find_array = zeros(label_number,d);
for i=1:1:label_number;
    [row,col] = find(label_3D==i);
    find_array(i,:) = data_3D(row(10),col(10),:);
end
%show_array = fix(find_array/50)*50;
show_3D = reshape(find_array(:,1:d1)',sqrt(d1),sqrt(d1),[]);
f1=figure(1);
set(f1,'Position',[0  0 1000 1000])
for j=1:1:label_number
    subplot(ceil(sqrt(label_number)),ceil(sqrt(label_number)),j);
    imagesc(show_3D(:,:,j));
end
map = zeros(15,3);
map=[   255   255   255
        0  107  253
        0  186  253
      111  248  255
        0  150   50
        0  220    0
      180  255  180
      0      0    0
      196  166    0
      255  255    0
      255  200    0
      255    0    0
      255  100  100
      255  180  180
      200  100  155
      150    0  180 
      255    0  255];
map=map/255.0;
colormap(map);
f2=figure(2);
set(f2,'Position',[0  0 1000 1000])
for i=1:1:label_number
    plot(find_array(i,:));
    hold on;
end

end

