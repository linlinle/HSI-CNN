% Output convolution layer core

net=load('net-epoch-100.mat');
net.layers=net.net.layers(1:12);
fig=figure(2) ; clf ; colormap jet;
set(gca,'XtickLabel',[],'YtickLabel',[]);
layer_th = 10;
vl_imarraysc(squeeze(net.net.layers{layer_th}.weights{1}(:,:,1,:)),'spacing',2)
colorbar;
axis off;
title('Fourth convolution layer ') ;

