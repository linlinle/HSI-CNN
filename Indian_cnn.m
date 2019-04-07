% --主函数，包含 参数配置，网络初始化，数据集准备等操作---------
function [net, info] = Indian_cnn(varargin)
%----CNN_MNIST  Demonstrates MatConvNet on MNIST
%--将“..\..\matlab\vl_setupnn.m”导入当前workspace-----------
run(fullfile(fileparts(mfilename('fullpath')),...
  '..', '..', 'matlab', 'vl_setupnn.m')) ;

opts.batchNormalization = false ;%是否启用batchNorm模块
opts.network = [] ;%选择网络构型simplnn或dagnn
opts.networkType = 'simplenn' ;
[opts, varargin] = vl_argparse(opts, varargin) ;

sfx = opts.networkType ;
if opts.batchNormalization, sfx = [sfx '-bnorm'] ; end
%配置实验结果路径存放：data\minst-baseline-simplenn
opts.expDir = fullfile(vl_rootnn, 'data', 'mnist-out', ['Botswana-nothing-' sfx]) ;%vl_rootnn
[opts, varargin] = vl_argparse(opts, varargin) ;
%Mnist原始数据集的存放路径：E：\matconvnet-1.0-beta18\data\minst
opts.dataDir = fullfile(vl_rootnn, 'data', 'Indian') ; %没有用
%imdb结构体的存放路径：data\minst-baseline-simplenn\imdb.mat
opts.imdbPath = fullfile(opts.expDir, 'imdb.mat');
opts.train = struct() ;
opts = vl_argparse(opts, varargin) ;
%是否使用GPU：如果使用，则opts.train.gpus=[1];为空则不使用
if ~isfield(opts.train, 'gpus'), opts.train.gpus = [1]; end;

% --------------------------------------------------------------------
%                                                         Prepare data
% --------------------------------------------------------------------
%根据前面指定的参数初始化网络
if isempty(opts.network)
  net = Indian_cnn_init('batchNormalization', opts.batchNormalization, ...
    'networkType', opts.networkType) ;
else
  net = opts.network ;
  opts.network = [] ;
end
%从Mnist原始数据提取Imdb结构体，如果存在就直接加载，否则调用getMinstImdb产生
if exist(opts.imdbPath, 'file')
  imdb = load(opts.imdbPath) ;
else
  imdb = getMnistImdb(opts) ;
  mkdir(opts.expDir) ;%产生实验目录
  save(opts.imdbPath, '-struct', 'imdb') ;%保存imdb结构体
end
%函数arrayfun将sprintf函数应用到数组[1:10]的每个元素，将数字标签转为char型类名
net.meta.classes.name = arrayfun(@(x)sprintf('%d',x),1:16,'UniformOutput',false) ;

% --------------------------------------------------------------------
%                                                                Train
% --------------------------------------------------------------------
%根据前面所选择的网络结构型选择对应的训练函数，存储的函数句柄trainfn中
switch opts.networkType
  case 'simplenn', trainfn = @cnn_train ;
  case 'dagnn', trainfn = @cnn_train_dag ;
end
%调用训练函数，开始训练网络：find(imdb.image.set==3)用于找到验证集的样本索引
[net, info] = trainfn(net, imdb, getBatch(opts), ...
  'expDir', opts.expDir, ...
  net.meta.trainOpts, ...
  opts.train, ...
  'val', find(imdb.images.set == 3)) ;

% --根据opts中指定的网络结构型返回一个函数句柄，用于从imdb结构体中取出数据-----
function fn = getBatch(opts)
% --------------------------------------------------------------------
switch lower(opts.networkType)
  case 'simplenn'
    fn = @(x,y) getSimpleNNBatch(x,y) ;
  case 'dagnn'
    bopts = struct('numGpus', numel(opts.train.gpus)) ;
    fn = @(x,y) getDagNNBatch(bopts,x,y) ;
end

% --用于SimpleNN网络构型的数据批次提取函数，参数batch为样本索引-------------
function [images, labels] = getSimpleNNBatch(imdb, batch)
% --------------------------------------------------------------------
images = imdb.images.data(:,:,:,batch) ;
labels = imdb.images.labels(1,batch) ;

% --用于DagNN网络构型的数据批次提取函数，参数batch为样本索引-----------------
function inputs = getDagNNBatch(opts, imdb, batch)
% --------------------------------------------------------------------
images = imdb.images.data(:,:,:,batch) ;
labels = imdb.images.labels(1,batch) ;
if opts.numGpus > 0
  images = gpuArray(images) ;
end
inputs = {'input', images, 'label', labels} ;

% --从MNIST数据集中获取数据，减去图像均值，存放到Imdb结构体中---------------
function imdb = getMnistImdb(opts)
% --------------------------------------------------------------------
[x1,y1,x2,y2]=IndiaToMnist_Datapreprocessing(0,5/6);

%用于标识样本集合中的训练集和测试集的集合：set==1则对应的样本图像和标签被用于训练，==3则用于测试
set = [ones(1,numel(y1)) 3*ones(1,numel(y2))];%numel函数返回向量或矩阵的元素总和：等价于prod（size（A））
data = single(reshape(cat(3, x1, x2),14,14,1,[]));%将x1中的训练集和x2的测试集在地三维拼接起来，构成整体数据集，从unit8变为single
dataMean = mean(data(:,:,:,set == 1), 4);%求出 训练集中所有图像的均值图像
data = bsxfun(@minus, data, dataMean) ;%bsxfun函数将minus算子应用到data的每个元素上，对所有图像减去均值
%填充imdb结构体构造数据集
imdb.images.data = data; %size（data）=【28，28，1,70000】;
imdb.images.data_mean = dataMean;%size(dataMean)=[28,28]
imdb.images.labels = cat(2, y1, y2) ;%将训练集和测试集的标签也拼接起来，size（imdb.images.labels）=[1,70000]
imdb.images.set = set ;%size(set)=[1,70000],unique(set)=[1,3]
imdb.meta.sets = {'train', 'val', 'test'} ;%imdb.images.set==1用于训练，==2用于验证，==3用于测试
imdb.meta.classes = arrayfun(@(x)sprintf('%d',x),1:16,'uniformoutput',false) ;
