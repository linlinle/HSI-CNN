function [ s ] = getDataSetBasicInformation( HSIDataSet) 
% @ HSIDataSet: 'Indian_pines'   'Salinas'  'PaviaU' ...
data_struct = load(HSIDataSet);
label_struct = load([HSIDataSet,'_gt']);
data = getfield(data_struct,char(fieldnames(data_struct)));
label = getfield(label_struct,char(fieldnames(label_struct)));
[H,W,D] = size(data);
class_num = max(max(label));
dd = (floor(sqrt(D)))^2;
s.name = HSIDataSet;
s.x = data;
s.y = double(label);
s.H = H;
s.W = W;
s.D = D;
s.class_num = class_num;
s.dd = dd;
end

