clc;close;clear;
load indian_pines_corrected.mat;
load indian_pines_gt.mat;
Data=reshape(indian_pines_corrected,145*145,200);
dataforkmean=mapminmax(Data,0,1);
tic;
A = 17;
[idx]=kmeans(dataforkmean,A,'Distance','cosine','MaxIter',200);
toc;
figure;imshow(reshape(idx,145,145),[]);colormap(jet);
%--分类精度评价--%
