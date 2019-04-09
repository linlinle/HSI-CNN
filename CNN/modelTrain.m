% The Main Function of CNN Training

function [net, info] = modelTrain(varargin)

s = getDataSetBasicInformation('Salinas');

opts.batchNormalization = false ;
opts.network = [] ;
opts.networkType = 'simplenn' ;
opts.modelType = 'alexnet';
[opts, varargin] = vl_argparse(opts, varargin) ;

sfx = opts.networkType ;
if opts.batchNormalization, sfx = [sfx '-bnorm'] ; end
opts.expDir = fullfile(vl_rootnn, 'DataOutput', s.name, [opts.modelType '-' sfx]) ; 
[opts, varargin] = vl_argparse(opts, varargin) ;
opts.imdbPath = fullfile(opts.expDir, 'imdb.mat');
opts.train = struct() ;
opts = vl_argparse(opts, varargin) ;

if ~isfield(opts.train, 'gpus'), opts.train.gpus = []; end;

% --------------------------------------------------------------------
%                           Constructing network                              
% --------------------------------------------------------------------
switch opts.modelType
  case 'alexnet'
    net = alexnetInit('networkType', opts.networkType) ;
  case 'mnist'
    net = mnistInit('networkType', opts.networkType) ;
  otherwise
    error('Unknown model type ''%s''.', opts.modelType) ;
end
% if isempty(opts.network)
%   net = CNNModelInitialization('batchNormalization', opts.batchNormalization, ...
%     'networkType', opts.networkType) ;
% else
%   net = opts.network ;
%   opts.network = [] ;
% end
if exist(opts.imdbPath, 'file')
  imdb = load(opts.imdbPath) ;
else
  imdb = getMnistImdb(s) ;
  mkdir(opts.expDir) ;
  save(opts.imdbPath, '-struct', 'imdb') ;
end
net.meta.classes.name = arrayfun(@(x)sprintf('%d',x),1:s.class_num,'UniformOutput',false) ;

% --------------------------------------------------------------------
%                      Train
% --------------------------------------------------------------------
switch opts.networkType
  case 'simplenn', trainfn = @cnn_train ;
  case 'dagnn', trainfn = @cnn_train_dag ;
end
%Call the training function to start training the network
[net, info] = trainfn(net, imdb, getBatch(opts), ...
  'expDir', opts.expDir, ...
  net.meta.trainOpts, ...
  opts.train, ...
  'val', find(imdb.images.set == 3)) ;


function fn = getBatch(opts)
switch lower(opts.networkType)
  case 'simplenn'
    fn = @(x,y) getSimpleNNBatch(x,y) ;
  case 'dagnn'
    bopts = struct('numGpus', numel(opts.train.gpus)) ;
    fn = @(x,y) getDagNNBatch(bopts,x,y) ;
end

function [images, labels] = getSimpleNNBatch(imdb, batch)
images = imdb.images.data(:,:,:,batch) ;
labels = imdb.images.labels(1,batch) ;

function inputs = getDagNNBatch(opts, imdb, batch)
images = imdb.images.data(:,:,:,batch) ;
labels = imdb.images.labels(1,batch) ;
if opts.numGpus > 0
  images = gpuArray(images) ;
end
inputs = {'input', images, 'label', labels} ;

function imdb = getMnistImdb(s)
[x1,y1,x2,y2]=twoDimensionalizationPixelSpectrum(s,0,5/6);


set = [ones(1,numel(y1)) 3*ones(1,numel(y2))];% train=1;test=3
data = single(reshape(cat(3, x1, x2),sqrt(s.dd),sqrt(s.dd),1,[]));% Spectral matrix
dataMean = mean(data(:,:,:,set == 1), 4);
data = bsxfun(@minus, data, dataMean) ;

imdb.images.data = data; 
imdb.images.data_mean = dataMean;
imdb.images.labels = cat(2, y1, y2);
imdb.images.set = set ;
imdb.meta.sets = {'train', 'val', 'test'} ;
imdb.meta.classes = arrayfun(@(x)sprintf('%d',x),1:s.class_num,'uniformoutput',false) ;
