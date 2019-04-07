function net = Indian_cnn_init(varargin)
% CNN_MNIST_LENET Initialize a CNN similar for MNIST
opts.batchNormalization = false ;%默认打开batchNormalization
opts.networkType = 'simplenn' ;%默认使用Simplenn网络结构
opts = vl_argparse(opts, varargin) ;%根据外部参数修改默认值。

rng('default');%设置随机数发生器，使得每次运行结果可重现
rng(0) ;
%网络结构：conv->maxpool->conv->maxpool->conv->relu->conv->softmaxloss
f=1/100 ;
net.layers = {} ;
net.layers{end+1} = struct('type', 'conv', ...%randn(h,w,d,n)产生4D标准正态分布矩阵，因为MNIST数据集的图像是单通道的，神经元突触为1，故d=1
                           'weights', {{f*randn(3,3,1,20, 'single'), zeros(1, 20, 'single')}}, ...%神经元数量为20个，偏置20
                           'stride', 1, ...%滤波器的滑动步长为1，5*7
                           'pad', 0) ;%图像的边界扩展为0
%net.layers{end+1} = struct('type', 'dropout') ;%RelU层
net.layers{end+1} = struct('type', 'pool', ...
                           'method', 'max', ...%极大池化方式
                           'pool', [2 2], ...%2*2,4个当中取最大
                           'stride', 2, ...%滑动步长为2.
                           'pad', 0) ;%边界无扩展
net.layers{end+1} = struct('type', 'conv', ...%神经元数目50个，因为上层有20神经元，所以本层每个神经元20个突触20个
                           'weights', {{f*randn(3,3,20,50, 'single'),zeros(1,50,'single')}}, ...%偏置数量必须与神经元个数相等，所以50个。
                           'stride', 1, ...
                           'pad', 0) ;
net.layers{end+1} = struct('type', 'pool', ...
                           'method', 'max', ...
                           'pool', [1 1], ...
                           'stride', 1, ...
                           'pad', 0) ;       
%net.layers{end+1} = struct('type', 'dropout') ;%RelU层                       
net.layers{end+1} = struct('type', 'conv', ...%神经元数目500，因为上层50个神经元，所以本层没个神经元突触50个
                           'weights', {{f*randn(3,3,50,500, 'single'),  zeros(1,500,'single')}}, ...%偏置数目500个
                           'stride', 1, ...
                           'pad', 0) ;
net.layers{end+1} = struct('type', 'relu') ;%RelU层
%net.layers{end+1} = struct('type', 'dropout') ;%RelU层                       
net.layers{end+1} = struct('type', 'conv', ...%神经元数目10个，（MNIST总共10类）上层500神经元，所以本层突触500个
                           'weights', {{f*randn(1,1,500,16, 'single'), zeros(1,16,'single')}}, ...%偏置数量10个，卷积核的尺寸为1，全链接
                           'stride', 1, ...
                           'pad', 0) ;
net.layers{end+1} = struct('type', 'softmaxloss') ;%软最大化损失，结合了softmax与logistic损失，能使最后一层输出相互竞争
%net.layers{end+1} = struct('type', 'loss') ;%软最大化损失，结合了softmax与logistic损失，能使最后一层输出相互竞争


% optionally switch to batch normalization根据参数选择添加bath normalization层
if opts.batchNormalization
  net = insertBnorm(net, 1) ;
  net = insertBnorm(net, 4) ;
  net = insertBnorm(net, 7) ;
  %如果opts.batchNormalization为真，则会在原来的nets上插入三层，net结构变为：
  % conv->bnorm->maxpool->conv->maxpool->bnorm->conv->relu->conv->bnorm->softmaxloss
end

% Meta parameters网络结构元数据
net.meta.inputSize = [14 14 1] ;%输入数据尺寸：28*28的单通道
net.meta.trainOpts.learningRate = [0.0005*ones(1,30) 0.0001*ones(1,10) 0.00001*ones(1,10)] ;%学习率
net.meta.trainOpts.numEpochs = 50;%训练回合次数
net.meta.trainOpts.batchSize = 20 ;%一个批次的传递样本数量

% Fill in defaul values网络添加默认属性值
net = vl_simplenn_tidy(net) ;

% Switch to DagNN if requested如果参数要求转换为DagNN默认使用Simplenn网络结构
switch lower(opts.networkType)
  case 'simplenn'
    % done
  case 'dagnn'
    net = dagnn.DagNN.fromSimpleNN(net, 'canonicalNames', true) ;
    net.addLayer('top1err', dagnn.Loss('loss', 'classerror'), ...
      {'prediction', 'label'}, 'error') ;
    net.addLayer('top5err', dagnn.Loss('loss', 'topkerror', ...
      'opts', {'topk', 5}), {'prediction', 'label'}, 'top5err') ;
  otherwise
    assert(false) ;
end

% ----------------------在net的第L层与L+1层添加bnorm层---------------------------------------------
function net = insertBnorm(net, l)
% --------------------------------------------------------------------
assert(isfield(net.layers{l}, 'weights'));%确保第L层有权重项
ndim = size(net.layers{l}.weights{1}, 4);%取得第L层的神经元数量
%初始化一个Bnorm的Layer层
layer = struct('type', 'lrn', ...
               'weights', {{ones(ndim, 1, 'single'), zeros(ndim, 1, 'single')}}, ...%bnorm权重数量与上一层神经元数量相同
               'learningRate', [1 1 0.05], ...
               'weightDecay', [0 0]) ;
net.layers{l}.biases = [] ;
%将新创建的Bnorm layer对象插入net的第L层与第L+1层中间
net.layers = horzcat(net.layers(1:l), layer, net.layers(l+1:end)) ;
