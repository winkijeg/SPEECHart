function [] = plotTongueMesh( obj, col )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

    drawMesh(obj.tongGrid, col)

%     plot(obj.tongGrid.x , obj.tongGrid.y, 'Color', col, 'LineWidth', 1)
%     plot(obj.tongGrid.x' ,obj.tongGrid.y', 'Color', col, 'LineWidth', 1)
    
end

