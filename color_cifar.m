load PaviaU_gt
imagesc(paviaU_gt);
map = zeros(15,3);
map=[   255   255   255
        0  107  253
%        0  186  253
      111  248  255
%        0  150   50
        0  220    0
      180  255  180
      0      0    0
%      196  166    0
      255  255    0
%       255  200    0
       255    0    0
%       255  100  100
%       255  180  180
       200  100  155
 %     150    0  180 
       255    0  255
];
map=map/255.0;
colormap(map);
caxis([0, 10]); %要显示的数值范围
colorbar('YTick',0:1:11, 'YTickLabel', {'Background', '1', '2', '3', '4', '5', '6', '7', '8', '9',''});% '10', '11', '12', '13','14','15','16',
% colorbar('YTick',0:1:17, 'YTickLabel', {'Background', 'Brocoli_green_weeds_1', 'Brocoli_green_weeds_2', 'Fallow', 'Fallow_rough_plow', 'Fallow_smooth', 'Stubble'...
%     'Celery', 'Grapes_untrained', 'Soil_vinyard_develop', 'Corn_senesced_green_weeds', 'Lettuce_romaine_4wk', 'Lettuce_romaine_5wk', 'Lettuce_romaine_6wk','Lettuce_romaine_7wk','Vinyard_untrained','Vinyard_vertical_trellis',''}...
% ,'FontSize',10);
% colorbar('YTick',0:1:17, 'YTickLabel', {'Background', 'Alfalfa', 'Corn-notill', 'Corn-mintill', 'Corn', 'Grass-pasture', 'Grass-trees'...
%     'Grass-pasture-mowed', 'Hay-windrowed', 'Oats', 'Soybean-notill', 'Soybean-mintill', 'Soybean-clean', 'Wheat','Woods','Buildings-Grass-Trees-Drives','Stone-Steel-Towers',''}...
% ,'FontSize',10);