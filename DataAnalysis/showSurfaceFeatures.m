% Using Different Colors to Display Different Ground Objects

clc;
clear;
s = getDataSetBasicInformation('Indian_pines');
imagesc(s.y);
changeColorbar(s.class_num)