function plotMidSagittSlice( obj )

    subplot('position', [0 0 1 1])
    set(gca, 'Color',[0.8 0.1 0.8]);
    
    imshow(obj.sliceData, 'XData', obj.xdataSlice, 'YData', obj.ydataSlice)
    
    axis on; 
    axis equal; 
    hold on;
    
    set(gca, 'YDir', 'normal')

end

