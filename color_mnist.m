load Botswana_gt
imagesc(Botswana_gt);
map = zeros(15,3);
map=[ 255 255 255
      0 255 255
      0 255 0
      156 102 31
      88 87 86
      255 0 0
      176 23 31
      0 0 0
      255 0 255
      34 139 34
      0 0 255
      25 25 112
      255 215 0
      85 102 0
      160 82 45
      218 112 214
      153 51 250
      ];
map=map/255.0;
colormap(map);
%axis off
caxis([0, 17]); %要显示的数值范围
 colorbar('YTick',0:1:17, 'YTickLabel', {'Background', 'Alfalfa', 'Corn-notill', 'Corn-mintill', 'Corn', 'Grass-pasture', 'Grass-trees'...
     'Grass-pasture-mowed', 'Hay-windrowed', 'Oats', 'Soybean-notill', 'Soybean-mintill', 'Soybean-clean', 'Wheat','Woods','Buildings-Grass-Trees-Drives','Stone-Steel-Towers',''}...
 ,'FontSize',12,'FontWeight','bold');
% colorbar('YTick',0:1:17, 'YTickLabel', {'Background', 'Brocoli_green_weeds_1', 'Brocoli_green_weeds_2', 'Fallow', 'Fallow_rough_plow', 'Fallow_smooth', 'Stubble'...
%     'Celery', 'Grapes_untrained', 'Soil_vinyard_develop', 'Corn_senesced_green_weeds', 'Lettuce_romaine_4wk', 'Lettuce_romaine_5wk', 'Lettuce_romaine_6wk','Lettuce_romaine_7wk','Vinyard_untrained','Vinyard_vertical_trellis',''}...
% ,'FontSize',10);
% colorbar('YTick',0:1:17, 'YTickLabel', {'Background', 'Alfalfa', 'Corn-notill', 'Corn-mintill', 'Corn', 'Grass-pasture', 'Grass-trees'...
%     'Grass-pasture-mowed', 'Hay-windrowed', 'Oats', 'Soybean-notill', 'Soybean-mintill', 'Soybean-clean', 'Wheat','Woods','Buildings-Grass-Trees-Drives','Stone-Steel-Towers',''}...
% ,'FontSize',10);