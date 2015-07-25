function h = drawMesh(obj, col, h_axes)
%draw complete tongue mesh
    
    if ~exist('col', 'var') || isempty(col)
        col = 'k';
    end

    if ~exist('h_axes', 'var') || isempty(h_axes)
        h_axes = gca;
    end
    
    h = plot(h_axes, obj.xValNodes, obj.yValNodes, '.', 'Color', col);

end
