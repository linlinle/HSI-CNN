% Difference between Spectral Matrix and Spectral Curve

clc;
clear;
s = getDataSetBasicInformation('Indian_pines');
spectral_matrix_size = (floor(sqrt(s.D)))^2;
d = ceil(sqrt(double(s.class_num)));
% Spectral curves for each category
find_array = zeros(s.class_num,s.D);
for i=1:1:s.class_num;
    [row,col] = find(s.y==i);
    find_array(i,:) = s.x(row(10),col(10),:); % sampling 10th
end

% 1D -> 2D 
show_3D = reshape(find_array(:,1:s.dd)',sqrt(s.dd),sqrt(s.dd),[]);

%  plot Spectral matrix
f1=figure(1);
set(f1,'Position',[0  0 1000 1000])
for j=1:1:double(s.class_num)
    subplot(d,d,j);
    imagesc(show_3D(:,:,j));
end
% plot curve of spectrum
f2=figure(2);
set(f2,'Position',[0  0 1000 1000])
for i=1:1:s.class_num
    plot(find_array(i,:));
    hold on;
end


