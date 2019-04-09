# HSI-CNN
This project is a hyperspectral supervised classification model based on convolution neural network.
You can get more information from these two papers：[Overlappooling](https://link.springer.com/content/pdf/10.1007%2Fs11063-018-9876-7.pdf) [2D-Spectrum](https://www.hindawi.com/journals/js/2018/8602103/) 
## Dependency
* [MatConvNet](http://www.vlfeat.org/matconvnet/)
* [LIBSVM](https://www.csie.ntu.edu.tw/~cjlin/libsvm/)
## setup
1. setup MatConvNet with CPU or GPU
2. Place the project directly in a matlab environment with the dependency paths described above
## running program
### data processing
* Data sets used include ‘Indian_Pines’ ‘Salinas’ ‘PaviaU’ ....
* Remove “_corrected" from mat file name
### SVM
Run /SVM/HSIClassificationSVM.m
### CNN
Run /CNN/modelTrain.m
