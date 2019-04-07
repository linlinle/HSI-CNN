function [  ] = save_filters( ~ )
%SAVE_FILTERS Summary of this function goes here
%   Detailed explanation goes here
net=load('net-100.mat');
net.layers=net.net.layers(1:12);
fig=figure(2) ; clf ; colormap jet;
set(gca,'XtickLabel',[],'YtickLabel',[]);
%vl_imarraysc(squeeze(net.net.layers{1}.weights{1}),'spacing',2)
vl_imarraysc(squeeze(net.net.layers{10}.weights{1}(:,:,1,:)),'spacing',2)
%vl_imarraysc(squeeze(net.net.layers{10}.weights{1}(:,:,1,:)),'spacing',2)
colorbar;
axis off;
title('Fourth convolution layer ') ;
%print(fig,'Filters-CIFAR','-dpdf', '-r2200')


end

