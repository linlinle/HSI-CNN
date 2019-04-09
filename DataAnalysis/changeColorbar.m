
function [] = changeColorbar( class_num )
basic_map=[   255   255   255
        0  107  253
        0  186  253
      111  248  255
        0  150   50
        0  220    0
      180  255  180
      0      0    0
      196  166    0
      255  255    0
      255  200    0
      255    0    0
      255  100  100
      255  180  180
      200  100  155
      150    0  180 
      255    0  255];
map=basic_map/255.0;
colormap(map(1:class_num+1,:));
basic_color_YTickLabel = {'Background', '1', '2', '3', '4', '5', '6', '7', '8', '9','10','11','12','13','14','15','16'};
colorbar('YTick',0:class_num/(class_num+1):class_num+2, 'YTickLabel',[basic_color_YTickLabel(1:class_num+1),' ']);
end

